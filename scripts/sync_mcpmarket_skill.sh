#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
SKILL_NAME="unity-agent-workflows"
TARGETS=(
  "$ROOT/.claude/skills/$SKILL_NAME"
  "$ROOT/skills/$SKILL_NAME"
  "$ROOT/plugins/unity-agent-workflows/skills/$SKILL_NAME"
)

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  rm -rf "$target/SKILL.md" "$target/references" "$target/agents"
  cp -R "$ROOT/SKILL.md" "$ROOT/references" "$ROOT/agents" "$target/"
  echo "synced $target"
done

echo "synced skill mirrors"
