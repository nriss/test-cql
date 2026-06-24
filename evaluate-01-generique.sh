#!/usr/bin/env bash
# Cas 01 — Exemple générique
# Règle CQL : proportion de patients âgés de 65 ans et plus
# Résultat attendu : 3/5 (score 0.6)
# Usage : ./evaluate-01-generique.sh  (HAPI FHIR doit tourner sur le port 8080)
set -euo pipefail

FHIR_BASE="http://localhost:8080/fhir"
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "⏳ Attente du démarrage de HAPI FHIR..."
until curl -sf "${FHIR_BASE}/metadata" -o /dev/null; do sleep 5; done
echo "✅ HAPI FHIR est prêt."

echo ""
echo "📚 Chargement de la Library..."
CQL_B64=$(base64 -i "${REPO_ROOT}/input/cql/HelloCQL.cql" | tr -d '\n')
curl -sf -X PUT "${FHIR_BASE}/Library/HelloCQL" \
  -H "Content-Type: application/fhir+json" \
  --data-binary @- <<EOF
{"resourceType":"Library","id":"HelloCQL","url":"http://poc-cql/Library/HelloCQL","version":"1.0.0","name":"HelloCQL","status":"active","type":{"coding":[{"system":"http://terminology.hl7.org/CodeSystem/library-type","code":"logic-library"}]},"content":[{"contentType":"text/cql","data":"${CQL_B64}"}]}
EOF
echo "  → Library/HelloCQL chargée."

echo ""
echo "📏 Chargement de la Measure..."
curl -sf -X PUT "${FHIR_BASE}/Measure/patients-65plus" \
  -H "Content-Type: application/fhir+json" \
  -d @"${REPO_ROOT}/fhir/measure-patients-65plus.json" -o /dev/null
echo "  → Measure/patients-65plus chargée."

echo ""
echo "👥 Chargement des patients..."
curl -sf -X POST "${FHIR_BASE}" \
  -H "Content-Type: application/fhir+json" \
  -d @"${REPO_ROOT}/fhir/bundle-patients.json" -o /dev/null
echo "  → 5 patients chargés (3 >= 65 ans, 2 < 65 ans)."

echo ""
echo "🔬 Évaluation (résultat attendu : 3/5)..."
curl -s -X POST "${FHIR_BASE}/Measure/patients-65plus/\$evaluate-measure" \
  -H "Content-Type: application/fhir+json" \
  -d '{"resourceType":"Parameters","parameter":[{"name":"periodStart","valueDate":"2020-01-01"},{"name":"periodEnd","valueDate":"2026-12-31"},{"name":"reportType","valueCode":"population"}]}'
