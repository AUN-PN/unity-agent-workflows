#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

required=(
  "SKILL.md"
  "README.md"
  "package.json"
  "agents/openai.yaml"
  "bin/unity-agent-workflows.js"
  "references/ai-workflows.md"
  "references/modular-architecture.md"
  "references/runtime-owner-proof.md"
  "references/unity-validation.md"
  "references/ui-and-visual-assets.md"
  "references/content-and-systems.md"
  "references/cleanup-and-git.md"
  "references/session-mining.md"
  ".claude/skills/unity-agent-workflows/SKILL.md"
  ".claude/skills/unity-agent-workflows/agents/openai.yaml"
  ".claude/skills/unity-agent-workflows/references/ai-workflows.md"
)

for file in "${required[@]}"; do
  if [[ ! -f "$ROOT/$file" ]]; then
    echo "missing $file" >&2
    exit 1
  fi
done

node --check "$ROOT/bin/unity-agent-workflows.js" >/dev/null
diff -qr "$ROOT/SKILL.md" "$ROOT/.claude/skills/unity-agent-workflows/SKILL.md" >/dev/null
diff -qr "$ROOT/agents" "$ROOT/.claude/skills/unity-agent-workflows/agents" >/dev/null
diff -qr "$ROOT/references" "$ROOT/.claude/skills/unity-agent-workflows/references" >/dev/null

python3 - "$ROOT/SKILL.md" "$ROOT/agents/openai.yaml" "$ROOT/package.json" <<'PY'
from pathlib import Path
import json
import re
import sys

skill = Path(sys.argv[1]).read_text(encoding="utf-8")
openai_yaml = Path(sys.argv[2]).read_text(encoding="utf-8")
package_json = json.loads(Path(sys.argv[3]).read_text(encoding="utf-8"))

if not skill.startswith("---\n"):
    raise SystemExit("SKILL.md missing frontmatter")
frontmatter = skill.split("---", 2)[1]
for key in ("name:", "description:"):
    if key not in frontmatter:
        raise SystemExit(f"SKILL.md missing {key}")
if "TODO" in skill:
    raise SystemExit("SKILL.md still contains TODO")
if "Use $unity-agent-workflows" not in openai_yaml:
    raise SystemExit("agents/openai.yaml default_prompt missing skill invocation")
if package_json.get("name") != "unity-agent-workflows":
    raise SystemExit("package.json name must be unity-agent-workflows")
if package_json.get("bin", {}).get("unity-agent-workflows") != "bin/unity-agent-workflows.js":
    raise SystemExit("package.json bin missing unity-agent-workflows")
for file in ("SKILL.md", "agents", "references", "scripts", "bin"):
    if file not in package_json.get("files", []):
        raise SystemExit(f"package.json files missing {file}")
for ref in re.findall(r"references/[-a-z0-9]+\\.md", skill):
    if not (Path(sys.argv[1]).parent / ref).exists():
        raise SystemExit(f"referenced file missing: {ref}")
print("skill validation ok")
PY
