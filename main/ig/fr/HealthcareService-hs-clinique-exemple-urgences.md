# hs-clinique-exemple-urgences - POC CQL - ROR v0.1.0

## Exemple HealthcareService: hs-clinique-exemple-urgences

-------

**French**

-------

**providedBy**: [Organization Clinique Exemple](Organization-org-clinique-exemple.md)

**specialty**: Urgences polyvalentes hospitalières

**characteristic**: Accueil des urgences



## Resource Content

```json
{
  "resourceType" : "HealthcareService",
  "id" : "hs-clinique-exemple-urgences",
  "providedBy" : {
    "reference" : "Organization/org-clinique-exemple"
  },
  "specialty" : [{
    "coding" : [{
      "system" : "https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle",
      "code" : "157",
      "display" : "Urgences polyvalentes hospitalières"
    }]
  }],
  "characteristic" : [{
    "coding" : [{
      "system" : "https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge",
      "code" : "33",
      "display" : "Accueil des urgences"
    }]
  }]
}

```
