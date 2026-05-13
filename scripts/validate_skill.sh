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
  "references/workflow-recipes.md"
  "references/modular-architecture.md"
  "references/runtime-owner-proof.md"
  "references/runtime-visible-targets.md"
  "references/target-bounds-catalog.md"
  "references/coordinate-space-conversion.md"
  "references/unity-validation.md"
  "references/ui-and-visual-assets.md"
  "references/content-and-systems.md"
  "references/cleanup-and-git.md"
  "references/session-mining.md"
  ".claude/skills/unity-agent-workflows/SKILL.md"
  ".claude/skills/unity-agent-workflows/agents/openai.yaml"
  ".claude/skills/unity-agent-workflows/references/ai-workflows.md"
  "plugins/unity-agent-workflows/skills/unity-agent-workflows/SKILL.md"
  "plugins/unity-agent-workflows/skills/unity-agent-workflows/references/ai-workflows.md"
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
diff -qr "$ROOT/SKILL.md" "$ROOT/skills/unity-agent-workflows/SKILL.md" >/dev/null
diff -qr "$ROOT/SKILL.md" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/SKILL.md" >/dev/null
diff -qr "$ROOT/references" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/references" >/dev/null

python3 - "$ROOT" "$ROOT/SKILL.md" "$ROOT/agents/openai.yaml" "$ROOT/package.json" <<'PY'
from pathlib import Path
import json
import re
import sys

root = Path(sys.argv[1])
skill_path = Path(sys.argv[2])
skill = skill_path.read_text(encoding="utf-8")
openai_yaml = Path(sys.argv[3]).read_text(encoding="utf-8")
package_json = json.loads(Path(sys.argv[4]).read_text(encoding="utf-8"))

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
reference_files = sorted(root.joinpath("references").glob("*.md"))
reference_names = {f.name for f in reference_files}

for text_file in [root / "SKILL.md", root / "README.md", root / "README.th.md", *reference_files]:
    text = text_file.read_text(encoding="utf-8")
    for ref in re.findall(r"references/[-a-z0-9]+\.md", text):
        if not (root / ref).exists():
            rel = text_file.relative_to(root)
            raise SystemExit(f"{rel} references missing file: {ref}")

skill_refs = {Path(ref).name for ref in re.findall(r"references/[-a-z0-9]+\.md", skill)}
missing_from_skill = reference_names - skill_refs
if missing_from_skill:
    missing = ", ".join(sorted(missing_from_skill))
    raise SystemExit(f"SKILL.md does not route references: {missing}")

print("skill validation ok")
PY
