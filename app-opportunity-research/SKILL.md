---
name: app-opportunity-research
description: End-to-end iOS app opportunity research — from idea generation to validated build spec with Notion article. Use when asked to find new app ideas, research an app concept, validate a market opportunity, do competitor teardowns, or create a full research report for a potential app. Covers market scanning, Reddit signal analysis, ASO keyword clustering (via softroni-aso MCP), competitor teardown, gap analysis, naming, pricing, GTM strategy, and build spec — all saved to Notion with data tables. NOT for building apps (use coding-agent), NOT for ASO on existing apps.
---

# App Opportunity Research

Research, validate, and document iOS app opportunities end-to-end. Output: Notion article with data + local memory file + MEMORY.md entry.

## Prerequisites

- `mcporter` CLI with `softroni-aso` MCP server configured (ASO keyword analysis)
- `mcporter` CLI with `notion-mcp` MCP server configured (Notion pages)
- `web_search` and `web_fetch` tools available
- Notion Research page ID in agent's MEMORY.md

## Workflow

Execute phases in order. Each phase feeds the next. Skip Phase 1 if user already has a specific idea.

### Phase 1: Idea Generation (if no specific idea given)

Find opportunity areas via market signals:

1. Search Reddit for frustration signals: `"I wish there was an app" site:reddit.com`, `"why is there no app"`, `"best [category] app" complaints`
2. Search for trending categories: `"most downloaded iOS apps [year]"`, `"profitable indie iOS app ideas"`
3. Check Adapty/Sensor Tower reports: `"most profitable app categories [year]"`
4. Look for the **frustration trifecta**: high complaint volume + existing apps with bad reviews + willingness to pay signals

Score each idea on: build time, revenue ceiling, competition level, TikTok virality potential.

### Phase 2: Broad Keyword Scan

Run 15 broad keywords through ASO engine:

```
mcporter call 'softroni-aso.batch_keyword_analysis' --args '{"keywords": ["keyword1", "keyword2", ...]}'
```

- Batch size: 5 keywords per call (avoids timeouts)
- Score each on: popularity, difficulty, competition, opportunity
- Look for opp 40+ non-branded and opp 75+ branded keywords
- Compare across categories to confirm best niche

### Phase 3: Keyword Cluster Expansion

Take top keywords from Phase 2, expand with:
- Synonyms (recipe keeper → recipe saver, recipe clipper, recipe organizer)
- Action keywords (save recipes, scan recipe, import recipe)
- Pain keywords (whats for dinner, easy meals, quick recipes)
- Feature keywords (grocery list, meal planner, cook mode)
- Long-tail (digitize recipes, handwritten recipe, family recipes)

Run 3-5 more batches of 5 keywords each. Goal: **16+ keywords with opp 50+** = strong cluster.

Track branded vs non-branded. Branded keywords (diff=0, comp=0) are long-tail gold for the keyword field.

### Phase 4: Search Rankings

Check who ranks for your top keywords:

```
mcporter call 'softroni-aso.search_rankings' --args '{"keyword": "your keyword"}'
```

For each result, note: position, app name, review count, star rating. Identify:
- **Beatable positions**: Apps with <500 reviews in top 10
- **Entry keywords**: Where the weakest top-10 app has fewest reviews
- **Giants to avoid**: Apps with 100K+ reviews (don't target their primary keyword)

### Phase 5: Competitor Teardown

For the top 3-5 competitors:

1. Fetch App Store listing: `web_fetch` on `apps.apple.com/us/app/[name]/id[id]`
2. Record: rating, review count, price, features, developer, size, languages, last update
3. Search Reddit for complaints: `"[app name]" complaints OR problems OR hate reddit`
4. Search for comparison threads: `"[app1] vs [app2]" reddit`

Document what each competitor does well AND what users hate.

### Phase 6: Gap Analysis

Cross-reference competitor features vs user complaints. Find whitespace:
- What does NOBODY do well?
- What do users explicitly ask for that no app provides?
- What pricing model do users prefer vs what competitors charge?
- What's the "obvious" feature that's somehow missing?

Frame as: "Competitor A does X but not Y. We do both."

### Phase 7: Market Validation

Search for hard data:
- Market size (TAM): `"[category] app market size [year]"`
- User base: `"how many [target users] [country]"` (e.g., "how many americans cook at home")
- Revenue benchmarks: Check TrendApps.dev, Adapty paywall library, AppFigures for competitor revenue
- Reddit demand threads: Count "what app do you use for X" threads in last 12 months
- Spending signals: Adjacent market spending (hardware, services, courses)

### Phase 8: Product Spec

Define:
- **Core value prop** (one sentence)
- **MVP features** (1-2 week build, minimum viable)
- **Phase 2 features** (post-launch expansion)
- **Tech stack** (prefer: SwiftUI, SwiftData/CloudKit, zero external APIs for MVP)
- **Monetization**: Free tier limits + paid unlock price. Benchmark against competitors.
- **MVP screens** (numbered priority list with descriptions)
- **Key technical decisions** (e.g., JSON-LD parsing vs HTML scraping)

### Phase 9: Pricing Strategy

Research and decide:
- What competitors charge (exact prices)
- Reddit sentiment on pricing models (subscription vs one-time)
- Adapty benchmarks for category (conversion rates, avg price)
- Set free tier generous enough to get hooked, paid tier priced to undercut or match leader

### Phase 10: Go-To-Market

Plan channels:
- **TikTok/Reels**: 2-3 specific content hook ideas (rage-bait, before/after, emotional)
- **Reddit**: List specific subreddits + subscriber counts + thread types to monitor
- **ASO**: Map keywords to title (30 chars), subtitle (30 chars), keyword field (100 chars)
- **Influencers**: Who to target, what to offer (free codes, partnerships)
- **Apple Search Ads**: Target keywords, estimated CPT

### Phase 11: Name Research

Generate 15-20 candidates. For EACH:

1. **ASO Engine check**: `batch_keyword_analysis` for branded keyword opp score
2. **App Store check**: `search_rankings` — is the exact name taken?
3. **Domain check**: `curl -s -o /dev/null -w "%{http_code}" https://[name].com` (and .app)
4. If domain returns 200/301/302, fetch it to check if parked or active product

Score on: domain availability, App Store clearance, opp score, memorability, evocativeness.

Keep a **reject list with reasons** so you never re-check the same name.

Lock the name only when: both .com/.app available (or purchasable), App Store clear, opp 75+.

## Output: Notion Article

Create a Notion page under the Research parent page. Structure:

1. **Executive Summary** — concept, market size, revenue target, build time
2. **Market Validation** — TAM, user base, demand signals, growth rate
3. **Competitor Teardown** — for each: rating, reviews, price, revenue, features, key weakness (use callout blocks)
4. **Gap Analysis** — numbered list of what nobody does well
5. **ASO Keyword Data** — full table of ALL keywords scanned (not just winners), sorted by opportunity. Include pop/diff/comp/opp columns. Show branded vs non-branded.
6. **Search Rankings** — top 10 for primary keywords with review counts
7. **Product Spec** — MVP screens, tech stack, Phase 2 features
8. **Pricing Strategy** — free tier, paid tier, competitor price comparison
9. **Go-To-Market** — TikTok hooks, Reddit subs, ASO placement, influencer plan
10. **Technical Notes** — key architecture decisions, API costs, stack
11. **Revenue Projections** — conservative/moderate/optimistic with math shown
12. **Name Research** — locked name + full reject list with reasons
13. **Build Spec** — bundle ID, app identity, design direction, ready for dev handoff
14. **Status** — current state and next steps

### Notion API Pattern

Create page:
```
mcporter call 'notion-mcp.API-post-page' --args '{"parent": {"page_id": "PARENT_ID"}, "properties": {"title": {"title": [{"text": {"content": "Title"}}]}}}'
```

Add blocks (write JSON to /tmp file first to avoid shell escaping issues):
```
# Write block JSON to file
write /tmp/notion-blocks.json with children array
# Then append
mcporter call 'notion-mcp.API-patch-block-children' block_id=PAGE_ID --args "$(cat /tmp/notion-blocks.json)"
```

Batch blocks in groups of ~20-30 to avoid API limits. Use multiple append calls.

## Output: Local Files

1. **Research file**: `memory/[app-name]-research.md` — all raw data, keyword tables, competitor stats
2. **MEMORY.md entry**: Summary block with concept, name, domains, keywords, competitors, revenue est, Notion page ID, next steps
3. **Daily log**: `memory/YYYY-MM-DD.md` — what was researched today

## Key Principles

- **Data over gut**: Every recommendation backed by numbers (keyword scores, review counts, revenue estimates)
- **Show ALL data**: Include keywords that scored poorly too — seeing what didn't work is valuable
- **Save EVERYTHING**: Notion article is the shareable knowledge base; local files are the agent's memory
- **Name research is thorough**: Check App Store + domains + ASO score for every candidate. Maintain reject list.
- **Anti-subscription trend**: 7% of Reddit app requests want one-time purchases (2026 data). Factor into pricing.
- **Beatable = <500 reviews in top 10**: This is our entry threshold for keyword viability
