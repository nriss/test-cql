# Documentation du POC CQL - POC CQL - ROR v0.1.0

## Documentation du POC CQL

### Qu'est-ce que CQL ?

CQL (Clinical Quality Language) est un langage standardisé par HL7 pour exprimer des règles cliniques, des critères d'éligibilité et des indicateurs qualité de manière lisible et interopérable.

Dans FHIR, CQL s'intègre via :

* **`Library`** : contient le code CQL compilé en ELM (Expression Logical Model, format XML/JSON)
* **`Measure`** : définit les populations à évaluer (InitialPopulation, Denominator, Numerator) en référençant une Library
* **`$evaluate-measure`** : opération FHIR qui exécute le CQL contre les données du serveur et retourne un `MeasureReport`

### Périmètre de ce POC

Ce POC valide la chaîne complète CQL → HAPI FHIR sur deux exemples progressifs :

| | | | |
| :--- | :--- | :--- | :--- |
| 01 | `poc/01-exemple-generique` | Patients fictifs | Proportion de patients ≥ 65 ans |
| 02 | `poc/02-ror` | **(à venir)** | Règles qualité sur données ROR |

### Architecture technique

```
CQL source (.cql)
    ↓ base64
Library (FHIR resource)  ←── Measure (FHIR resource)
    ↓                              ↓
HAPI FHIR JPA Server  ←── POST $evaluate-measure
    ↓
MeasureReport (résultat)

```

Le moteur CQL est intégré à HAPI FHIR via le module **Clinical Reasoning** (`hapi.fhir.cr.enabled: true`). Il n'y a pas d'outil externe à installer : HAPI FHIR compile et exécute le CQL directement.

### Lancer le POC 01

```
cd poc/01-exemple-generique
docker compose up -d   # démarre HAPI FHIR v8 (port 8080)
./evaluate.sh          # charge les données et évalue la Measure
docker compose down    # arrête le serveur

```

**Résultat attendu** : 3 patients sur 5 dans le numérateur (Martin 1945, Dubois 1958, Thomas 1938).

### Modifier le CQL

1. Éditer`poc/01-exemple-generique/cql/HelloCQL.cql`
1. Régénérer le base64 :

```
base64 -i cql/HelloCQL.cql | tr -d '\n'

```


1. Remplacer la valeur`data`dans`fhir/library-hello-cql.json`
1. Relancer`./evaluate.sh`

### Références

* Spécification CQL : [https://cql.hl7.org/](https://cql.hl7.org/)
* IG Using CQL with FHIR : [https://build.fhir.org/ig/HL7/cql-ig/](https://build.fhir.org/ig/HL7/cql-ig/)
* Module Clinical Reasoning FHIR : [https://hl7.org/fhir/R4/clinicalreasoning-module.html](https://hl7.org/fhir/R4/clinicalreasoning-module.html)

