#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TARGET="$ROOT/.claude/skills/unity-agent-workflows"

mkdir -p "$TARGET"
rm -rf "$TARGET/SKILL.md" "$TARGET/references" "$TARGET/agents"
cp -R "$ROOT/SKILL.md" "$ROOT/references" "$ROOT/agents" "$TARGET/"

echo "synced $TARGET"
