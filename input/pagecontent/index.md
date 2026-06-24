<p style="padding: 5px; border-radius: 5px; border: 2px solid maroon; background: #ffffe6; width: 65%">
<b>Proof of concept — CQL appliqué aux données du ROR</b><br>
Proof of concept exploring the use of CQL (Clinical Quality Language) on ROR (French healthcare offer repository) data.
</p>

{% if site.data.info.releaselabel == 'ci-build' %}
<div style="width: 65%">
    <blockquote class="stu-note">
    <p>Cet Implementation Guide n'est pas la version courante, il s'agit de la version en intégration continue soumise à des changements fréquents uniquement destinée à suivre les travaux en cours. La version courante sera accessible via l'URL canonique suite à la première release : <a href="https://interop.esante.gouv.fr/ig/fhir/test-cql">https://interop.esante.gouv.fr/ig/fhir/test-cql</a></p>
    </blockquote>
</div>
{% endif %}

### Introduction

Ce POC explore la faisabilité d'utiliser CQL (Clinical Quality Language) pour exprimer des règles métier et des critères de qualité appliqués aux données du ROR (Répertoire de l'Offre et des Ressources en santé).

CQL est un langage standardisé par HL7, lisible et interopérable, permettant d'exprimer des expressions cliniques qui s'exécutent sur des ressources FHIR. Dans FHIR, il s'intègre via les ressources `Library` (contient le CQL compilé en ELM) et `Measure` / `PlanDefinition`.

### Périmètre

Ce POC inclut :

- Des instances de ressources FHIR représentatives des données ROR (`Organization`, `Location`, `HealthcareService`, `Practitioner`, `PractitionerRole`)
- Des bibliothèques CQL (`Library`) exprimant des règles métier ou des indicateurs de qualité sur ces données
- Le tout packagé dans un IG pour faciliter la reproductibilité et la diffusion

### Auteurs et contributeurs

| Role  | Nom | Organisation | Contact |
| --- | --- | --- | --- |
| **Primary Editor** | Nicolas Riss | Agence du Numérique en Santé | nicolas.riss@esante.gouv.fr |

### Dépendances

{% lang-fragment dependency-table.xhtml %}

### Propriété intellectuelle

{% lang-fragment ip-statements.xhtml %}
