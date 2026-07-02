Alias: $library-type      = http://terminology.hl7.org/CodeSystem/library-type
Alias: $measure-scoring   = http://terminology.hl7.org/CodeSystem/measure-scoring
Alias: $measure-population = http://terminology.hl7.org/CodeSystem/measure-population

// ─── Library ──────────────────────────────────────────────────────────────────

Instance: OrganizationNomUrgence
InstanceOf: Library
Usage: #definition
* url = "https://interop.esante.gouv.fr/ig/fhir/test-cql/Library/OrganizationNomUrgence"
* version = "1.0.0"
* name = "OrganizationNomUrgence"
* title = "Organization avec le nom Urgence — Règle #1 ROR"
* description = "Bibliothèque CQL — cas 02 (ROR) : identifie les Organization qui, ayant un HealthcareService avec une activité opérationnelle 157 ou 249 et un mode de prise en charge 33, n'ont pas \"urgence\" dans leur nom."
* status = #active
* experimental = true
* type = $library-type#logic-library
* content
  * contentType = #text/cql
  * data = "bGlicmFyeSBPcmdhbml6YXRpb25Ob21VcmdlbmNlIHZlcnNpb24gJzEuMC4wJwoKdXNpbmcgRkhJUiB2ZXJzaW9uICc0LjAuMScKaW5jbHVkZSBGSElSSGVscGVycyB2ZXJzaW9uICc0LjAuMScKCmNvZGVzeXN0ZW0gIlRSRV9SMjExLUFjdGl2aXRlT3BlcmF0aW9ubmVsbGUiOiAnaHR0cHM6Ly9tb3MuZXNhbnRlLmdvdXYuZnIvTk9TL1RSRV9SMjExLUFjdGl2aXRlT3BlcmF0aW9ubmVsbGUvRkhJUi9UUkUtUjIxMS1BY3Rpdml0ZU9wZXJhdGlvbm5lbGxlJwpjb2Rlc3lzdGVtICJUUkVfUjIxMy1Nb2RlUHJpc2VFbkNoYXJnZSI6ICdodHRwczovL21vcy5lc2FudGUuZ291di5mci9OT1MvVFJFX1IyMTMtTW9kZVByaXNlRW5DaGFyZ2UvRkhJUi9UUkUtUjIxMy1Nb2RlUHJpc2VFbkNoYXJnZScKCmNvZGUgIlVyZ2VuY2VzIHBvbHl2YWxlbnRlcyBob3NwaXRhbGnDqHJlcyI6ICcxNTcnIGZyb20gIlRSRV9SMjExLUFjdGl2aXRlT3BlcmF0aW9ubmVsbGUiCmNvZGUgIlVyZ2VuY2VzIHDDqWRpYXRyaXF1ZXMgaG9zcGl0YWxpw6hyZXMiOiAnMjQ5JyBmcm9tICJUUkVfUjIxMS1BY3Rpdml0ZU9wZXJhdGlvbm5lbGxlIgpjb2RlICJBY2N1ZWlsIGRlcyB1cmdlbmNlcyI6ICczMycgZnJvbSAiVFJFX1IyMTMtTW9kZVByaXNlRW5DaGFyZ2UiCgpjb250ZXh0IE9yZ2FuaXphdGlvbgoKLy8gSGVhbHRoY2FyZVNlcnZpY2UgcmF0dGFjaMOpcyDDoCBsJ09yZ2FuaXphdGlvbiBjb3VyYW50ZQpkZWZpbmUgIkhlYWx0aGNhcmVTZXJ2aWNlc0xpZXMiOgogIFtIZWFsdGhjYXJlU2VydmljZV0gSFMKICAgIHdoZXJlIEhTLnByb3ZpZGVkQnkucmVmZXJlbmNlID0gJ09yZ2FuaXphdGlvbi8nICsgT3JnYW5pemF0aW9uLmlkCgovLyBDb25jZXJuw6llIHBhciBsJ29ibGlnYXRpb24gZGUgbm9tbWFnZSA6IGF1IG1vaW5zIHVuIEhlYWx0aGNhcmVTZXJ2aWNlIGF2ZWMgdW5lIGFjdGl2aXTDqQovLyBvcMOpcmF0aW9ubmVsbGUgInVyZ2VuY2VzIiAoMTU3IG91IDI0OSkgRVQgdW4gbW9kZSBkZSBwcmlzZSBlbiBjaGFyZ2UgImFjY3VlaWwgZGVzIHVyZ2VuY2VzIiAoMzMpCmRlZmluZSAiQ29uY2VybmVlUGFyT2JsaWdhdGlvbkRlTm9tbWFnZSI6CiAgZXhpc3RzICgKICAgICJIZWFsdGhjYXJlU2VydmljZXNMaWVzIiBIUwogICAgICB3aGVyZSAoCiAgICAgICAgZXhpc3RzIChIUy5zcGVjaWFsdHkgUyB3aGVyZSBGSElSSGVscGVycy5Ub0NvbmNlcHQoUykgfiAiVXJnZW5jZXMgcG9seXZhbGVudGVzIGhvc3BpdGFsacOocmVzIikKICAgICAgICBvciBleGlzdHMgKEhTLnNwZWNpYWx0eSBTIHdoZXJlIEZISVJIZWxwZXJzLlRvQ29uY2VwdChTKSB+ICJVcmdlbmNlcyBww6lkaWF0cmlxdWVzIGhvc3BpdGFsacOocmVzIikKICAgICAgKQogICAgICBhbmQgZXhpc3RzIChIUy5jaGFyYWN0ZXJpc3RpYyBDIHdoZXJlIEZISVJIZWxwZXJzLlRvQ29uY2VwdChDKSB+ICJBY2N1ZWlsIGRlcyB1cmdlbmNlcyIpCiAgKQoKZGVmaW5lICJJbml0aWFsUG9wdWxhdGlvbiI6CiAgIkNvbmNlcm5lZVBhck9ibGlnYXRpb25EZU5vbW1hZ2UiCgpkZWZpbmUgIkRlbm9taW5hdG9yIjoKICAiSW5pdGlhbFBvcHVsYXRpb24iCgovLyBMZSBub20gKG91IHVuIGFsaWFzKSBkZSBsJ09yZ2FuaXphdGlvbiBjb250aWVudCAidXJnZW5jZSIKZGVmaW5lICJOb21Db250aWVudFVyZ2VuY2UiOgogIChPcmdhbml6YXRpb24ubmFtZSBpcyBub3QgbnVsbCBhbmQgTG93ZXIoT3JnYW5pemF0aW9uLm5hbWUpIGNvbnRhaW5zICd1cmdlbmNlJykKICAgIG9yIGV4aXN0cyAoT3JnYW5pemF0aW9uLmFsaWFzIEEgd2hlcmUgTG93ZXIoQSkgY29udGFpbnMgJ3VyZ2VuY2UnKQoKLy8gTnVtw6lyYXRldXIgOiBPcmdhbml6YXRpb24gY29uY2VybsOpZXMgZXQgTk9OIGNvbmZvcm1lcyAocGFzIGQnInVyZ2VuY2UiIGRhbnMgbGUgbm9tKQpkZWZpbmUgIk51bWVyYXRvciI6CiAgIkluaXRpYWxQb3B1bGF0aW9uIiBhbmQgbm90ICJOb21Db250aWVudFVyZ2VuY2UiCg=="

// ─── Measure ──────────────────────────────────────────────────────────────────

Instance: OrganizationsNonConformesNomUrgence
InstanceOf: Measure
Usage: #definition
* url = "https://interop.esante.gouv.fr/ig/fhir/test-cql/Measure/OrganizationsNonConformesNomUrgence"
* version = "1.0.0"
* name = "OrganizationsNonConformesNomUrgence"
* title = "Organization non conformes à la règle du nom Urgence"
* status = #active
* subjectCodeableConcept = http://hl7.org/fhir/resource-types#Organization
* library = "https://interop.esante.gouv.fr/ig/fhir/test-cql/Library/OrganizationNomUrgence"
* scoring = $measure-scoring#proportion
* group[+]
  * id = "nom-urgence"
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
