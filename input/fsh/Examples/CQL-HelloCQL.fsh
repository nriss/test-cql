Alias: $library-type      = http://terminology.hl7.org/CodeSystem/library-type
Alias: $measure-scoring   = http://terminology.hl7.org/CodeSystem/measure-scoring
Alias: $measure-population = http://terminology.hl7.org/CodeSystem/measure-population

// ─── Library ──────────────────────────────────────────────────────────────────

Instance: HelloCQL
InstanceOf: Library
Usage: #definition
* url = "https://interop.esante.gouv.fr/ig/fhir/test-cql/Library/HelloCQL"
* version = "1.0.0"
* name = "HelloCQL"
* title = "Hello CQL — exemple générique"
* description = "Bibliothèque CQL — cas 01 : proportion de patients âgés de 65 ans et plus"
* status = #active
* experimental = true
* type = $library-type#logic-library
* content
  * contentType = #text/cql
  * data = "bGlicmFyeSBIZWxsb0NRTCB2ZXJzaW9uICcxLjAuMCcKCnVzaW5nIEZISVIgdmVyc2lvbiAnNC4wLjEnCmluY2x1ZGUgRkhJUkhlbHBlcnMgdmVyc2lvbiAnNC4wLjEnCgpjb250ZXh0IFBhdGllbnQKCi8vIFBvcHVsYXRpb24gaW5pdGlhbGUgOiB0b3VzIGxlcyBwYXRpZW50cwpkZWZpbmUgIkluaXRpYWxQb3B1bGF0aW9uIjoKICB0cnVlCgpkZWZpbmUgIkRlbm9taW5hdG9yIjoKICB0cnVlCgovLyBOdW3DqXJhdGV1ciA6IHBhdGllbnRzIGRlIDY1IGFucyBldCBwbHVzCmRlZmluZSAiTnVtZXJhdG9yIjoKICBBZ2VJblllYXJzKCkgPj0gNjUK"

// ─── Measure ──────────────────────────────────────────────────────────────────

Instance: Patients65Plus
InstanceOf: Measure
Usage: #definition
* url = "http://poc-cql/Measure/patients-65plus"
* version = "1.0.0"
* name = "Patients65Plus"
* title = "Proportion de patients âgés de 65 ans et plus"
* status = #active
* library = "http://poc-cql/Library/HelloCQL"
* scoring = $measure-scoring#proportion
* group[+]
  * id = "seniors"
  * population[+]
    * id = "initial-population"
    * code = $measure-population#initial-population
    * criteria
      * language = #text/cql-identifier
      * expression = "InitialPopulation"
  * population[+]
    * id = "denominator"
    * code = $measure-population#denominator
    * criteria
      * language = #text/cql-identifier
      * expression = "Denominator"
  * population[+]
    * id = "numerator"
    * code = $measure-population#numerator
    * criteria
      * language = #text/cql-identifier
      * expression = "Numerator"
