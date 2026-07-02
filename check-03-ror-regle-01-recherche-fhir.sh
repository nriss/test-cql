#!/usr/bin/env bash
# Cas 03 — ROR, Règle #1 (variante sans CQL) : Organization avec le nom "Urgence"
# Même règle que le cas 02, mais exprimée uniquement avec des requêtes de recherche FHIR
# (_has, _summary=count, :contains) + un post-traitement jq pour le test sur alias.
# Résultat attendu : 3 Organization concernées, 2 non conformes (org-ch-exemple, org-clinique-exemple)
# Usage : ./check-03-ror-regle-01-recherche-fhir.sh (HAPI FHIR doit tourner sur le port 8080,
#         avec les Organization/HealthcareService du cas 02 déjà chargées — cf. evaluate-02-ror-regle-01.sh)
set -euo pipefail

FHIR_BASE="http://localhost:8080/fhir"
HAS_FILTER="_has:HealthcareService:organization:specialty=157,249&_has:HealthcareService:organization:characteristic=33"

echo "⏳ Attente du démarrage de HAPI FHIR..."
until curl -sf "${FHIR_BASE}/metadata" -o /dev/null; do sleep 5; done
echo "✅ HAPI FHIR est prêt."

echo ""
echo "1️⃣  Denominator — Organization concernées par l'obligation de nommage (count FHIR natif)"
curl -s "${FHIR_BASE}/Organization?${HAS_FILTER}&_summary=count" | jq -r '"   → " + (.total | tostring) + " Organization concernées"'

echo ""
echo "2️⃣  Sous-ensemble déjà conforme par le nom (count FHIR natif, name:contains — ne couvre pas alias)"
curl -s "${FHIR_BASE}/Organization?${HAS_FILTER}&name:contains=urgence&_summary=count" | jq -r '"   → " + (.total | tostring) + " Organization dont le name contient déjà \"urgence\""'

echo ""
echo "3️⃣  Récupération de la liste complète des Organization concernées (pour le post-traitement)"
curl -s "${FHIR_BASE}/Organization?${HAS_FILTER}" > /tmp/organizations-concernees.json
jq -r '.entry[]?.resource | "   • \(.id) — \(.name)"' /tmp/organizations-concernees.json

echo ""
echo "4️⃣  Post-traitement (jq) — non conformes : ni name ni alias ne contient \"urgence\" (insensible à la casse)"
NON_CONFORMES=$(jq -r '
  .entry[]?.resource
  | select(
      ((.name // "" | ascii_downcase | contains("urgence"))
        or ((.alias // []) | any(ascii_downcase | contains("urgence"))))
      | not
    )
  | "   ❌ \(.id) — \(.name)"
' /tmp/organizations-concernees.json)
echo "${NON_CONFORMES}"

NB_NON_CONFORMES=$(jq -r '
  [.entry[]?.resource
  | select(
      ((.name // "" | ascii_downcase | contains("urgence"))
        or ((.alias // []) | any(ascii_downcase | contains("urgence"))))
      | not
    )] | length
' /tmp/organizations-concernees.json)
echo ""
echo "🔬 Résultat : ${NB_NON_CONFORMES} Organization non conforme(s)."
