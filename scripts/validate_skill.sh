#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

required=(
  "SKILL.md"
  "README.md"
  "package.json"
  ".agents/plugins/marketplace.json"
  ".codex-plugin/plugin.json"
  "agents/openai.yaml"
  "assets/unity-workflows.png"
  "bin/unity-agent-workflows.js"
  "evals/skill-trigger-cases.json"
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
  "plugins/unity-agent-workflows/.codex-plugin/plugin.json"
  "plugins/unity-agent-workflows/assets/unity-workflows.png"
  "skills/unity-agent-workflows/agents/openai.yaml"
  "skills/unity-agent-workflows/references/ai-workflows.md"
  "plugins/unity-agent-workflows/skills/unity-agent-workflows/SKILL.md"
  "plugins/unity-agent-workflows/skills/unity-agent-workflows/agents/openai.yaml"
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
diff -qr "$ROOT/agents" "$ROOT/skills/unity-agent-workflows/agents" >/dev/null
diff -qr "$ROOT/references" "$ROOT/skills/unity-agent-workflows/references" >/dev/null
diff -qr "$ROOT/.codex-plugin" "$ROOT/plugins/unity-agent-workflows/.codex-plugin" >/dev/null
diff -qr "$ROOT/assets" "$ROOT/plugins/unity-agent-workflows/assets" >/dev/null
diff -qr "$ROOT/SKILL.md" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/SKILL.md" >/dev/null
diff -qr "$ROOT/agents" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/agents" >/dev/null
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

def load_json(rel):
    return json.loads((root / rel).read_text(encoding="utf-8"))

def require(condition, message):
    if not condition:
        raise SystemExit(message)

def require_rel_path(owner_rel, value):
    require(isinstance(value, str) and value.startswith("./"), f"{owner_rel} path must be relative and start with ./")
    owner_dir = (root / owner_rel).parent
    plugin_root = owner_dir.parent if owner_dir.name == ".codex-plugin" else owner_dir
    target = (plugin_root / value).resolve()
    require(str(target).startswith(str(plugin_root.resolve())), f"{owner_rel} path escapes plugin root: {value}")
    require(target.exists(), f"{owner_rel} path missing: {value}")

require(skill.startswith("---\n"), "SKILL.md missing frontmatter")
parts = skill.split("---", 2)
require(len(parts) >= 3, "SKILL.md frontmatter not closed")
frontmatter = parts[1].strip().splitlines()
frontmatter_values = {}
for line in frontmatter:
    if ":" in line:
        key, value = line.split(":", 1)
        frontmatter_values[key.strip()] = value.strip()
require(frontmatter_values.get("name") == "unity-agent-workflows", "SKILL.md name must be unity-agent-workflows")
require(frontmatter_values.get("description"), "SKILL.md description must be non-empty")
if "TODO" in skill:
    raise SystemExit("SKILL.md still contains TODO")
require("Use $unity-agent-workflows" in openai_yaml, "agents/openai.yaml default_prompt missing skill invocation")
require(package_json.get("name") == "unity-agent-workflows", "package.json name must be unity-agent-workflows")
package_version = package_json.get("version")
require(re.fullmatch(r"\d+\.\d+\.\d+", str(package_version or "")), "package.json version must be semver x.y.z")
require(package_json.get("bin", {}).get("unity-agent-workflows") == "bin/unity-agent-workflows.js", "package.json bin missing unity-agent-workflows")
for file in (".agents", ".codex-plugin", "assets", "plugins", "SKILL.md", "skills", "README.md", "README.th.md", "agents", "evals", "references", "scripts", "bin"):
    require(file in package_json.get("files", []), f"package.json files missing {file}")

marketplace = load_json(".agents/plugins/marketplace.json")
require(marketplace.get("name") == "unity-agent-workflows", "marketplace name must be unity-agent-workflows")
require(marketplace.get("interface", {}).get("displayName") == "Unity Workflows", "marketplace displayName must be Unity Workflows")
plugins = marketplace.get("plugins")
require(isinstance(plugins, list) and len(plugins) == 1, "marketplace must list exactly one plugin")
entry = plugins[0]
require(entry.get("name") == "unity-agent-workflows", "marketplace plugin name mismatch")
require(entry.get("source") == {"source": "local", "path": "./plugins/unity-agent-workflows"}, "marketplace source must point to ./plugins/unity-agent-workflows")
require(entry.get("policy", {}).get("installation") in {"AVAILABLE", "INSTALLED_BY_DEFAULT", "NOT_AVAILABLE"}, "marketplace policy.installation invalid")
require(entry.get("policy", {}).get("authentication") in {"ON_INSTALL", "ON_USE"}, "marketplace policy.authentication invalid")
require(entry.get("category") == "Coding", "marketplace category must be Coding")

for manifest_rel in (".codex-plugin/plugin.json", "plugins/unity-agent-workflows/.codex-plugin/plugin.json"):
    manifest = load_json(manifest_rel)
    require(manifest.get("name") == "unity-agent-workflows", f"{manifest_rel} name mismatch")
    require(manifest.get("version") == package_version, f"{manifest_rel} version must match package.json")
    require(manifest.get("skills") == "./skills/", f"{manifest_rel} skills must be ./skills/")
    interface = manifest.get("interface", {})
    require(interface.get("displayName") == "Unity Workflows", f"{manifest_rel} interface.displayName mismatch")
    require(interface.get("category") == "Coding", f"{manifest_rel} interface.category must be Coding")
    default_prompts = interface.get("defaultPrompt")
    require(isinstance(default_prompts, list) and 1 <= len(default_prompts) <= 3, f"{manifest_rel} defaultPrompt must contain 1-3 prompts")
    require(any("$unity-agent-workflows" in prompt for prompt in default_prompts), f"{manifest_rel} defaultPrompt must mention $unity-agent-workflows")
    for prompt in default_prompts:
        require(isinstance(prompt, str) and len(prompt) <= 128, f"{manifest_rel} defaultPrompt entry too long")
    for asset_key in ("composerIcon", "logo"):
        require_rel_path(manifest_rel, interface.get(asset_key))

evals = load_json("evals/skill-trigger-cases.json")
require(evals.get("skill") == "unity-agent-workflows", "evals skill mismatch")
cases = evals.get("cases")
require(isinstance(cases, list) and len(cases) >= 6, "evals must include at least 6 cases")
require(any(case.get("expected_skill") is True for case in cases), "evals missing positive cases")
require(any(case.get("expected_skill") is False for case in cases), "evals missing negative cases")
seen_ids = set()
for case in cases:
    for key in ("id", "prompt", "expected_skill", "expectation"):
        require(key in case, f"eval case missing {key}")
    require(case["id"] not in seen_ids, f"duplicate eval case id: {case['id']}")
    seen_ids.add(case["id"])

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
