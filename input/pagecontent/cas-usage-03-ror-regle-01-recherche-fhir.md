### Cas d'usage 03 — ROR : Règle #1 sans CQL (recherche FHIR)

**Objectif** : implémenter exactement la même règle que le [cas d'usage 02](cas-usage-02-ror.html) — identifier les `Organization` non conformes à la règle de nommage "urgence" ([issue #1](https://github.com/nriss/test-cql/issues/1)) — mais **sans CQL**, uniquement avec des requêtes de recherche FHIR standard (chaînage inversé `_has`, `_summary=count`, modificateur `:contains`) et un post-traitement minimal côté client.

Ce cas d'usage utilise les mêmes données de test que le cas 02 (`input/fsh/Examples/Organizations-ror-regle-01.fsh` et `HealthcareServices-ror-regle-01.fsh`) — il n'y a pas de nouveaux exemples à créer.

> **Pourquoi cette variante ?** Le cas 02 a mis en évidence un bug dans le module Clinical Reasoning de HAPI FHIR qui empêche `$evaluate-measure`/`Library/$evaluate` de fonctionner correctement dès qu'il y a plusieurs ressources du type de contexte CQL sur le serveur (voir le détail dans le cas 02). Ce cas 03 montre qu'on peut obtenir le même résultat sans dépendre de CQL ni de ce bug, au prix d'un post-traitement pour la partie de la règle que la recherche FHIR seule ne couvre pas.

#### Ce que la recherche FHIR couvre nativement

Les search parameters suivants, vérifiés sur le CapabilityStatement (`GET /fhir/metadata`) du serveur HAPI FHIR utilisé dans ce POC, permettent d'exprimer la quasi-totalité de la règle sans aucun post-traitement :

| Search parameter | Ressource | Type | Correspond à |
|---|---|---|---|
| `specialty` | `HealthcareService` | token | Activité Opérationnelle |
| `characteristic` | `HealthcareService` | token | Mode de prise en charge |
| `organization` | `HealthcareService` | reference | `HealthcareService.providedBy` |
| `name` (modificateur `:contains`) | `Organization` | string | Sous-chaîne insensible à la casse dans `Organization.name` |

**Chaînage inversé (`_has`)** : FHIR permet d'interroger `Organization` en filtrant sur les caractéristiques de `HealthcareService` qui la référencent, sans jamais évaluer de CQL :

```
GET /Organization
    ?_has:HealthcareService:organization:specialty=157,249
    &_has:HealthcareService:organization:characteristic=33
```

`_has:HealthcareService:organization:specialty=157,249` se lit : "les `Organization` référencées (via le search parameter `organization`, c'est-à-dire `HealthcareService.providedBy`) par au moins un `HealthcareService` dont `specialty` vaut 157 ou 249". Le second `_has` ajoute la contrainte sur `characteristic=33`. Les deux `_has` se combinent en ET.

#### Ce qui nécessite un post-traitement

FHIR R4 ne définit **aucun search parameter sur `Organization.alias`** (seul `name` est indexé), et il n'existe pas de façon standard de combiner en OU deux search parameters différents (`name` et `alias`) dans une seule requête. Le modificateur `:contains` permet de trouver les `Organization` dont le **nom** contient déjà "urgence" (utile pour un contrôle rapide), mais pas d'exclure en une seule requête celles qui sont conformes via `name` **ou** `alias`.

→ Pour la liste définitive des non-conformes, on récupère la liste complète des `Organization` concernées (une seule requête `_has`), puis on filtre côté client (`jq`) sur `name` **et** `alias`.

#### Requêtes et post-traitement

Script : `check-03-ror-regle-01-recherche-fhir.sh` (nécessite `jq`, et que les données de test du cas 02 soient déjà chargées — cf. `evaluate-02-ror-regle-01.sh`).

```bash
./check-03-ror-regle-01-recherche-fhir.sh
```

##### 1. Denominator — count natif FHIR

```bash
curl -s "http://localhost:8080/fhir/Organization?_has:HealthcareService:organization:specialty=157,249&_has:HealthcareService:organization:characteristic=33&_summary=count"
```

##### 2. Sous-ensemble déjà conforme par le nom — count natif FHIR (ne couvre pas `alias`)

```bash
curl -s "http://localhost:8080/fhir/Organization?_has:HealthcareService:organization:specialty=157,249&_has:HealthcareService:organization:characteristic=33&name:contains=urgence&_summary=count"
```

##### 3. Liste complète des Organization concernées

```bash
curl -s "http://localhost:8080/fhir/Organization?_has:HealthcareService:organization:specialty=157,249&_has:HealthcareService:organization:characteristic=33" \
  > organizations-concernees.json
```

##### 4. Post-traitement — non conformes (`name` ET `alias` ne contiennent pas "urgence")

```bash
jq -r '
  .entry[]?.resource
  | select(
      ((.name // "" | ascii_downcase | contains("urgence"))
        or ((.alias // []) | any(ascii_downcase | contains("urgence"))))
      | not
    )
  | "\(.id) — \(.name)"
' organizations-concernees.json
```

#### Résultat observé

Sur les 3 `Organization` de test du cas 02 (`org-ch-exemple`, `org-service-urgences`, `org-clinique-exemple`) :

```text
1️⃣  Denominator — Organization concernées par l'obligation de nommage (count FHIR natif)
   → 3 Organization concernées

2️⃣  Sous-ensemble déjà conforme par le nom (count FHIR natif, name:contains — ne couvre pas alias)
   → 1 Organization dont le name contient déjà "urgence"

3️⃣  Récupération de la liste complète des Organization concernées (pour le post-traitement)
   • org-ch-exemple — CH Exemple
   • org-service-urgences — Service des Urgences du CH Exemple
   • org-clinique-exemple — Clinique Exemple

4️⃣  Post-traitement (jq) — non conformes : ni name ni alias ne contient "urgence" (insensible à la casse)
   ❌ org-ch-exemple — CH Exemple
   ❌ org-clinique-exemple — Clinique Exemple

🔬 Résultat : 2 Organization non conforme(s).
```

Résultat identique à celui attendu pour la règle CQL du cas 02 (2 non conformes sur 3 concernées : `org-ch-exemple` et `org-clinique-exemple`), obtenu ici entièrement via des requêtes FHIR standard plus un filtrage client minimal — sans jamais passer par le moteur CQL ni par le bug documenté dans le cas 02.

#### Comparaison avec l'approche CQL (cas 02)

| | CQL (cas 02) | Recherche FHIR (cas 03) |
|---|---|---|
| Expressivité de la règle métier | Totale (une seule expression logique, y compris `name` OU `alias`) | Partielle nativement (`alias` non cherchable) → post-traitement requis |
| Dépendance à un moteur d'exécution | `$evaluate-measure` / Clinical Reasoning (bug rencontré sur ce serveur) | Aucune — recherche FHIR standard, supportée par tout serveur conforme |
| Fonctionne en l'état sur ce serveur | ❌ non (bug identifié) | ✅ oui |
| Réutilisable pour des règles plus complexes | Oui, nativement | Limité — chaque nouvelle condition croisée entre ressources peut nécessiter un nouveau `_has` ou un post-traitement supplémentaire |

Pour une règle aussi simple que celle-ci, la recherche FHIR + post-traitement est une alternative fiable et immédiatement opérationnelle. CQL garde l'avantage pour des règles plus complexes (agrégations, expressions temporelles, logique combinée sur de nombreux champs) — à condition que le moteur d'exécution la supporte correctement pour le contexte visé.
