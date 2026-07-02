# Hello CQL — exemple générique - POC CQL - ROR v0.1.0

## Library: Hello CQL — exemple générique (Expérimental) 

 
Bibliothèque CQL — cas 01 : proportion de patients âgés de 65 ans et plus 

-------

**French**

-------

* Metadata: Title
  * ?: Hello CQL — exemple générique
* Metadata: Version
  * ?: 0.1.0
* Metadata: Experimental
  * ?: true
* Metadata: Jurisdiction
  * ?: France (la)
* Metadata: Steward (Publisher)
  * ?: Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris
* Metadata: Steward Contact
  * ?: Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris
* Metadata: Description
  * ?: Bibliothèque CQL — cas 01 : proportion de patients âgés de 65 ans et plus
* Metadata: Type
  * ?: logic-library from[http://terminology.hl7.org/CodeSystem/library-type](http://terminology.hl7.org/7.2.0/CodeSystem-library-type.html)
* Metadata:  Parameters
* Metadata: Parameter
  * ?: None
* Metadata: Library Content
* Metadata: CQL Content
  * ?:  ````library HelloCQL version '1.0.0' using FHIR version '4.0.1' include FHIRHelpers version '4.0.1' context Patient // Population initiale : tous les patients define "InitialPopulation": true define "Denominator": true // Numérateur : patients de 65 ans et plus define "Numerator": AgeInYears() >= 65 ````
* Metadata: Generated using version 0.5.4 of the sample-content-ig Liquid templates



## Resource Content

```json
{
  "resourceType" : "Library",
  "id" : "HelloCQL",
  "url" : "https://interop.esante.gouv.fr/ig/fhir/test-cql/Library/HelloCQL",
  "version" : "0.1.0",
  "name" : "HelloCQL",
  "title" : "Hello CQL — exemple générique",
  "status" : "active",
  "experimental" : true,
  "type" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/library-type",
      "code" : "logic-library"
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
  "description" : "Bibliothèque CQL — cas 01 : proportion de patients âgés de 65 ans et plus",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "urn:iso:std:iso:3166",
      "code" : "FR",
      "display" : "France (la)"
    }]
  }],
  "content" : [{
    "contentType" : "text/cql",
    "data" : "bGlicmFyeSBIZWxsb0NRTCB2ZXJzaW9uICcxLjAuMCcKCnVzaW5nIEZISVIgdmVyc2lvbiAnNC4wLjEnCmluY2x1ZGUgRkhJUkhlbHBlcnMgdmVyc2lvbiAnNC4wLjEnCgpjb250ZXh0IFBhdGllbnQKCi8vIFBvcHVsYXRpb24gaW5pdGlhbGUgOiB0b3VzIGxlcyBwYXRpZW50cwpkZWZpbmUgIkluaXRpYWxQb3B1bGF0aW9uIjoKICB0cnVlCgpkZWZpbmUgIkRlbm9taW5hdG9yIjoKICB0cnVlCgovLyBOdW3DqXJhdGV1ciA6IHBhdGllbnRzIGRlIDY1IGFucyBldCBwbHVzCmRlZmluZSAiTnVtZXJhdG9yIjoKICBBZ2VJblllYXJzKCkgPj0gNjUK"
  }]
}

```
