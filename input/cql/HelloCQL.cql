library HelloCQL version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

context Patient

// Population initiale : tous les patients
define "InitialPopulation":
  true

define "Denominator":
  true

// Numérateur : patients de 65 ans et plus
define "Numerator":
  AgeInYears() >= 65
