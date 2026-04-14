---
name: adversarial-review
description: >
  Adversarial code and architecture review with forced-disagreement debate.
  Use when: "adversarial review", "red team this", "devil's advocate",
  "find holes", "critique this", "break this", "stress test", "poke holes",
  "what's wrong with this", "find weaknesses", "challenge this".
metadata:
  version: "1.3"
  sources:
    - richiethomas/claude-devils-advocate (debate mechanic)
    - posit-dev/skills/critical-code-reviewer (detection patterns, severity tiers)
    - danielmiessler/Personal_AI_Infrastructure/RedTeam (multi-perspective attack)
    - garrytan/gstack (specialist dispatch, confidence scoring, fix-first)
---

# Adversarial Review

**Core principles:**
1. Guilty until proven exceptional — assume every line is broken
2. Evaluate artifacts, not intent — ignore "TODO" and "will fix later"
3. Forced disagreement — MUST challenge before conceding
4. Concrete over abstract — every finding needs a code snippet
5. **Compound prior learnings** — every review MUST consult `~/.claude/error-tracker.json` and `~/.claude/knowledge-base/` before generating findings (see A.0)

**Anti-sycophancy test:** If the review would make the author say "yeah, I knew all that" — dig deeper.

## Prerequisites

Before using this skill, configure the Detection Patterns for your tech stack.

### Step 1: Choose Your Stack Extensions

Copy the relevant extension blocks into your project-level override at `.claude/skills/adversarial-review/SKILL.md`. You can combine multiple extensions.

<details>
<summary><strong>React / React Native / Expo</strong></summary>

Add to Detection Patterns table:
```
| **React/RN** | Uncontrolled re-renders, `useEffect` dep array lies, index as `key`, missing error boundaries, no `Keyboard.dismiss()`, stale closure in callbacks |
```

Add to A.3 Specialist table:
```
| **React/RN** | Unnecessary re-renders, missing memoization, heavy bridge traffic | "What happens with 100 list items?" |
```
</details>

<details>
<summary><strong>Django / Python</strong></summary>

Add to Detection Patterns table:
```
| **Django** | Bare `except:`, mutable default args, missing `select_related`/`prefetch_related`, raw SQL without parameterization, `DEBUG=True` in production, missing CSRF middleware |
```

Add to A.3 Specialist table:
```
| **Django** | N+1 ORM queries, missing DB indexes, unoptimized querysets | "What does `django-debug-toolbar` show?" |
```
</details>

<details>
<summary><strong>Rails / Ruby</strong></summary>

Add to Detection Patterns table:
```
| **Rails** | N+1 queries (missing `includes`), mass assignment without `strong_parameters`, unscoped `find`, raw SQL interpolation, missing `null: false` on required columns |
```

Add to A.3 Specialist table:
```
| **Rails** | N+1 ActiveRecord, missing counter caches, heavy callbacks | "What does `bullet` gem report?" |
```
</details>

<details>
<summary><strong>Supabase / PostgreSQL</strong></summary>

Add to Detection Patterns table:
```
| **Supabase/PG** | RLS gaps, SECURITY DEFINER missing `SET search_path`, `!= NULL` (use `IS DISTINCT FROM`), missing `FOR UPDATE` on concurrent reads, upsert + RLS silent failure, `SQLERRM` leak in exception handlers |
```

Add to A.3 Specialist table:
```
| **Supabase/PG** | RLS policy gaps, SECURITY DEFINER misuse, missing row-level locks | "Can an attacker bypass this RLS?" |
```
</details>

<details>
<summary><strong>Next.js / Vercel</strong></summary>

Add to Detection Patterns table:
```
| **Next.js** | Client component fetching server data, missing `revalidate`, secrets in client bundle, unprotected API routes, missing `middleware.ts` auth checks |
```

Add to A.3 Specialist table:
```
| **Next.js** | Bundle size, unnecessary client components, missing ISR/SSG | "What's the Lighthouse score impact?" |
```
</details>

### Step 2: Create Project Override (Optional)

```bash
mkdir -p .claude/skills/adversarial-review
cp ~/.claude/skills/adversarial-review/SKILL.md .claude/skills/adversarial-review/SKILL.md
# Edit to add your chosen stack extensions
```

The project-level file takes precedence, so you can freely customize without affecting the global skill.

---

## Mode Selection

| Input | Mode |
|-------|------|
| Git diff / PR / changed files | **Code Review** (Phase A) |
| Architecture doc / design / plan | **Architecture Attack** (Phase B) |
| Both or unclear | Ask user to clarify scope |

## Confidence Scoring (applies to ALL findings in both phases)

Every finding MUST include a confidence score:

| Score | Action |
|-------|--------|
| 9-10 | Surface — high-confidence, likely demonstrable |
| 7-8 | Surface with evidence — probable issue |
| 4-6 | Suppress to "Low-confidence appendix" only |
| 1-3 | Discard entirely |

> Confidence scores are heuristic rankings, not statistical probabilities. They force the model to commit to a priority order rather than presenting all findings at equal weight.

Format: `[CONFIDENCE: 8/10] Missing await on deleteUser() — fire-and-forget will silently fail`

## Severity Tiers (applies to ALL findings)

| Tier | Definition | PR Score Weight |
|------|-----------|-----------------|
| **Blocking** | Security holes, data corruption, logic errors, race conditions, silent failures | -15 |
| **Required** | Lazy patterns, unhandled edge cases, poor naming, type safety violations | -5 |
| **Suggestion** | Suboptimal approaches, missing tests, performance concerns | -1 |

## Detection Patterns Reference

These patterns apply across Steps A.1-A.4. Each step references this table — it is not repeated.

| Category | Patterns |
|----------|----------|
| **SQL Safety** | Raw string interpolation, missing parameterization, unbounded queries without LIMIT, N+1 patterns, missing indexes, `!= NULL` (use `IS DISTINCT FROM` / `IS NOT NULL`) |
| **Auth/Security** | Missing permission checks, injection vectors, secrets in code, XSS, CSRF, auth bypass, privilege escalation |
| **Race/Async** | Missing `await`, unguarded shared state, fire-and-forget promises, stale closures, TOCTOU |
| **Silent Failures** | Empty `catch {}`, log-only error handling, bare `except:`, missing rollback, swallowed errors |
| **Data Integrity** | Partial writes without transactions, missing rollback, NULL mishandling, missing uniqueness constraints |
| **Type Safety** | `any` abuse (TS), `==` instead of `===` (JS), bare `except:` (Python), unchecked nulls, mutable default args |

> **Extend this table** with your framework-specific patterns. See [Prerequisites](#prerequisites) for ready-made extensions.

## Phase A: Adversarial Code Review

### A.0 — Consult Prior Learnings (if available)

Before reviewing, load project-specific error patterns from any external knowledge sources you have. This step makes the skill compound learnings across sessions.

**Try to read (skip silently if file does not exist):**

1. `~/.claude/error-tracker.json` — if present, extract patterns where `count >= 2` AND the current project is in `projects[]`. These are **codebase-specific blockers** that have bitten before.
2. `~/.claude/knowledge-base/index.md` — if present, skim the "Solutions" and "Decisions" sections for entries tagged with the current project OR mentioning files/modules in the diff. Read up to 3 most relevant entries in full.
3. `<project>/.claude/plpgsql-graph-report.md` — if present AND the diff touches SQL/PL-pgSQL, check **God Nodes** and **Trigger Chains** for the blast-radius of modified functions.
4. Any project-specific `CLAUDE.md` rules already in context (these are auto-loaded).

**Output a "Prior Learnings Applied" preamble before A.1**, even when nothing was found:

```
## Prior Learnings Applied
- Error patterns in scope: [list, or "none / file not present"]
- Relevant KB entries: [list wikilinks, or "none / file not present"]
- Graph hits: [God Node / Trigger Chain hits, or "none / N/A"]
```

Findings during A.2–A.4 that match a loaded pattern receive **+1 confidence** and **auto-promote to Blocking severity** regardless of default tier. Cite the source: `[matches error-tracker pattern #3]` or `[matches KB: 2026-04-13_logger-sink-fallback-buffer]`.

> Optional integration: This step works best with the [Knowledge Flywheel](https://github.com/lemon03390/Claude-code-adversarial-review-skill#knowledge-flywheel) pattern. If you don't have these files, the preamble simply notes "file not present" and the review proceeds normally.

### A.1 — Scope

```
git diff main...HEAD
```
If empty, try `git diff --staged`. If still empty, say so and stop.

### A.2 — Critical Scan

Silent first pass using the Detection Patterns table. Any findings with confidence >= 7 are **automatic blockers** — list them before the debate. These are non-negotiable.

### A.3 — Parallel Specialist Dispatch (>= 100 lines only)

For diffs < 100 lines, skip to A.4.

Launch 4 specialist subagents in parallel using the Agent tool:

| Specialist | Focus | Key Question |
|------------|-------|-------------|
| **Security** | Auth bypass, injection, privilege escalation | "How would I exploit this?" |
| **Performance** | N+1, O(n^2), missing indexes, memory leaks | "What happens at 10x traffic?" |
| **Testing** | Missing negative-path tests, untested branches | "What test catches a regression?" |
| **Error Handling** | Silent failures, missing rollback, retry logic | "What happens when this fails?" |

> **Extend this table** with framework-specific specialists from [Prerequisites](#prerequisites).

Each specialist: review ONLY their domain, attach confidence score + severity, return findings.

After all return: deduplicate -> filter (confidence < 7 suppressed) -> rank (severity desc, confidence desc) -> feed into debate.

### A.4 — Devil's Advocate Debate

Simulate Author vs Reviewer (senior engineer):

**Rules:**
- Up to N rounds (default 5, user can specify via `$ARGUMENTS`)
- Label: `### Round N — [Topic]`
- Reviewer MUST raise >= 1 substantive concern per round (no style nitpicks when real issues remain)
- Author MUST push back on >= 1 point per round before conceding
- Every suggestion includes a concrete code snippet
- If A.3 ran, Reviewer uses specialist findings as ammunition (debate them, don't blindly accept)
- Early termination if all topics resolved: "Consensus reached after N rounds."

**Topic priority** (in order, apply Detection Patterns throughout):
1. Correctness — bugs, logic errors, edge cases, race conditions
2. Error handling — missing error paths, swallowed exceptions
3. Performance — N+1, allocations, algorithmic issues
4. Security — injection, auth gaps, data exposure
5. Maintainability — abstractions, coupling, naming
6. Testing gaps — missing tests, untested branches

Reserve >= 1 round for lower-priority topics. Flag any skipped topics in the summary.

### A.5 — Fix-First (Auto-Fix)

**Guard:** Default is read-only (no auto-fix). Auto-fix is enabled ONLY when:
- `$ARGUMENTS` contains `--fix`, OR
- User's request explicitly implies fixing (e.g., "review and fix", "clean this up")

If user's request implies read-only review ("critique", "find holes", "what's wrong") and no `--fix` flag, list fixes as recommendations only.

**Auto-fixable** (unambiguous, mechanical):
- Missing `await`, empty `catch {}` -> add proper error handling, `==` -> `===`, `!= NULL` -> `IS DISTINCT FROM`, unused imports, obvious typos

**NOT auto-fixable** (require human decision):
- Architecture changes, business logic, error strategy choices, performance tradeoffs

Format: `Fixed: [description]` or `Needs decision: [options]`

### A.6 — PR Quality Score & Summary

**Score:** `max(0, 100 - Blocking x 15 - Required x 5 - Suggestion x 1 + AutoFixed x 2)`

| Score | Grade |
|-------|-------|
| 90-100 | A — Ship it |
| 75-89 | B — Few required changes |
| 60-74 | C — Needs work |
| <60 | D/F — Significant issues |

**Summary format:**
```
## Summary
### PR Quality Score: [XX]/100 — Grade [X]
### Auto-Fixed (N items)
### Blockers (confidence >= 7)
### Round Breakdown (Topic | Rounds | Findings | Avg Confidence)
### Agreed Changes (with code snippets)
### Open Disagreements
### Action Items (N) — confidence >= 7, priority-ranked
### Low-Confidence Appendix (4-6)
### Deferred Concerns
### Verdict: Request Changes | Needs Discussion | Approve
### Re-run Recommendation
```

### A.7 — Flywheel Feedback (if A.0 was available)

If A.0 loaded any external knowledge, add a **Flywheel Feedback** block so learnings compound. Skip this step entirely if A.0 found nothing.

```
## Flywheel Feedback
- New patterns (not in tracker): [blocker descriptions, one line each, or "none"]
- Would-have-caught (existing KB entry that matches): [wikilinks, or "none"]
- Archive recommended: [yes/no — yes if >= 1 new pattern or architectural insight]
```

If any blocker matches an **existing** promoted rule in your project/global `CLAUDE.md`, surface this explicitly: `⚠️ This is a promoted rule violation — why did it still slip through?` — the gap itself is valuable signal.

## Phase B: Architecture Attack

### B.1 — Decomposition

Break proposal into 10-20 **atomic claims**:
```
Claim 1: "Using microservices will improve scalability"
Claim 2: "Migration can be done without downtime"
```

### B.2 — Multi-Perspective Attack

Attack each claim from 6 perspectives:

| Perspective | Asks |
|-------------|------|
| **Skeptical Engineer** | "Simplest thing that could go wrong?" |
| **Incident Responder** | "How do we debug this at 3 AM?" |
| **Security Researcher** | "How would I exploit this?" |
| **Junior Developer** | "Can I maintain this in 6 months?" |
| **Cost Analyst** | "Hidden operational cost?" |
| **Devil's Advocate** | "What if the opposite approach is better?" |

Each finding: attach confidence score + severity (Blocking / Required / Suggestion — same tiers as Phase A).

### B.3 — Steelman & Counter-Argument

- **Steelman**: 5 strongest points in favor (present as if selling it)
- **Counter-Argument**: 5 most devastating weaknesses (present as if killing it)

### B.4 — Verdict

```
## Architecture Review
### Atomic Claims
### Attack Findings (by perspective, with severity)
### Steelman (5 points)
### Counter-Argument (5 points)
### Fatal Flaws (issues that collapse the approach — or "none found")
### Verdict: Rethink | Revise | Proceed with noted risks
### Recommended Mitigations
```
