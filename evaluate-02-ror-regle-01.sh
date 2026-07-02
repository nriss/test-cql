#!/usr/bin/env bash
# Cas 02 — ROR, Règle #1 : Organization avec le nom "Urgence"
# Règle CQL : une Organization ayant un HealthcareService avec une activité opérationnelle
#             157 ou 249 et un mode de prise en charge 33 doit avoir "urgence" dans son nom.
# Résultat attendu : 2 Organization non conformes sur 3 concernées
#   (org-ch-exemple et org-clinique-exemple ; org-service-urgences est conforme)
# Usage : ./evaluate-02-ror-regle-01.sh  (HAPI FHIR doit tourner sur le port 8080)
# Prérequis : sushi doit avoir été lancé (fsh-generated/ doit exister)
set -euo pipefail

FHIR_BASE="http://localhost:8080/fhir"
FSH_OUT="$(cd "$(dirname "$0")" && pwd)/fsh-generated/resources"

if [ ! -f "${FSH_OUT}/Library-OrganizationNomUrgence.json" ]; then
  echo "❌ fsh-generated/ absent. Lance d'abord : sushi . ou ./_genonce.sh"
  exit 1
fi

echo "⏳ Attente du démarrage de HAPI FHIR..."
until curl -sf "${FHIR_BASE}/metadata" -o /dev/null; do sleep 5; done
echo "✅ HAPI FHIR est prêt."

echo ""
echo "📚 Chargement de la Library..."
curl -sf -X PUT "${FHIR_BASE}/Library/OrganizationNomUrgence" \
  -H "Content-Type: application/fhir+json" \
  -d @"${FSH_OUT}/Library-OrganizationNomUrgence.json" -o /dev/null
echo "  → Library/OrganizationNomUrgence chargée depuis fsh-generated/."

echo ""
echo "📏 Chargement de la Measure..."
curl -sf -X PUT "${FHIR_BASE}/Measure/OrganizationsNonConformesNomUrgence" \
  -H "Content-Type: application/fhir+json" \
  -d @"${FSH_OUT}/Measure-OrganizationsNonConformesNomUrgence.json" -o /dev/null
echo "  → Measure/OrganizationsNonConformesNomUrgence chargée depuis fsh-generated/."

echo ""
echo "🏢 Chargement des Organization..."
for org in org-ch-exemple org-service-urgences org-clinique-exemple; do
  curl -sf -X PUT "${FHIR_BASE}/Organization/${org}" \
    -H "Content-Type: application/fhir+json" \
    -d @"${FSH_OUT}/Organization-${org}.json" -o /dev/null
  echo "  → Organization/${org} chargée."
done

echo ""
echo "🏥 Chargement des HealthcareService..."
for hs in hs-ch-exemple-urgences hs-service-urgences-pediatriques hs-clinique-exemple-urgences; do
  curl -sf -X PUT "${FHIR_BASE}/HealthcareService/${hs}" \
    -H "Content-Type: application/fhir+json" \
    -d @"${FSH_OUT}/HealthcareService-${hs}.json" -o /dev/null
  echo "  → HealthcareService/${hs} chargée."
done

echo ""
echo "🔬 Évaluation (résultat attendu : 2 non conformes / 3 concernées)..."
curl -s -X POST "${FHIR_BASE}/Measure/OrganizationsNonConformesNomUrgence/\$evaluate-measure" \
  -H "Content-Type: application/fhir+json" \
  -d '{"resourceType":"Parameters","parameter":[{"name":"periodStart","valueDate":"2020-01-01"},{"name":"periodEnd","valueDate":"2026-12-31"},{"name":"reportType","valueCode":"subject-list"}]}'
