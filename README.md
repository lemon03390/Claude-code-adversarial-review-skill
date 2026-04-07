# Adversarial Review — Claude Code Skill

A battle-tested adversarial code and architecture review skill for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Forces genuine critical analysis through structured debate, confidence-scored findings, and multi-perspective attack — designed to break through LLM sycophancy.

## Why This Exists

LLMs default to agreeable, surface-level code reviews. This skill forces Claude to:

- **Debate itself** — simulating Author vs Senior Reviewer with mandatory disagreement
- **Score confidence** — every finding rated 1-10, low-confidence noise suppressed
- **Dispatch specialists** — parallel security/performance/testing/error-handling subagents
- **Auto-fix** what's unambiguous, flag what needs human decision
- **Quantify quality** — PR Quality Score (0-100) with letter grade

## Feature Comparison

| Feature | Plain "review my code" | This Skill |
|---------|----------------------|------------|
| Structured analysis | No | 6-step pipeline |
| Anti-sycophancy | No | Forced disagreement + mandatory pushback |
| Confidence filtering | No | 1-10 score, <7 suppressed |
| Parallel specialists | No | 4 domain experts in parallel |
| Auto-fix | No | Mechanical fixes applied automatically |
| PR Quality Score | No | Quantified 0-100 with grade |
| Architecture review | No | 6-perspective attack + steelman/counter |
| Framework extensions | No | Plug-in detection patterns per stack |

## Installation

### Quick Install (recommended)

```bash
# Clone to Claude Code global skills directory
mkdir -p ~/.claude/skills/adversarial-review
curl -o ~/.claude/skills/adversarial-review/SKILL.md \
  https://raw.githubusercontent.com/anthropics/adversarial-review-skill/main/SKILL.md

# Optional: Add slash command
mkdir -p ~/.claude/commands
curl -o ~/.claude/commands/adversarial-review.md \
  https://raw.githubusercontent.com/anthropics/adversarial-review-skill/main/commands/adversarial-review.md
```

### Manual Install

```bash
git clone https://github.com/anthropics/adversarial-review-skill.git
cp adversarial-review-skill/SKILL.md ~/.claude/skills/adversarial-review/SKILL.md
cp adversarial-review-skill/commands/adversarial-review.md ~/.claude/commands/adversarial-review.md
```

### Install Script

```bash
git clone https://github.com/anthropics/adversarial-review-skill.git
cd adversarial-review-skill
./install.sh
```

## Usage

### Code Review (Phase A)

```
# Default: review current branch vs main, 5 rounds of debate
/adversarial-review

# Specify number of debate rounds
/adversarial-review 8

# Natural language also works
> adversarial review my changes
> red team this PR
> find holes in this code
```

### Architecture Review (Phase B)

```
/adversarial-review architecture

# Or natural language
> devil's advocate this design
> stress test this architecture
> attack this proposal
```

### What You Get

**Code Review output:**
```
## Summary
### PR Quality Score: 72/100 — Grade C
### Auto-Fixed (3 items)
### Blockers (confidence >= 7)
  - [CONFIDENCE: 9/10] Missing await on deleteUser() — fire-and-forget
  - [CONFIDENCE: 8/10] Empty catch {} in payment handler — silent failure
### Round Breakdown
  | Topic          | Rounds | Findings | Avg Confidence |
  | Correctness    | 2      | 3        | 8.3            |
  | Error Handling | 1      | 2        | 7.5            |
  | Security       | 1      | 1        | 8.0            |
  | Testing        | 1      | 2        | 6.5            |
### Verdict: Request Changes
```

**Architecture Review output:**
```
## Architecture Review
### Atomic Claims (15 claims decomposed)
### Attack Findings
  - Skeptical Engineer: [CONFIDENCE: 9] Single point of failure in...
  - Incident Responder: [CONFIDENCE: 8] No runbook for...
  - Security Researcher: [CONFIDENCE: 7] Token rotation missing...
### Steelman (5 points)
### Counter-Argument (5 points)
### Fatal Flaws: None found
### Verdict: Revise — 3 mitigations recommended
```

## Customization

### Framework-Specific Extensions

The skill ships with a universal detection pattern set. Add framework-specific patterns for your stack:

| Extension | Adds Detection For |
|-----------|-------------------|
| **React / React Native** | Re-render issues, useEffect dep lies, missing error boundaries |
| **Django / Python** | N+1 ORM, bare except, missing select_related |
| **Rails / Ruby** | N+1 ActiveRecord, mass assignment, missing includes |
| **Supabase / PostgreSQL** | RLS gaps, SECURITY DEFINER misuse, NULL traps |
| **Next.js / Vercel** | Client/server boundary leaks, missing revalidate |

See the **Prerequisites** section in [SKILL.md](./SKILL.md) for copy-paste extension blocks.

### Project-Level Override

```bash
# Create project-specific version
mkdir -p .claude/skills/adversarial-review
cp ~/.claude/skills/adversarial-review/SKILL.md .claude/skills/adversarial-review/SKILL.md
# Edit to add your stack extensions + custom patterns
```

Project-level overrides take precedence over the global skill.

## How It Works

### Phase A: Code Review Pipeline

```
A.1 Scope         → git diff main...HEAD
A.2 Critical Scan → Silent pattern scan, auto-blockers (confidence >= 7)
A.3 Specialists   → 4 parallel subagents (Security/Perf/Test/Error) [>= 100 lines]
A.4 Debate        → Author vs Reviewer, N rounds, forced disagreement
A.5 Fix-First     → Auto-fix mechanical issues, flag decisions
A.6 Summary       → PR Quality Score + structured report
```

### Phase B: Architecture Attack Pipeline

```
B.1 Decompose     → Break into 10-20 atomic claims
B.2 Attack        → 6 perspectives attack each claim
B.3 Steelman      → 5 best arguments for + 5 against
B.4 Verdict       → Rethink / Revise / Proceed
```

### Anti-Sycophancy Mechanisms

| Mechanism | Source | How It Works |
|-----------|--------|-------------|
| Forced disagreement | [devils-advocate](https://github.com/richiethomas/claude-devils-advocate) | Reviewer MUST find issues; Author MUST push back |
| Confidence filtering | [gstack](https://github.com/garrytan/gstack) | Score < 7 suppressed, reduces noise |
| Multi-perspective attack | [RedTeam](https://github.com/danielmiessler/Personal_AI_Infrastructure) | 6 adversarial viewpoints simultaneously |
| Detection patterns | [critical-code-reviewer](https://github.com/posit-dev/positron) | Language-specific red flags, not vibes |

## Token Consumption

| Scenario | Estimated Tokens |
|----------|-----------------|
| Small diff (< 100 lines), 5 rounds | ~15-20K |
| Medium diff (100-500 lines), 5 rounds + specialists | ~25-35K |
| Large diff (500+ lines), 8 rounds + specialists | ~40-50K |
| Architecture review (medium proposal) | ~20-30K |

vs. plain "review my code" prompt: ~3-8K (but lower quality, no structure, no anti-sycophancy)

## Version History

| Version | Lines | Changes |
|---------|-------|---------|
| v1.0 | 266 | Debate + Architecture Attack |
| v1.1 | 385 | + Confidence scoring, specialist dispatch, auto-fix, PR Score |
| v1.2 | 203 | /simplify: -47% lines, zero functional loss |

See [CHANGELOG.md](./CHANGELOG.md) for details.

## Contributing

PRs welcome! Especially:
- New framework extension blocks (Vue, Angular, Go, Rust, etc.)
- Improved detection patterns
- Real-world usage reports and tuning suggestions

## License

[MIT](./LICENSE)

## Credits

Built by synthesizing the best ideas from:
- [richiethomas/claude-devils-advocate](https://github.com/richiethomas/claude-devils-advocate) — debate mechanic
- [posit-dev/positron](https://github.com/posit-dev/positron) — detection patterns, severity tiers
- [danielmiessler/Personal_AI_Infrastructure](https://github.com/danielmiessler/Personal_AI_Infrastructure) — multi-perspective attack
- [garrytan/gstack](https://github.com/garrytan/gstack) — specialist dispatch, confidence scoring, fix-first
