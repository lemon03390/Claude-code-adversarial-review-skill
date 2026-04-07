# Changelog

## v1.2.1 (2026-04-07)

**Self-review fixes — the skill reviewed itself and found real issues.**

- Fixed: README URLs pointed to `anthropics/` instead of actual repo (would 404)
- Fixed: install.sh lacked `cd "$(dirname "$0")"` guard — broke when run from other directories
- Fixed: install.sh had no file existence checks
- Fixed: Line count claims (said 203, actual ~300 with prerequisite extensions)
- Fixed: Phase B used different severity terms (Fatal/Serious/Minor) vs Phase A (Blocking/Required/Suggestion) — unified
- Fixed: Confidence tier said "certain bug" — softened to "high-confidence, likely demonstrable" with heuristic disclaimer
- Fixed: posit-dev source name inconsistent between SKILL.md and README
- Improved: Command file expanded with argument examples and default mode documentation
- Improved: Token estimates marked as rough/untested

## v1.2 (2026-04-07)

**Simplification pass — 47% reduction, zero functional loss.**

- Consolidated Detection Patterns into single reference table (was duplicated in 4 steps)
- Fixed Step 5 positioning (was after debate but said "during debate")
- Added Guard condition for Fix-First (read-only triggers skip auto-fix)
- Resolved Phase A/B step numbering collision (now A.1-A.6 / B.1-B.4)
- Fixed PR Score allowing negative values (now `max(0, ...)`)
- Removed redundant credits block (already in frontmatter)
- Compressed philosophy section from 27 lines to 5-line core principles
- Added Prerequisites section with framework extension blocks
- 385 lines -> ~200 lines (core), ~300 lines with framework extensions

## v1.1 (2026-04-07)

**Major feature additions.**

- Added Confidence Scoring (1-10 scale, <7 suppressed)
- Added Parallel Specialist Dispatch (4 subagents: Security, Performance, Testing, Error Handling)
- Added Fix-First Auto-Fix (mechanical fixes applied automatically)
- Added PR Quality Score (0-100 with letter grade)
- Added framework-specific detection patterns
- 266 lines -> 385 lines

## v1.0 (2026-04-07)

**Initial release.**

Synthesized from 4 open-source projects:
- `richiethomas/claude-devils-advocate` — forced-disagreement debate mechanic
- `posit-dev/skills/critical-code-reviewer` — detection patterns, severity tiers
- `danielmiessler/Personal_AI_Infrastructure/RedTeam` — multi-perspective architecture attack
- `garrytan/gstack` — specialist dispatch concept

Features:
- Phase A: Adversarial Code Review (debate-based)
- Phase B: Architecture Attack (6-perspective)
- Detection Patterns for SQL, Auth, Race/Async, Silent Failures, Data Integrity, Type Safety
- Mode selection based on input type
