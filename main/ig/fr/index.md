# Accueil - POC CQL - ROR v0.1.0

## Accueil

 **Proof of concept — CQL appliqué aux données du ROR**
 Proof of concept exploring the use of CQL (Clinical Quality Language) on ROR (French healthcare offer repository) data. 

> Cet Implementation Guide n'est pas la version courante, il s'agit de la version en intégration continue soumise à des changements fréquents uniquement destinée à suivre les travaux en cours. La version courante sera accessible via l'URL canonique suite à la première release : [https://interop.esante.gouv.fr/ig/fhir/test-cql](https://interop.esante.gouv.fr/ig/fhir/test-cql)

### Introduction

Ce POC explore la faisabilité d'utiliser CQL (Clinical Quality Language) pour exprimer des règles métier et des critères de qualité appliqués aux données du ROR (Répertoire de l'Offre et des Ressources en santé).

CQL est un langage standardisé par HL7, lisible et interopérable, permettant d'exprimer des expressions cliniques qui s'exécutent sur des ressources FHIR. Dans FHIR, il s'intègre via les ressources `Library` (contient le CQL compilé en ELM) et `Measure` / `PlanDefinition`.

### Périmètre

Ce POC inclut :

* Des instances de ressources FHIR représentatives des données ROR (`Organization`, `Location`, `HealthcareService`, `Practitioner`, `PractitionerRole`)
* Des bibliothèques CQL (`Library`) exprimant des règles métier ou des indicateurs de qualité sur ces données
* Le tout packagé dans un IG pour faciliter la reproductibilité et la diffusion

### Auteurs et contributeurs

| | | | |
| :--- | :--- | :--- | :--- |
| **Primary Editor** | Nicolas Riss | Agence du Numérique en Santé | nicolas.riss@esante.gouv.fr |

### Dépendances



### Propriété intellectuelle

This publication includes IP covered under the following statements.

* This material contains content that is copyright of SNOMED International. Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact [https://www.snomed.org/get-snomed](https://www.snomed.org/get-snomed) or [info@snomed.org](mailto:info@snomed.org).

* [SNOMED Clinical Terms&reg; (SNOMED CT&reg;)](http://hl7.org/fhir/R4/codesystem-snomedct.html): [EyeColor](StructureDefinition-EyeColor.md), [EyeColorVS](ValueSet-EyeColorVS.md) and [MeltingPotVS](ValueSet-MeltingPotVS.md)


