# 01 — Exemple générique - POC CQL - ROR v0.1.0

## 01 — Exemple générique

### Cas d'usage 01 — Exemple générique

**Objectif** : valider la stack HAPI FHIR + CQL avec un exemple standard avant d'aborder les données ROR.

**Règle CQL** : calculer la proportion de patients âgés de 65 ans et plus dans une population fictive.

#### Données de test

5 patients fictifs définis dans `input/fsh/Examples/Patients-exemples.fsh` :

| | | | |
| :--- | :--- | :--- | :--- |
| Jean Martin | 1945-03-12 | ✅ oui | Numérateur |
| Marie Dubois | 1958-07-22 | ✅ oui | Numérateur |
| Pierre Bernard | 1990-11-05 | ❌ non | Dénominateur seulement |
| Lucie Thomas | 1938-01-30 | ✅ oui | Numérateur |
| Sophie Petit | 2000-06-15 | ❌ non | Dénominateur seulement |

#### CQL

Source : `input/cql/HelloCQL.cql`

```
library HelloCQL version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

context Patient

// Population initiale : tous les patients
define "InitialPopulation":
  true

define "Denominator":
  true

// Numérateur : patients de 65 ans et plus
define "Numerator":
  AgeInYears() >= 65

```

#### Étapes de lancement

##### 1. Démarrer HAPI FHIR

```
docker compose up -d

```

HAPI FHIR v8 démarre sur le port 8080 avec le module Clinical Reasoning activé (`hapi.fhir.cr.enabled: true`). Prévoir ~60 secondes au premier démarrage.

##### 2. Générer les ressources FHIR avec SUSHI

```
sushi .

```

Compile les fichiers FSH en ressources FHIR JSON dans `fsh-generated/resources/` (Library, Measure, Patients).

##### 3. Charger la Library

La Library embarque le CQL encodé en base64. HAPI FHIR la compilera en ELM à l'évaluation.

```
curl -X PUT http://localhost:8080/fhir/Library/HelloCQL \
  -H "Content-Type: application/fhir+json" \
  -d @fsh-generated/resources/Library-HelloCQL.json

```

##### 4. Charger la Measure

La Measure référence la Library et définit les trois populations : `InitialPopulation`, `Denominator`, `Numerator`.

```
curl -X PUT http://localhost:8080/fhir/Measure/Patients65Plus \
  -H "Content-Type: application/fhir+json" \
  -d @fsh-generated/resources/Measure-Patients65Plus.json

```

##### 5. Charger les patients

```
for patient in pat-martin pat-dubois pat-bernard pat-thomas pat-petit; do
  curl -X PUT http://localhost:8080/fhir/Patient/${patient} \
    -H "Content-Type: application/fhir+json" \
    -d @fsh-generated/resources/Patient-${patient}.json
done

```

##### 6. Évaluer la Measure

L'opération `$evaluate-measure` déclenche l'exécution du CQL contre toute la population Patient présente sur le serveur pour la période donnée.

```
curl -X POST "http://localhost:8080/fhir/Measure/Patients65Plus/\$evaluate-measure" \
  -H "Content-Type: application/fhir+json" \
  -d '{
    "resourceType": "Parameters",
    "parameter": [
      {"name": "periodStart", "valueDate": "2020-01-01"},
      {"name": "periodEnd",   "valueDate": "2026-12-31"},
      {"name": "reportType",  "valueCode": "population"}
    ]
  }'

```

> Les étapes 3 à 6 sont automatisées par `./evaluate-01-generique.sh` (nécessite que `fsh-generated/` existe).

#### Résultat — MeasureReport

```
{
  "resourceType": "MeasureReport",
  "status": "complete",
  "type": "summary",
  "measure": "https://interop.esante.gouv.fr/ig/fhir/test-cql/Measure/Patients65Plus|1.0.0",
  "period": {
    "start": "2020-01-01",
    "end":   "2026-12-31"
  },
  "group": [{
    "id": "seniors",
    "population": [
      { "id": "initial-population", "code": { "coding": [{ "code": "initial-population" }] }, "count": 5 },
      { "id": "denominator",        "code": { "coding": [{ "code": "denominator"        }] }, "count": 5 },
      { "id": "numerator",          "code": { "coding": [{ "code": "numerator"          }] }, "count": 3 }
    ],
    "measureScore": { "value": 0.6 }
  }]
}

```

| | | |
| :--- | :--- | :--- |
| `initial-population` | 5 | Tous les patients du serveur |
| `denominator` | 5 | Même population (critère`true`) |
| `numerator` | 3 | Martin (1945), Dubois (1958), Thomas (1938) |
| `measureScore` | 0.6 | 3 / 5 =**60 %**de la population a ≥ 65 ans |

