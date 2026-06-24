# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Contexte

Micro POC explorant l'usage de CQL (Clinical Quality Language) appliqué aux données du ROR (Répertoire de l'Offre et des Ressources en santé).

CQL est un langage de requête clinique standardisé par HL7, conçu pour exprimer des critères de sélection, des règles métier et des indicateurs qualité de façon lisible et interopérable. Dans FHIR, il s'intègre principalement via les ressources `Library`, `Measure` et `PlanDefinition` (module Clinical Reasoning).

**Approche du POC :** créer des instances FHIR représentant des données ROR (ex. `Organization`, `Location`, `HealthcareService`) et écrire des bibliothèques CQL exprimant des règles métier ou des critères de qualité qui s'exécutent sur ces instances.

> **Note :** CQL opère sur des *instances* de ressources FHIR, pas directement sur des Logical Models. Les LM peuvent servir à modéliser la structure attendue des données, mais le moteur CQL (ex. HAPI FHIR, CQL Translation Service) a besoin d'instances de ressources concrètes pour évaluer les expressions.

Documentations de référence :

- Spécification CQL : <https://cql.hl7.org/>
- IG Using CQL with FHIR : <https://build.fhir.org/ig/HL7/cql-ig/>
- Module Clinical Reasoning FHIR : <https://hl7.org/fhir/R4/clinicalreasoning-module.html>

## Commandes

```bash
./_updatePublisher.sh  # mettre à jour le publisher
./_genonce.sh          # générer l'IG une fois
./_gencontinuous.sh    # générer en mode continu
```

## Structure

Les artefacts FSH sont dans `input/fsh/` (sous-dossiers par type : `Profile-resource/`, `ValueSets/`, `CodeSystems/`, `Extensions/`, `Examples/`…).

Les pages Markdown sont dans `input/pagecontent/` et commencent obligatoirement au niveau `###`.
