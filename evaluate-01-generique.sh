#!/usr/bin/env bash
# Cas 01 — Exemple générique
# Règle CQL : proportion de patients âgés de 65 ans et plus
# Résultat attendu : 3/5 (score 0.6)
# Usage : ./evaluate-01-generique.sh  (HAPI FHIR doit tourner sur le port 8080)
# Prérequis : sushi doit avoir été lancé (fsh-generated/ doit exister)
set -euo pipefail

FHIR_BASE="http://localhost:8080/fhir"
FSH_OUT="$(cd "$(dirname "$0")" && pwd)/fsh-generated/resources"

if [ ! -f "${FSH_OUT}/Library-HelloCQL.json" ]; then
  echo "❌ fsh-generated/ absent. Lance d'abord : sushi . ou ./_genonce.sh"
  exit 1
fi

echo "⏳ Attente du démarrage de HAPI FHIR..."
until curl -sf "${FHIR_BASE}/metadata" -o /dev/null; do sleep 5; done
echo "✅ HAPI FHIR est prêt."

echo ""
echo "📚 Chargement de la Library..."
curl -sf -X PUT "${FHIR_BASE}/Library/HelloCQL" \
  -H "Content-Type: application/fhir+json" \
  -d @"${FSH_OUT}/Library-HelloCQL.json" -o /dev/null
echo "  → Library/HelloCQL chargée depuis fsh-generated/."

echo ""
echo "📏 Chargement de la Measure..."
curl -sf -X PUT "${FHIR_BASE}/Measure/Patients65Plus" \
  -H "Content-Type: application/fhir+json" \
  -d @"${FSH_OUT}/Measure-Patients65Plus.json" -o /dev/null
echo "  → Measure/Patients65Plus chargée depuis fsh-generated/."

echo ""
echo "👥 Chargement des patients..."
for patient in pat-martin pat-dubois pat-bernard pat-thomas pat-petit; do
  curl -sf -X PUT "${FHIR_BASE}/Patient/${patient}" \
    -H "Content-Type: application/fhir+json" \
    -d @"${FSH_OUT}/Patient-${patient}.json" -o /dev/null
  echo "  → Patient/${patient} chargé."
done

echo ""
echo "🔬 Évaluation (résultat attendu : 3/5)..."
curl -s -X POST "${FHIR_BASE}/Measure/Patients65Plus/\$evaluate-measure" \
  -H "Content-Type: application/fhir+json" \
  -d '{"resourceType":"Parameters","parameter":[{"name":"periodStart","valueDate":"2020-01-01"},{"name":"periodEnd","valueDate":"2026-12-31"},{"name":"reportType","valueCode":"population"}]}'
