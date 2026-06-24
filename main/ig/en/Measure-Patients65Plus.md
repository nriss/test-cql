# Proportion de patients âgés de 65 ans et plus - POC CQL - ROR v0.1.0

## Measure: Proportion de patients âgés de 65 ans et plus 

-------

**English**

-------

* Metadata: Title
  * ?: Proportion de patients âgés de 65 ans et plus
* Metadata: Version
  * ?: 0.1.0
* Metadata: Jurisdiction
  * ?: France (la)
* Metadata: Steward (Publisher)
  * ?: Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris
* Metadata: Steward Contact
  * ?: Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris
* Metadata: Measure Scoring
  * ?: proportion from[http://terminology.hl7.org/CodeSystem/measure-scoring](http://terminology.hl7.org/7.2.0/CodeSystem-measure-scoring.html)
* Metadata: Measure Group (Rate) (ID: seniors)
* Metadata: Measure Logic
* Metadata: Primary Library
  * ?: `http://poc-cql/Library/HelloCQL`
* Metadata: Generated using version 0.5.4 of the sample-content-ig Liquid templates



## Resource Content

```json
{
  "resourceType" : "Measure",
  "id" : "Patients65Plus",
  "url" : "http://poc-cql/Measure/patients-65plus",
  "version" : "0.1.0",
  "name" : "Patients65Plus",
  "title" : "Proportion de patients âgés de 65 ans et plus",
  "status" : "active",
  "date" : "2026-06-24T08:34:08+00:00",
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
  "library" : ["http://poc-cql/Library/HelloCQL"],
  "scoring" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/measure-scoring",
      "code" : "proportion"
    }]
  },
  "group" : [{
    "id" : "seniors",
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
