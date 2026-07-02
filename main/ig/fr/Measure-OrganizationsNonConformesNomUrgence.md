# Organization non conformes à la règle du nom Urgence - POC CQL - ROR v0.1.0

## Measure: Organization non conformes à la règle du nom Urgence 

-------

**French**

-------

* Metadata: Title
  * ?: Organization non conformes à la règle du nom Urgence
* Metadata: Version
  * ?: 0.1.0
* Metadata: Subject Type
  * ?: Organization from[http://hl7.org/fhir/resource-types](http://hl7.org/fhir/R4/codesystem-resource-types.html)
* Metadata: Jurisdiction
  * ?: France (la)
* Metadata: Steward (Publisher)
  * ?: Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris
* Metadata: Steward Contact
  * ?: Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris
* Metadata: Measure Scoring
  * ?: proportion from[http://terminology.hl7.org/CodeSystem/measure-scoring](http://terminology.hl7.org/7.2.0/CodeSystem-measure-scoring.html)
* Metadata: Measure Group (Rate) (ID: nom-urgence)
* Metadata: Measure Logic
* Metadata: Primary Library
  * ?: [Organization avec le nom Urgence — Règle #1 ROR](Library-OrganizationNomUrgence.md)version : 0.1.0
* Metadata: Generated using version 0.5.4 of the sample-content-ig Liquid templates



## Resource Content

```json
{
  "resourceType" : "Measure",
  "id" : "OrganizationsNonConformesNomUrgence",
  "url" : "https://interop.esante.gouv.fr/ig/fhir/test-cql/Measure/OrganizationsNonConformesNomUrgence",
  "version" : "0.1.0",
  "name" : "OrganizationsNonConformesNomUrgence",
  "title" : "Organization non conformes à la règle du nom Urgence",
  "status" : "active",
  "subjectCodeableConcept" : {
    "coding" : [{
      "system" : "http://hl7.org/fhir/resource-types",
      "code" : "Organization"
    }]
  },
  "date" : "2026-07-02T12:02:22+00:00",
  "publisher" : "Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris",
  "contact" : [{
    "name" : "Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris",
    "telecom" : [{
      "system" : "url",
      "value" : "https://esante.gouv.fr"
    }]
  }],
  "jurisdiction" : [{
    "coding" : [{
      "system" : "urn:iso:std:iso:3166",
      "code" : "FR",
      "display" : "France (la)"
    }]
  }],
  "library" : ["https://interop.esante.gouv.fr/ig/fhir/test-cql/Library/OrganizationNomUrgence|0.1.0"],
  "scoring" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/measure-scoring",
      "code" : "proportion"
    }]
  },
  "group" : [{
    "id" : "nom-urgence",
    "population" : [{
      "id" : "initial-population",
      "code" : {
        "coding" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/measure-population",
          "code" : "initial-population"
        }]
      },
      "criteria" : {
        "language" : "text/cql-identifier",
        "expression" : "InitialPopulation"
      }
    },
    {
      "id" : "denominator",
      "code" : {
        "coding" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/measure-population",
          "code" : "denominator"
        }]
      },
      "criteria" : {
        "language" : "text/cql-identifier",
        "expression" : "Denominator"
      }
    },
    {
      "id" : "numerator",
      "code" : {
        "coding" : [{
          "system" : "http://terminology.hl7.org/CodeSystem/measure-population",
          "code" : "numerator"
        }]
      },
      "criteria" : {
        "language" : "text/cql-identifier",
        "expression" : "Numerator"
      }
    }]
  }]
}

```
