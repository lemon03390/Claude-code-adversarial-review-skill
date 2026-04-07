#!/bin/bash
set -e

# Resolve script directory regardless of where it's called from
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

SKILL_DIR="$HOME/.claude/skills/adversarial-review"
CMD_DIR="$HOME/.claude/commands"

# Verify source files exist
if [ ! -f "$SCRIPT_DIR/SKILL.md" ]; then
  echo "Error: SKILL.md not found in $SCRIPT_DIR" >&2
  exit 1
fi
if [ ! -f "$SCRIPT_DIR/commands/adversarial-review.md" ]; then
  echo "Error: commands/adversarial-review.md not found in $SCRIPT_DIR" >&2
  exit 1
fi

echo "Installing adversarial-review skill for Claude Code..."
echo ""

# Install skill
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  Skill installed to: $SKILL_DIR/SKILL.md"

# Install slash command
mkdir -p "$CMD_DIR"
cp "$SCRIPT_DIR/commands/adversarial-review.md" "$CMD_DIR/adversarial-review.md"
echo "  Command installed to: $CMD_DIR/adversarial-review.md"

echo ""
echo "Done! You can now use:"
echo "  /adversarial-review              — review current branch changes"
echo "  /adversarial-review 8            — 8 rounds of debate"
echo "  /adversarial-review architecture — architecture attack mode"
echo ""
echo "Next steps:"
echo "  1. Check the Prerequisites section in SKILL.md for your framework"
echo "  2. Optionally create a project-level override:"
echo "     mkdir -p .claude/skills/adversarial-review"
echo "     cp $SKILL_DIR/SKILL.md .claude/skills/adversarial-review/SKILL.md"
