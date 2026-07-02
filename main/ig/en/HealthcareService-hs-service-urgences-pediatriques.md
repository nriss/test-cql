# hs-service-urgences-pediatriques - POC CQL - ROR v0.1.0

## Example HealthcareService: hs-service-urgences-pediatriques

-------

**English**

-------

**providedBy**: [Organization Service des Urgences du CH Exemple](Organization-org-service-urgences.md)

**specialty**: Urgences pédiatriques hospitalières

**characteristic**: Accueil des urgences



## Resource Content

```json
{
  "resourceType" : "HealthcareService",
  "id" : "hs-service-urgences-pediatriques",
  "providedBy" : {
    "reference" : "Organization/org-service-urgences"
  },
  "specialty" : [{
    "coding" : [{
      "system" : "https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle",
      "code" : "249",
      "display" : "Urgences pédiatriques hospitalières"
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
