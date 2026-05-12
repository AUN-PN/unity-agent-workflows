#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

required=(
  "SKILL.md"
  "agents/openai.yaml"
  "references/ai-workflows.md"
  "references/modular-architecture.md"
  "references/runtime-owner-proof.md"
  "references/unity-validation.md"
  "references/ui-and-visual-assets.md"
  "references/content-and-systems.md"
  "references/cleanup-and-git.md"
  "references/session-mining.md"
)

for file in "${required[@]}"; do
  if [[ ! -f "$ROOT/$file" ]]; then
    echo "missing $file" >&2
    exit 1
  fi
done

python3 - "$ROOT/SKILL.md" "$ROOT/agents/openai.yaml" <<'PY'
from pathlib import Path
import re
import sys

skill = Path(sys.argv[1]).read_text(encoding="utf-8")
openai_yaml = Path(sys.argv[2]).read_text(encoding="utf-8")

if not skill.startswith("---\n"):
    raise SystemExit("SKILL.md missing frontmatter")
frontmatter = skill.split("---", 2)[1]
for key in ("name:", "description:"):
    if key not in frontmatter:
        raise SystemExit(f"SKILL.md missing {key}")
if "TODO" in skill:
    raise SystemExit("SKILL.md still contains TODO")
if "Use $unity-game-ai-workflows" not in openai_yaml:
    raise SystemExit("agents/openai.yaml default_prompt missing skill invocation")
for ref in re.findall(r"references/[-a-z0-9]+\\.md", skill):
    if not (Path(sys.argv[1]).parent / ref).exists():
        raise SystemExit(f"referenced file missing: {ref}")
print("skill validation ok")
PY
