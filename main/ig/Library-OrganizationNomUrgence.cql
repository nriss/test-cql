library OrganizationNomUrgence version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

codesystem "TRE_R211-ActiviteOperationnelle": 'https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle'
codesystem "TRE_R213-ModePriseEnCharge": 'https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge'

code "Urgences polyvalentes hospitalières": '157' from "TRE_R211-ActiviteOperationnelle"
code "Urgences pédiatriques hospitalières": '249' from "TRE_R211-ActiviteOperationnelle"
code "Accueil des urgences": '33' from "TRE_R213-ModePriseEnCharge"

context Organization

// HealthcareService rattachés à l'Organization courante
define "HealthcareServicesLies":
  [HealthcareService] HS
    where HS.providedBy.reference = 'Organization/' + Organization.id

// Concernée par l'obligation de nommage : au moins un HealthcareService avec une activité
// opérationnelle "urgences" (157 ou 249) ET un mode de prise en charge "accueil des urgences" (33)
define "ConcerneeParObligationDeNommage":
  exists (
    "HealthcareServicesLies" HS
      where (
        exists (HS.specialty S where FHIRHelpers.ToConcept(S) ~ "Urgences polyvalentes hospitalières")
        or exists (HS.specialty S where FHIRHelpers.ToConcept(S) ~ "Urgences pédiatriques hospitalières")
      )
      and exists (HS.characteristic C where FHIRHelpers.ToConcept(C) ~ "Accueil des urgences")
  )

define "InitialPopulation":
  "ConcerneeParObligationDeNommage"

define "Denominator":
  "InitialPopulation"

// Le nom (ou un alias) de l'Organization contient "urgence"
// Note : l'opérateur `contains` de ce moteur CQL se comporte comme une égalité stricte sur les
// chaînes (et non comme une recherche de sous-chaîne) — on utilise donc PositionOf(...) >= 0.
define "NomContientUrgence":
  (Organization.name is not null and PositionOf('urgence', Lower(Organization.name)) >= 0)
    or exists (Organization.alias A where PositionOf('urgence', Lower(A)) >= 0)

// Numérateur : Organization concernées et NON conformes (pas d'"urgence" dans le nom)
define "Numerator":
  "InitialPopulation" and not "NomContientUrgence"
