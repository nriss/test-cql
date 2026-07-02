# hs-ch-exemple-urgences - POC CQL - ROR v0.1.0

## Example HealthcareService: hs-ch-exemple-urgences

-------

**English**

-------

**providedBy**: [Organization CH Exemple](Organization-org-ch-exemple.md)

**specialty**: Urgences polyvalentes hospitalières

**characteristic**: Accueil des urgences



## Resource Content

```json
{
  "resourceType" : "HealthcareService",
  "id" : "hs-ch-exemple-urgences",
  "providedBy" : {
    "reference" : "Organization/org-ch-exemple"
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
