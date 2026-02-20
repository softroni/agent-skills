# ASO Engine Tool Reference

## Available Tools (softroni-aso MCP)

### batch_keyword_analysis
Bulk keyword scoring. Max 5 per call to avoid timeouts.
```
mcporter call 'softroni-aso.batch_keyword_analysis' --args '{"keywords": ["kw1", "kw2", "kw3", "kw4", "kw5"]}'
```
Returns: popularity (0-100), difficulty (0-100), competition (0-100), opportunity (0-100), branded (bool)

**Interpreting scores:**
- Popularity: Higher = more searches. 80+ is strong.
- Difficulty: Entry-point weighted (60% top-10 avg, 40% weakest slot). Lower = easier to rank.
- Opportunity: Combined score. 50+ non-branded = good. 75+ branded = long-tail gold.
- Branded: diff=0, comp=0 means Apple broad-matches but nobody specifically targets this term.

### search_rankings
Real App Store search results for a keyword.
```
mcporter call 'softroni-aso.search_rankings' --args '{"keyword": "recipe keeper"}'
```
Returns: position, app_id, name, developer, rating, reviews, price for each result.

Parse with python for clean output:
```bash
mcporter call 'softroni-aso.search_rankings' --args '{"keyword": "KEYWORD"}' 2>&1 | python3 -c "
import sys, json
d = json.load(sys.stdin)
for r in d['data']['results'][:10]:
    print(f\"#{r['position']} | {r['name'][:40]} | {r['reviews']} reviews | {r['rating']:.1f}★\")
"
```

### keyword_autocomplete
Get autocomplete suggestions from a prefix.
```
mcporter call 'softroni-aso.keyword_autocomplete' --args '{"prefix": "recipe"}'
```

### app_details
Get detailed info about a specific app.
```
mcporter call 'softroni-aso.app_details' --args '{"app_id": "1303222868"}'
```

### competitor_compare
Compare multiple apps side by side.
```
mcporter call 'softroni-aso.competitor_compare' --args '{"app_ids": ["id1", "id2", "id3"]}'
```

## Keyword Expansion Strategy

Start broad, go specific. Example for recipe niche:

**Batch 1 (Core):** recipe keeper, recipe manager, recipe organizer, save recipes, cookbook app
**Batch 2 (Actions):** recipe app, recipe saver, recipe clipper, meal planner, grocery list  
**Batch 3 (Adjacent):** cooking app, recipe book, recipe box, food planner, recipe collection
**Batch 4 (Long-tail):** recipe scanner, digitize recipes, recipe import, family recipes, handwritten recipe
**Batch 5 (Niche):** clean recipes, simple recipes, recipe storage, my recipes, recipe finder
**Batch 6 (Features):** digital cookbook, recipe catalog, meal prep app, weekly meal plan, recipe card

## Domain Availability Check Pattern

```bash
for name in "name1" "name2" "name3"; do
  status_com=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "https://${name}.com" 2>&1)
  status_app=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "https://${name}.app" 2>&1)
  echo "$name: .com=$status_com .app=$status_app"
done
```

- 000 = connection failed = likely unregistered (available)
- 200 = active site (check if parked or real product)
- 301/302 = redirect (check where it goes)
- 403 = domain for sale on registrar marketplace

## App Store Name Conflict Check Pattern

```bash
for name in "Name1" "Name2"; do
  mcporter call 'softroni-aso.search_rankings' --args "{\"keyword\": \"$name\"}" 2>&1 | python3 -c "
import sys,json
d=json.load(sys.stdin)
results = d.get('data',{}).get('results',[])
taken = any('${name}'.lower() in r.get('name','').lower() for r in results[:5])
print(f'$name: {\"TAKEN\" if taken else \"CLEAR\"} | {len(results)} results')
" 2>&1
done
```
