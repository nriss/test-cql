#!/usr/bin/env bash
set -euo pipefail

FHIR_BASE="http://localhost:8080/fhir"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── 1. Attendre HAPI FHIR ────────────────────────────────────────────────────
echo "⏳ Attente du démarrage de HAPI FHIR..."
until curl -sf "${FHIR_BASE}/metadata" -o /dev/null; do
  sleep 5
done
echo "✅ HAPI FHIR est prêt."

# ─── 2. Charger la Library ───────────────────────────────────────────────────
echo ""
echo "📚 Chargement de la Library..."
curl -sf -X PUT "${FHIR_BASE}/Library/HelloCQL" \
  -H "Content-Type: application/fhir+json" \
  -d @"${SCRIPT_DIR}/fhir/library-hello-cql.json" -o /dev/null
echo "  → Library/HelloCQL chargée."

# ─── 3. Charger la Measure ───────────────────────────────────────────────────
echo ""
echo "📏 Chargement de la Measure..."
curl -sf -X PUT "${FHIR_BASE}/Measure/patients-65plus" \
  -H "Content-Type: application/fhir+json" \
  -d @"${SCRIPT_DIR}/fhir/measure-patients-65plus.json" -o /dev/null
echo "  → Measure/patients-65plus chargée."

# ─── 4. Charger les patients ─────────────────────────────────────────────────
echo ""
echo "👥 Chargement des patients..."
curl -sf -X POST "${FHIR_BASE}" \
  -H "Content-Type: application/fhir+json" \
  -d @"${SCRIPT_DIR}/fhir/bundle-patients.json" -o /dev/null
echo "  → 5 patients chargés (3 >= 65 ans, 2 < 65 ans)."

# ─── 5. Rapport agrégé ───────────────────────────────────────────────────────
echo ""
echo "🔬 Évaluation — rapport agrégé (résultat attendu : 3/5)..."
curl -s -X POST "${FHIR_BASE}/Measure/patients-65plus/\$evaluate-measure" \
  -H "Content-Type: application/fhir+json" \
  -d '{"resourceType":"Parameters","parameter":[{"name":"periodStart","valueDate":"2020-01-01"},{"name":"periodEnd","valueDate":"2026-12-31"},{"name":"reportType","valueCode":"population"}]}'

# ─── 6. Rapport individuel ───────────────────────────────────────────────────
echo ""
echo ""
echo "🔬 Rapport individuel — Patient/pat-martin (Jean Martin, né en 1945, >= 65 ans)..."
curl -s -X POST "${FHIR_BASE}/Measure/patients-65plus/\$evaluate-measure" \
  -H "Content-Type: application/fhir+json" \
  -d '{"resourceType":"Parameters","parameter":[{"name":"periodStart","valueDate":"2020-01-01"},{"name":"periodEnd","valueDate":"2026-12-31"},{"name":"subject","valueString":"Patient/pat-martin"},{"name":"reportType","valueCode":"individual"}]}'
