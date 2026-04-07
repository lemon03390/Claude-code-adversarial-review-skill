#!/bin/bash
set -e

SKILL_DIR="$HOME/.claude/skills/adversarial-review"
CMD_DIR="$HOME/.claude/commands"

echo "Installing adversarial-review skill for Claude Code..."
echo ""

# Install skill
mkdir -p "$SKILL_DIR"
cp SKILL.md "$SKILL_DIR/SKILL.md"
echo "  Skill installed to: $SKILL_DIR/SKILL.md"

# Install slash command
mkdir -p "$CMD_DIR"
cp commands/adversarial-review.md "$CMD_DIR/adversarial-review.md"
echo "  Command installed to: $CMD_DIR/adversarial-review.md"

echo ""
echo "Done! You can now use:"
echo "  /adversarial-review        — review current branch changes"
echo "  /adversarial-review 8      — 8 rounds of debate"
echo "  /adversarial-review architecture  — architecture attack mode"
echo ""
echo "Next steps:"
echo "  1. Check the Prerequisites section in SKILL.md"
echo "  2. Add framework-specific detection patterns for your stack"
echo "  3. Optionally create a project-level override:"
echo "     mkdir -p .claude/skills/adversarial-review"
echo "     cp $SKILL_DIR/SKILL.md .claude/skills/adversarial-review/SKILL.md"
