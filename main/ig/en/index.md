# Accueil - POC CQL - ROR v0.1.0

## Accueil

 
There is no translation page available for the current page, so it has been rendered in the default language 

 **Proof of concept — CQL appliqué aux données du ROR**
 Proof of concept exploring the use of CQL (Clinical Quality Language) on ROR (French healthcare offer repository) data. 

> Cet Implementation Guide n'est pas la version courante, il s'agit de la version en intégration continue soumise à des changements fréquents uniquement destinée à suivre les travaux en cours. La version courante sera accessible via l'URL canonique suite à la première release.

### Introduction

Ce POC explore la faisabilité d'utiliser CQL (Clinical Quality Language) pour exprimer des règles métier et des indicateurs qualité appliqués aux données du ROR (Répertoire de l'Offre et des Ressources en santé).

CQL est un langage standardisé par HL7, lisible et interopérable, qui s'exécute sur des ressources FHIR. Il s'intègre via les ressources `Library` (contient le CQL compilé en ELM) et `Measure` / `PlanDefinition`.

### Architecture technique

1. **Écriture**— le CQL est rédigé dans un fichier`.cql`
1. **Packaging**— le CQL est encodé en base64 et embarqué dans une ressource`Library`
1. **Référencement**— une ressource`Measure`référence la`Library`et définit les populations (`InitialPopulation`,`Denominator`,`Numerator`)
1. **Évaluation**— l'opération`$evaluate-measure`déclenche l'exécution du CQL par le moteur Clinical Reasoning de HAPI FHIR
1. **Résultat**— un`MeasureReport`retourne les comptes et le score

Le moteur CQL est intégré nativement à HAPI FHIR via le module **Clinical Reasoning** (`hapi.fhir.cr.enabled: true`), sans outil externe.

### Cas d'usages

| | | | |
| :--- | :--- | :--- | :--- |
| [01 — Exemple générique](cas-usage-01-generique.md) | Validation de la stack | Patients fictifs | Proportion de patients ≥ 65 ans |
| 02 — ROR | **(à venir)** | Données ROR | Règles qualité ROR |

### Lancer le POC

**Prérequis** : Docker, curl

```
cd poc/01-exemple-generique
docker compose up -d   # démarre HAPI FHIR v8 (port 8080)
./evaluate.sh          # charge les données et évalue la Measure
docker compose down

```

### Modifier le CQL

1. Éditer`poc/01-exemple-generique/cql/HelloCQL.cql`
1. Régénérer le base64 :`base64 -i cql/HelloCQL.cql | tr -d '\n'`
1. Remplacer la valeur`data`dans`fhir/library-hello-cql.json`
1. Relancer`./evaluate.sh`

### Dépendances



### Propriété intellectuelle

No use of external IP (other than from the FHIR specification)

