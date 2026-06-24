### Cas d'usage 01 — Exemple générique

**Objectif** : valider la stack HAPI FHIR + CQL avec un exemple standard avant d'aborder les données ROR.

**Règle CQL** : calculer la proportion de patients âgés de 65 ans et plus dans une population fictive.

#### Données de test

5 patients fictifs :

| Patient | Date de naissance | ≥ 65 ans ? |
|---------|-------------------|------------|
| Jean Martin | 1945-03-12 | ✅ oui |
| Marie Dubois | 1958-07-22 | ✅ oui |
| Pierre Bernard | 1990-11-05 | ❌ non |
| Lucie Thomas | 1938-01-30 | ✅ oui |
| Sophie Petit | 2000-06-15 | ❌ non |

**Résultat attendu** : numérateur = 3, dénominateur = 5, score = 0.6

#### CQL

```cql
library HelloCQL version '1.0.0'

using FHIR version '4.0.1'
include FHIRHelpers version '4.0.1'

context Patient

define "InitialPopulation":
  true

define "Denominator":
  true

define "Numerator":
  AgeInYears() >= 65
```

#### Lancer

```bash
cd poc/01-exemple-generique
docker compose up -d
./evaluate.sh
docker compose down
```
