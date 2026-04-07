Use the adversarial-review skill to review the current changes.

Scope: $ARGUMENTS

Defaults: git diff of current branch vs main, 5 debate rounds, read-only mode (no auto-fix).

Argument examples:
- (empty) — default code review
- `8` — 8 rounds of debate
- `architecture` — switch to Architecture Attack (Phase B)
- `--fix` — enable auto-fix for mechanical issues
