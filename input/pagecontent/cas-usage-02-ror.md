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
// Note : l'opérateur `contains` de ce moteur CQL se comporte comme une égalité stricte sur les
// chaînes (et non comme une recherche de sous-chaîne) — on utilise donc PositionOf(...) >= 0.
define "NomContientUrgence":
  (Organization.name is not null and PositionOf('urgence', Lower(Organization.name)) >= 0)
    or exists (Organization.alias A where PositionOf('urgence', Lower(A)) >= 0)

// Numérateur : Organization concernées et NON conformes (pas d'"urgence" dans le nom)
define "Numerator":
  "InitialPopulation" and not "NomContientUrgence"
```

Le `Numerator` correspond directement aux `Organization` non conformes recherchées par l'issue : pas besoin de post-traitement, il suffit de récupérer la liste des sujets du numérateur.

#### Bug trouvé et corrigé : `contains` ne fait pas de recherche de sous-chaîne

Une première version de `NomContientUrgence` utilisait `Lower(Organization.name) contains 'urgence'`. En vérifiant cette règle en détail, ce test s'est révélé **systématiquement faux** dès que le nom n'est pas exactement égal à "urgence" — ce qui aurait fait classer en non-conforme la quasi-totalité des `Organization` réellement conformes (typiquement nommées "Service des Urgences de ...", jamais juste "Urgence").

Isolé avec une bibliothèque CQL minimale ne contenant que des littéraux (donc indépendante de toute donnée FHIR) :

```cql
define "T1": 'hello world' contains 'world'   // → false (attendu : true)
define "T2": 'abc' contains 'abc'              // → true
define "T3": Contains('hello world', 'world')  // → false (la fonction se comporte pareil)
define "T4": PositionOf('world', 'hello world') // → 6 (la recherche de sous-chaîne, elle, fonctionne)
```

Sur ce moteur CQL (celui embarqué dans `hapiproject/hapi:v8.10.0-2`), l'opérateur `contains` et la fonction `Contains()` appliqués à des chaînes se comportent comme une **égalité stricte**, pas comme une recherche de sous-chaîne — `T1` et `T3` devraient valoir `true` selon la spécification CQL, mais valent `false` ici. `PositionOf`, en revanche, fonctionne correctement (retourne bien la position de la sous-chaîne, ou `-1` si absente). La règle a donc été corrigée pour utiliser `PositionOf(pattern, argument) >= 0` plutôt que `contains`, et revérifiée sur les 3 `Organization` de test (résultats ci-dessous) ainsi que sur des cas isolés supplémentaires (nom contenant "urgence", alias contenant "urgence", activité/mode ne correspondant pas à la règle, Organization sans aucun `HealthcareService`) — tous conformes à l'attendu après correction.

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

Les 3 `Organization` de test ont été revérifiées individuellement de cette façon (chacune comme première évaluation suivant un redémarrage propre du conteneur, cf. l'instabilité décrite plus bas), ainsi que des cas non couverts par ces 3 exemples (activité ou mode ne correspondant pas à la règle, "urgence" présent seulement dans `alias`, `Organization` sans aucun `HealthcareService`) :

| Organization | `ConcerneeParObligationDeNommage` | `NomContientUrgence` | `Numerator` (non conforme) |
|---|---|---|---|
| `org-ch-exemple` (activité 157, mode 33, name="CH Exemple") | true | false | **true** |
| `org-service-urgences` (activité 249, mode 33, name="Service des Urgences du CH Exemple") | true | true | false |
| `org-clinique-exemple` (activité 157, mode 33, name="Clinique Exemple") | true | false | **true** |
| activité 157, mode 99 (hors règle), name sans "urgence" | false | false | false |
| activité 999 (hors règle), mode 33, name sans "urgence" | false | false | false |
| pas de `HealthcareService` du tout | false | false | false |
| alias contenant "urgence", name neutre | — | true | — |

Tous ces résultats correspondent à l'attendu.

**Mais `$evaluate-measure` ne fonctionne pas correctement dès que plusieurs `Organization` sont présentes sur le serveur** — ce qui est le cas d'usage réel (identifier les non-conformes *parmi* toutes les Organization du ROR) :

- Sans paramètre `subject` explicite, la Measure évalue `subjectCount: 0` (log HAPI) et renvoie un `MeasureReport` avec tous les compteurs à `0`.
- Avec un `subject` explicite (`reportType=subject`, `subject=Organization/org-ch-exemple`) et les 3 `Organization` présentes, `$evaluate-measure` répond sans erreur mais avec des compteurs à `0`.
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

**Cause racine identifiée dans le code source** — ce n'est **pas** une limitation de conception "Patient uniquement" du moteur CQL (`cqframework/cql-engine` est générique sur le nom du contexte), mais un bug précis et localisé dans la couche `clinical-reasoning` de HAPI FHIR :

- `LibraryEngine.buildContextParameter(String patientId)` (`cqframework/clinical-reasoning`, module `cqf-fhir-cql`, `LibraryEngine.java` lignes ~68-78) **hardcode le nom du contexte CQL à `"Patient"`**, quel que soit le type réel de la ressource passée en `subject`. Pour `subject=Organization/org-ch-exemple`, le moteur enregistre `contextValues["Patient"] = "Organization/org-ch-exemple"` au lieu de `contextValues["Organization"] = "org-ch-exemple"`.
- Quand `cql-engine` évalue notre library (`context Organization`), il appelle `context.enterContext("Organization")` puis `Context.getCurrentContextValue()` (`cql-engine`, `Context.java` lignes ~769-791) : la clé `"Organization"` est absente de `contextValues` (seule `"Patient"` a été renseignée) → la valeur de contexte est `null`.
- Ce `null` remonte dans `BaseRetrieveProvider.populateContextSearchParams(...)`, qui ne pose **aucun filtre par id** quand la valeur de contexte est `null` : `[Organization]` retourne alors toutes les `Organization` du serveur, sans filtrage.
- Comme `context Organization` fait que toute référence non qualifiée à `Organization` est compilée en `singleton from [Organization]`, cette liste non filtrée déclenche `SingletonFromEvaluator` (`cql-engine`) dès qu'il y a plus d'une `Organization` — exactement l'erreur observée. Avec une seule `Organization` sur le serveur, le retrieve non filtré ne renvoie qu'1 élément par coïncidence : ça "marche", mais le filtrage par id n'a en réalité jamais fonctionné.

Le même hardcoding explique vraisemblablement aussi le comportement silencieux de `$evaluate-measure` (contexte manquant → retrieves vides ou non filtrés → populations à `0`), mais ce second chemin de code n'a pas été vérifié aussi précisément dans les sources.

> Réserve : le code inspecté est celui de la branche `main` actuelle de `cqframework/clinical-reasoning` et `cqframework/cql-engine`, pas confirmé identique à la version exacte packagée dans l'image Docker `hapiproject/hapi:v8.10.0-2` utilisée ici. Aucune issue GitHub existante trouvée documentant précisément ce bug.

**Instabilité supplémentaire observée sur `Library/$evaluate` (isolé, une seule Organization)** : même dans le scénario de contournement (une seule `Organization` sur le serveur), les résultats se sont révélés fiables **juste après un redémarrage du conteneur HAPI FHIR**, mais parfois incorrects (`ConcerneeParObligationDeNommage` à `false` alors que les données chargées le justifiaient) lors d'appels répétés sur la même instance après plusieurs cycles de création/suppression de ressources — alors qu'une recherche FHIR classique (`GET /HealthcareService`) confirmait au même moment que la ressource attendue était bien présente et indexée. La cause exacte n'a pas été identifiée dans le code source (contrairement au bug de contexte ci-dessus) ; il est possible qu'un cache interne au module Clinical Reasoning ne soit pas invalidé correctement entre deux évaluations sur la même instance. Pour obtenir un résultat fiable dans ce POC, chaque cas a été revérifié comme première évaluation suivant un redémarrage propre du conteneur.

**Conclusion du POC** : la règle CQL exprimant la logique métier est correcte et validée unitairement (voir résultat `Library/$evaluate` ci-dessus). Ce qui bloque l'exécution en masse sur un contexte non-`Patient` est un bug identifié et sourcé dans `clinical-reasoning` (construction du paramètre de contexte à partir du `subject` REST, sans tenir compte du type de ressource réel), pas une limitation du moteur CQL lui-même. Pistes pour une itération ultérieure : ouvrir un signalement upstream sur `cqframework/clinical-reasoning` (la cause est identifiée avec fichiers/lignes précis) ; en attendant, reformuler la règle avec `context Unfiltered` (une seule évaluation qui parcourt elle-même tous les `Organization` du serveur et retourne la liste des non-conformes, sans dépendre du mécanisme de `subject` de `$evaluate-measure`) ; ou tester une version plus récente de HAPI FHIR si le correctif y est déjà intégré.
