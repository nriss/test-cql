# Organization avec le nom Urgence — Règle #1 ROR - POC CQL - ROR v0.1.0

## Library: Organization avec le nom Urgence — Règle #1 ROR (Expérimental) 

 
Bibliothèque CQL — cas 02 (ROR) : identifie les Organization qui, ayant un HealthcareService avec une activité opérationnelle 157 ou 249 et un mode de prise en charge 33, n'ont pas "urgence" dans leur nom. 

-------

**French**

-------

* Metadata: Title
  * ?: Organization avec le nom Urgence — Règle #1 ROR
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
  * ?: Bibliothèque CQL — cas 02 (ROR) : identifie les Organization qui, ayant un HealthcareService avec une activité opérationnelle 157 ou 249 et un mode de prise en charge 33, n'ont pas "urgence" dans leur nom.
* Metadata: Type
  * ?: logic-library from[http://terminology.hl7.org/CodeSystem/library-type](http://terminology.hl7.org/7.2.0/CodeSystem-library-type.html)
* Metadata:  Parameters
* Metadata: Parameter
  * ?: None
* Metadata: Library Content
* Metadata: CQL Content
  * ?:  ````library OrganizationNomUrgence version '1.0.0' using FHIR version '4.0.1' include FHIRHelpers version '4.0.1' codesystem "TRE_R211-ActiviteOperationnelle": 'https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle' codesystem "TRE_R213-ModePriseEnCharge": 'https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge' code "Urgences polyvalentes hospitalières": '157' from "TRE_R211-ActiviteOperationnelle" code "Urgences pédiatriques hospitalières": '249' from "TRE_R211-ActiviteOperationnelle" code "Accueil des urgences": '33' from "TRE_R213-ModePriseEnCharge" context Organization // HealthcareService rattachés à l'Organization courante define "HealthcareServicesLies": [HealthcareService] HS where HS.providedBy.reference = 'Organization/' + Organization.id // Concernée par l'obligation de nommage : au moins un HealthcareService avec une activité // opérationnelle "urgences" (157 ou 249) ET un mode de prise en charge "accueil des urgences" (33) define "ConcerneeParObligationDeNommage": exists ( "HealthcareServicesLies" HS where ( exists (HS.specialty S where FHIRHelpers.ToConcept(S) ~ "Urgences polyvalentes hospitalières") or exists (HS.specialty S where FHIRHelpers.ToConcept(S) ~ "Urgences pédiatriques hospitalières") ) and exists (HS.characteristic C where FHIRHelpers.ToConcept(C) ~ "Accueil des urgences") ) define "InitialPopulation": "ConcerneeParObligationDeNommage" define "Denominator": "InitialPopulation" // Le nom (ou un alias) de l'Organization contient "urgence" define "NomContientUrgence": (Organization.name is not null and Lower(Organization.name) contains 'urgence') or exists (Organization.alias A where Lower(A) contains 'urgence') // Numérateur : Organization concernées et NON conformes (pas d'"urgence" dans le nom) define "Numerator": "InitialPopulation" and not "NomContientUrgence" ````
* Metadata: Generated using version 0.5.4 of the sample-content-ig Liquid templates



## Resource Content

```json
{
  "resourceType" : "Library",
  "id" : "OrganizationNomUrgence",
  "url" : "https://interop.esante.gouv.fr/ig/fhir/test-cql/Library/OrganizationNomUrgence",
  "version" : "0.1.0",
  "name" : "OrganizationNomUrgence",
  "title" : "Organization avec le nom Urgence — Règle #1 ROR",
  "status" : "active",
  "experimental" : true,
  "type" : {
    "coding" : [{
      "system" : "http://terminology.hl7.org/CodeSystem/library-type",
      "code" : "logic-library"
    }]
  },
  "date" : "2026-07-02T10:02:51+00:00",
  "publisher" : "Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris",
  "contact" : [{
    "name" : "Agence du Numérique en Santé (ANS) - 2-10 Rue d'Oradour-sur-Glane, 75015 Paris",
    "telecom" : [{
      "system" : "url",
      "value" : "https://esante.gouv.fr"
    }]
  }],
  "description" : "Bibliothèque CQL — cas 02 (ROR) : identifie les Organization qui, ayant un HealthcareService avec une activité opérationnelle 157 ou 249 et un mode de prise en charge 33, n'ont pas \"urgence\" dans leur nom.",
  "jurisdiction" : [{
    "coding" : [{
      "system" : "urn:iso:std:iso:3166",
      "code" : "FR",
      "display" : "France (la)"
    }]
  }],
  "content" : [{
    "contentType" : "text/cql",
    "data" : "bGlicmFyeSBPcmdhbml6YXRpb25Ob21VcmdlbmNlIHZlcnNpb24gJzEuMC4wJwoKdXNpbmcgRkhJUiB2ZXJzaW9uICc0LjAuMScKaW5jbHVkZSBGSElSSGVscGVycyB2ZXJzaW9uICc0LjAuMScKCmNvZGVzeXN0ZW0gIlRSRV9SMjExLUFjdGl2aXRlT3BlcmF0aW9ubmVsbGUiOiAnaHR0cHM6Ly9tb3MuZXNhbnRlLmdvdXYuZnIvTk9TL1RSRV9SMjExLUFjdGl2aXRlT3BlcmF0aW9ubmVsbGUvRkhJUi9UUkUtUjIxMS1BY3Rpdml0ZU9wZXJhdGlvbm5lbGxlJwpjb2Rlc3lzdGVtICJUUkVfUjIxMy1Nb2RlUHJpc2VFbkNoYXJnZSI6ICdodHRwczovL21vcy5lc2FudGUuZ291di5mci9OT1MvVFJFX1IyMTMtTW9kZVByaXNlRW5DaGFyZ2UvRkhJUi9UUkUtUjIxMy1Nb2RlUHJpc2VFbkNoYXJnZScKCmNvZGUgIlVyZ2VuY2VzIHBvbHl2YWxlbnRlcyBob3NwaXRhbGnDqHJlcyI6ICcxNTcnIGZyb20gIlRSRV9SMjExLUFjdGl2aXRlT3BlcmF0aW9ubmVsbGUiCmNvZGUgIlVyZ2VuY2VzIHDDqWRpYXRyaXF1ZXMgaG9zcGl0YWxpw6hyZXMiOiAnMjQ5JyBmcm9tICJUUkVfUjIxMS1BY3Rpdml0ZU9wZXJhdGlvbm5lbGxlIgpjb2RlICJBY2N1ZWlsIGRlcyB1cmdlbmNlcyI6ICczMycgZnJvbSAiVFJFX1IyMTMtTW9kZVByaXNlRW5DaGFyZ2UiCgpjb250ZXh0IE9yZ2FuaXphdGlvbgoKLy8gSGVhbHRoY2FyZVNlcnZpY2UgcmF0dGFjaMOpcyDDoCBsJ09yZ2FuaXphdGlvbiBjb3VyYW50ZQpkZWZpbmUgIkhlYWx0aGNhcmVTZXJ2aWNlc0xpZXMiOgogIFtIZWFsdGhjYXJlU2VydmljZV0gSFMKICAgIHdoZXJlIEhTLnByb3ZpZGVkQnkucmVmZXJlbmNlID0gJ09yZ2FuaXphdGlvbi8nICsgT3JnYW5pemF0aW9uLmlkCgovLyBDb25jZXJuw6llIHBhciBsJ29ibGlnYXRpb24gZGUgbm9tbWFnZSA6IGF1IG1vaW5zIHVuIEhlYWx0aGNhcmVTZXJ2aWNlIGF2ZWMgdW5lIGFjdGl2aXTDqQovLyBvcMOpcmF0aW9ubmVsbGUgInVyZ2VuY2VzIiAoMTU3IG91IDI0OSkgRVQgdW4gbW9kZSBkZSBwcmlzZSBlbiBjaGFyZ2UgImFjY3VlaWwgZGVzIHVyZ2VuY2VzIiAoMzMpCmRlZmluZSAiQ29uY2VybmVlUGFyT2JsaWdhdGlvbkRlTm9tbWFnZSI6CiAgZXhpc3RzICgKICAgICJIZWFsdGhjYXJlU2VydmljZXNMaWVzIiBIUwogICAgICB3aGVyZSAoCiAgICAgICAgZXhpc3RzIChIUy5zcGVjaWFsdHkgUyB3aGVyZSBGSElSSGVscGVycy5Ub0NvbmNlcHQoUykgfiAiVXJnZW5jZXMgcG9seXZhbGVudGVzIGhvc3BpdGFsacOocmVzIikKICAgICAgICBvciBleGlzdHMgKEhTLnNwZWNpYWx0eSBTIHdoZXJlIEZISVJIZWxwZXJzLlRvQ29uY2VwdChTKSB+ICJVcmdlbmNlcyBww6lkaWF0cmlxdWVzIGhvc3BpdGFsacOocmVzIikKICAgICAgKQogICAgICBhbmQgZXhpc3RzIChIUy5jaGFyYWN0ZXJpc3RpYyBDIHdoZXJlIEZISVJIZWxwZXJzLlRvQ29uY2VwdChDKSB+ICJBY2N1ZWlsIGRlcyB1cmdlbmNlcyIpCiAgKQoKZGVmaW5lICJJbml0aWFsUG9wdWxhdGlvbiI6CiAgIkNvbmNlcm5lZVBhck9ibGlnYXRpb25EZU5vbW1hZ2UiCgpkZWZpbmUgIkRlbm9taW5hdG9yIjoKICAiSW5pdGlhbFBvcHVsYXRpb24iCgovLyBMZSBub20gKG91IHVuIGFsaWFzKSBkZSBsJ09yZ2FuaXphdGlvbiBjb250aWVudCAidXJnZW5jZSIKZGVmaW5lICJOb21Db250aWVudFVyZ2VuY2UiOgogIChPcmdhbml6YXRpb24ubmFtZSBpcyBub3QgbnVsbCBhbmQgTG93ZXIoT3JnYW5pemF0aW9uLm5hbWUpIGNvbnRhaW5zICd1cmdlbmNlJykKICAgIG9yIGV4aXN0cyAoT3JnYW5pemF0aW9uLmFsaWFzIEEgd2hlcmUgTG93ZXIoQSkgY29udGFpbnMgJ3VyZ2VuY2UnKQoKLy8gTnVtw6lyYXRldXIgOiBPcmdhbml6YXRpb24gY29uY2VybsOpZXMgZXQgTk9OIGNvbmZvcm1lcyAocGFzIGQnInVyZ2VuY2UiIGRhbnMgbGUgbm9tKQpkZWZpbmUgIk51bWVyYXRvciI6CiAgIkluaXRpYWxQb3B1bGF0aW9uIiBhbmQgbm90ICJOb21Db250aWVudFVyZ2VuY2UiCg=="
  }]
}

```
