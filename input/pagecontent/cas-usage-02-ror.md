### Cas d'usage 02 — ROR : Règle #1 — Organization avec le nom "Urgence"

**Objectif** ([issue #1](https://github.com/nriss/test-cql/issues/1)) : identifier les `Organization` du ROR non conformes à la règle de nommage suivante :

> Une `Organization` doit obligatoirement avoir "urgence" dans son nom si elle propose un `HealthcareService` dont :
>
> - l'activité opérationnelle est **157** ou **249**, ET
> - le mode de prise en charge est **33**.

#### Modélisation ROR utilisée

D'après le profil [ROROrganization](https://interop.esante.gouv.fr/ig/fhir/ror/StructureDefinition-ror-organization.html) et le profil `RORHealthcareService` de l'IG ROR :

| Notion métier | Élément FHIR | ValueSet / CodeSystem |
|---|---|---|
| Nom de l'Organization | `Organization.name` / `Organization.alias` | — |
| Activité Opérationnelle | `HealthcareService.specialty` (slice `operationalActivity`) | `JDV_J17_ActiviteOperationnelle_ROR` — codes issus de `TRE_R211-ActiviteOperationnelle` |
| Mode de prise en charge | `HealthcareService.characteristic` (slice `careMode`) | `JDV_J19_ModePriseEnCharge_ROR` — codes issus de `TRE_R213-ModePriseEnCharge` |
| Lien HealthcareService → Organization | `HealthcareService.providedBy` | Reference(Organization) |

Codes utilisés (vérifiés sur le [serveur de terminologie MOS](https://mos.esante.gouv.fr/)) :

| Code | Système | Libellé |
|---|---|---|
| `157` | `TRE_R211-ActiviteOperationnelle` | Urgences polyvalentes hospitalières |
| `249` | `TRE_R211-ActiviteOperationnelle` | Urgences pédiatriques hospitalières |
| `33` | `TRE_R213-ModePriseEnCharge` | Accueil des urgences |

> Ce POC reste volontairement léger côté modélisation : les exemples sont des `Organization`/`HealthcareService` FHIR standard (pas de conformité aux profils `ROROrganization`/`RORHealthcareService`, pas de dépendance ajoutée à l'IG ROR dans `sushi-config.yaml`), comme pour le cas d'usage 01.

#### Règle CQL

Source : `input/cql/OrganizationNomUrgence.cql`

```cql
library OrganizationNomUrgence version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

codesystem "TRE_R211-ActiviteOperationnelle": 'https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle'
codesystem "TRE_R213-ModePriseEnCharge": 'https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge'

code "Urgences polyvalentes hospitalières": '157' from "TRE_R211-ActiviteOperationnelle"
code "Urgences pédiatriques hospitalières": '249' from "TRE_R211-ActiviteOperationnelle"
code "Accueil des urgences": '33' from "TRE_R213-ModePriseEnCharge"

context Organization

// HealthcareService rattachés à l'Organization courante
define "HealthcareServicesLies":
  [HealthcareService] HS
    where HS.providedBy.reference = 'Organization/' + Organization.id

// Concernée par l'obligation de nommage : au moins un HealthcareService avec une activité
// opérationnelle "urgences" (157 ou 249) ET un mode de prise en charge "accueil des urgences" (33)
define "ConcerneeParObligationDeNommage":
  exists (
    "HealthcareServicesLies" HS
      where (
        exists (HS.specialty S where FHIRHelpers.ToConcept(S) ~ "Urgences polyvalentes hospitalières")
        or exists (HS.specialty S where FHIRHelpers.ToConcept(S) ~ "Urgences pédiatriques hospitalières")
      )
      and exists (HS.characteristic C where FHIRHelpers.ToConcept(C) ~ "Accueil des urgences")
  )

define "InitialPopulation":
  "ConcerneeParObligationDeNommage"

define "Denominator":
  "InitialPopulation"

// Le nom (ou un alias) de l'Organization contient "urgence"
define "NomContientUrgence":
  (Organization.name is not null and Lower(Organization.name) contains 'urgence')
    or exists (Organization.alias A where Lower(A) contains 'urgence')

// Numérateur : Organization concernées et NON conformes (pas d'"urgence" dans le nom)
define "Numerator":
  "InitialPopulation" and not "NomContientUrgence"
```

Le `Numerator` correspond directement aux `Organization` non conformes recherchées par l'issue : pas besoin de post-traitement, il suffit de récupérer la liste des sujets du numérateur.

#### Données de test

3 `Organization` fictives et leur `HealthcareService` associé, définis dans `input/fsh/Examples/Organizations-ror-regle-01.fsh` et `input/fsh/Examples/HealthcareServices-ror-regle-01.fsh` :

| Organization | Nom | HealthcareService lié | Activité | Mode | Concernée ? | Conforme ? |
|---|---|---|---|---|---|---|
| `org-ch-exemple` | CH Exemple | `hs-ch-exemple-urgences` | 157 | 33 | ✅ oui | ❌ **non** (pas "urgence" dans le nom) |
| `org-service-urgences` | Service des Urgences du CH Exemple | `hs-service-urgences-pediatriques` | 249 | 33 | ✅ oui | ✅ oui |
| `org-clinique-exemple` | Clinique Exemple | `hs-clinique-exemple-urgences` | 157 | 33 | ✅ oui | ❌ **non** (pas "urgence" dans le nom) |

#### Étapes de lancement

##### 1. Démarrer HAPI FHIR

```bash
docker compose up -d
```

##### 2. Générer les ressources FHIR avec SUSHI

```bash
sushi .
```

Compile les fichiers FSH en ressources FHIR JSON dans `fsh-generated/resources/` (Library, Measure, Organization, HealthcareService).

##### 3 à 6. Charger la Library, la Measure, les Organization, les HealthcareService, et évaluer

Ces étapes sont automatisées par `./evaluate-02-ror-regle-01.sh` (nécessite que `fsh-generated/` existe) :

```bash
./evaluate-02-ror-regle-01.sh
```

Le script charge `Library/OrganizationNomUrgence`, `Measure/OrganizationsNonConformesNomUrgence`, les 3 `Organization` et les 3 `HealthcareService`, puis appelle `$evaluate-measure` avec `reportType=subject-list`.

#### Résultat observé

**La règle CQL elle-même est correcte** : en isolant un seul `Organization` sur le serveur et en appelant `Library/OrganizationNomUrgence/$evaluate` avec `subject=Organization/org-ch-exemple`, chaque `define` renvoie exactement le résultat attendu :

```json
{
  "resourceType": "Parameters",
  "parameter": [
    { "name": "ConcerneeParObligationDeNommage", "valueBoolean": true },
    { "name": "InitialPopulation",                "valueBoolean": true },
    { "name": "Denominator",                      "valueBoolean": true },
    { "name": "NomContientUrgence",                "valueBoolean": false },
    { "name": "Numerator",                        "valueBoolean": true }
  ]
}
```

`org-ch-exemple` est bien reconnue comme concernée (`InitialPopulation`/`Denominator` = true) et non conforme (`Numerator` = true, car `NomContientUrgence` = false) — la logique CQL (retrieve `HealthcareService` par `providedBy`, équivalence de code via `FHIRHelpers.ToConcept(...) ~ "..."`, test sur `name`/`alias`) fonctionne comme conçu.

**Mais `$evaluate-measure` ne fonctionne pas correctement dès que plusieurs `Organization` sont présentes sur le serveur** — ce qui est le cas d'usage réel (identifier les non-conformes *parmi* toutes les Organization du ROR) :

- Sans paramètre `subject` explicite, la Measure évalue `subjectCount: 0` (log HAPI) et renvoie un `MeasureReport` avec tous les compteurs à `0` — le moteur ne parcourt tout simplement pas les `Organization` du serveur comme il le ferait pour des `Patient`.
- Avec un `subject` explicite (`reportType=subject`, `subject=Organization/org-ch-exemple`) et les 3 `Organization` présentes, `$evaluate-measure` répond sans erreur mais avec des compteurs à `0` — la résolution du contexte ne filtre pas correctement sur le sujet demandé.
- Appeler directement `Library/OrganizationNomUrgence/$evaluate` avec un `subject` alors que plusieurs `Organization` existent renvoie une erreur explicite :

  ```json
  {
    "resourceType": "Parameters",
    "parameter": [{
      "name": "evaluation error",
      "resource": {
        "resourceType": "OperationOutcome",
        "issue": [{
          "severity": "error",
          "code": "exception",
          "diagnostics": "Expected a list with at most one element, but found a list with multiple elements."
        }]
      }
    }]
  }
  ```

**Conclusion du POC** : le module Clinical Reasoning de HAPI FHIR v8.10.0-2 est conçu et testé pour des Measures dont le sujet est `Patient` ; la résolution du contexte pour un `subjectType` différent (ici `Organization`) n'y est pas correctement câblée — dès qu'il y a plusieurs ressources du type de contexte sur le serveur, le moteur ne parvient plus à isoler le bon sujet (erreur explicite via `Library/$evaluate`, silence via `$evaluate-measure`). La règle CQL exprimant la logique métier est correcte et validée unitairement ; c'est l'exécution en masse via `$evaluate-measure` sur un contexte non-`Patient` qui n'est pas opérationnelle en l'état sur ce serveur. Deux pistes à explorer dans une itération ultérieure : reformuler la règle avec `context Unfiltered` (une seule évaluation qui parcourt elle-même tous les `Organization` du serveur et retourne la liste des non-conformes, sans dépendre du découpage par sujet de `$evaluate-measure`), ou tester un moteur/version CQL différent (ex. CQF Ruler récent, ou le CQL Translation Service en `$cql` direct plutôt que `$evaluate-measure`).
