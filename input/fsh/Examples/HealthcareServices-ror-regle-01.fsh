Instance: hs-ch-exemple-urgences
InstanceOf: HealthcareService
Usage: #example
* providedBy = Reference(org-ch-exemple)
* specialty[+] = https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle#157 "Urgences polyvalentes hospitalières"
* characteristic[+] = https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge#33 "Accueil des urgences"

Instance: hs-service-urgences-pediatriques
InstanceOf: HealthcareService
Usage: #example
* providedBy = Reference(org-service-urgences)
* specialty[+] = https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle#249 "Urgences pédiatriques hospitalières"
* characteristic[+] = https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge#33 "Accueil des urgences"

Instance: hs-clinique-exemple-urgences
InstanceOf: HealthcareService
Usage: #example
* providedBy = Reference(org-clinique-exemple)
* specialty[+] = https://mos.esante.gouv.fr/NOS/TRE_R211-ActiviteOperationnelle/FHIR/TRE-R211-ActiviteOperationnelle#157 "Urgences polyvalentes hospitalières"
* characteristic[+] = https://mos.esante.gouv.fr/NOS/TRE_R213-ModePriseEnCharge/FHIR/TRE-R213-ModePriseEnCharge#33 "Accueil des urgences"
