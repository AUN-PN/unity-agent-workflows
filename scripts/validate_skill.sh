#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

required=(
  "SKILL.md"
  "LICENSE"
  "SECURITY.md"
  ".codexignore"
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
  "plugins/unity-agent-workflows/LICENSE"
  "plugins/unity-agent-workflows/SECURITY.md"
  "plugins/unity-agent-workflows/.codexignore"
  "plugins/unity-agent-workflows/README.md"
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

check_diff() {
  local left="$1"
  local right="$2"
  if ! diff -qr "$left" "$right" >/dev/null; then
    echo "mirror drift: $left != $right" >&2
    diff -qr "$left" "$right" >&2 || true
    exit 1
  fi
}

check_diff "$ROOT/SKILL.md" "$ROOT/.claude/skills/unity-agent-workflows/SKILL.md"
check_diff "$ROOT/agents" "$ROOT/.claude/skills/unity-agent-workflows/agents"
check_diff "$ROOT/references" "$ROOT/.claude/skills/unity-agent-workflows/references"
check_diff "$ROOT/SKILL.md" "$ROOT/skills/unity-agent-workflows/SKILL.md"
check_diff "$ROOT/agents" "$ROOT/skills/unity-agent-workflows/agents"
check_diff "$ROOT/references" "$ROOT/skills/unity-agent-workflows/references"
check_diff "$ROOT/.codex-plugin" "$ROOT/plugins/unity-agent-workflows/.codex-plugin"
check_diff "$ROOT/assets" "$ROOT/plugins/unity-agent-workflows/assets"
check_diff "$ROOT/SKILL.md" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/SKILL.md"
check_diff "$ROOT/agents" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/agents"
check_diff "$ROOT/references" "$ROOT/plugins/unity-agent-workflows/skills/unity-agent-workflows/references"

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
require(frontmatter_values.get("license") == "MIT", "SKILL.md license must be MIT")
if "TODO" in skill:
    raise SystemExit("SKILL.md still contains TODO")
require("Use $unity-agent-workflows" in openai_yaml, "agents/openai.yaml default_prompt missing skill invocation")
require("allow_implicit_invocation: true" in openai_yaml, "agents/openai.yaml must allow implicit invocation")
for phrase in (
    "Unity 2D",
    "multi-agent scope",
    "runtime numeric proof",
    "visible-output/state failures",
):
    require(phrase in openai_yaml, f"agents/openai.yaml missing trigger phrase: {phrase}")
for phrase in (
    "runtime-visible output",
    "runtime numeric proof",
    "state-step guards",
    "multi-agent scope ownership",
    "overlay/dim source-bound mistakes",
    "guided equipment/shop flows",
):
    require(phrase in skill, f"SKILL.md missing trigger phrase: {phrase}")
for readme_rel in ("README.md", "README.th.md"):
    readme = (root / readme_rel).read_text(encoding="utf-8")
    old_heading = "Architecture" + " Overview"
    require(old_heading not in readme, f"{readme_rel} must use workflow steps, not the old architecture heading")
    for phrase in (
        "```mermaid",
        "flowchart TD",
        "User input",
        "Skill trigger",
        "Read context",
        "Classify task",
        "Load required references",
        "Proof complete?",
        "Inspect deeper / probe runtime",
        "Lock scope",
        "Patch smallest safe set",
        "Validation pass?",
        "Fix validation issue",
        "Close out",
        "overlay/dim source-bound",
        "guided state-flow",
        "multi-agent scope",
    ):
        require(phrase in readme, f"{readme_rel} missing workflow step phrase: {phrase}")
require("runtime numeric proof" in skill, "SKILL.md missing runtime numeric proof trigger")
require("repeated visible-output" in skill, "SKILL.md missing repeated visible-output trigger")
require("runtime numeric proof" in openai_yaml, "agents/openai.yaml missing runtime numeric proof invocation")
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
    require(
        "runtime numeric proof" in manifest.get("description", "")
        or "runtime numeric proof" in interface.get("longDescription", "")
        or any("runtime numeric proof" in prompt for prompt in default_prompts),
        f"{manifest_rel} missing runtime numeric proof trigger copy",
    )
    manifest_text = json.dumps(manifest, ensure_ascii=False)
    for phrase in (
        "Unity 2D",
        "runtime-owner proof",
        "runtime numeric proof",
        "overlay/dim source-bound",
        "guided state-step guards",
        "multi-agent scope ownership",
    ):
        require(phrase in manifest_text, f"{manifest_rel} missing trigger phrase: {phrase}")
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
required_eval_ids = {
    "runtime-visible-output-conversion",
    "repeated-visible-numeric-proof",
    "checker-fails-missing-runtime-values",
    "overlay-dim-source-bound-mistake",
    "multi-agent-scope-before-patch",
    "guided-equipment-state-flow",
}
for case in cases:
    for key in ("id", "prompt", "expected_skill", "expectation"):
        require(key in case, f"eval case missing {key}")
    require(case["id"] not in seen_ids, f"duplicate eval case id: {case['id']}")
    seen_ids.add(case["id"])
missing_eval_ids = required_eval_ids - seen_ids
require(not missing_eval_ids, f"evals missing numeric visible-output cases: {', '.join(sorted(missing_eval_ids))}")
eval_text = json.dumps(evals, ensure_ascii=False)
for phrase in ("runtime numeric", "still in the wrong place", "source bounds", "converted rect", "final drawn rect", "overlay", "multi-agent", "guided equipment"):
    require(phrase in eval_text, f"evals missing trigger phrase: {phrase}")

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

required_reference_phrases = {
    "references/runtime-owner-proof.md": "Runtime Numeric Proof Gate",
    "references/runtime-visible-targets.md": "Overlay/Dim/Mask/Blocker Source Bounds",
    "references/coordinate-space-conversion.md": "Cross-Canvas/Root Focus And Spotlight",
    "references/unity-validation.md": "runtime numeric proof",
    "references/ui-and-visual-assets.md": "runtime numeric proof",
    "references/workflow-recipes.md": "WF-6R Repeated Visible Mismatch",
    "references/content-and-systems.md": "Guided Flow State Proof",
}
for rel, phrase in required_reference_phrases.items():
    text = (root / rel).read_text(encoding="utf-8")
    require(phrase in text, f"{rel} missing required phrase: {phrase}")

extra_reference_phrases = {
    "references/runtime-visible-targets.md": (
        "Runtime Numeric Target Report",
        "Cross-Canvas/Root Focus Proof",
        "overlay/dim/mask/blocker output rects as source bounds",
    ),
    "references/coordinate-space-conversion.md": (
        "Required runtime numeric proof",
        "Overlay, dim, mask, blocker, scrim, spotlight, and hole objects are destination/output surfaces.",
    ),
    "references/unity-validation.md": (
        "Visible Output Checker Failures",
        "overlay/dim/mask/blocker output rects are used as source bounds",
    ),
    "references/workflow-recipes.md": (
        "WF-12 Multi-Agent Visible Or State Work",
        "state-step proof treats screen open/click/analytics as domain completion",
    ),
}
for rel, phrases in extra_reference_phrases.items():
    text = (root / rel).read_text(encoding="utf-8")
    for phrase in phrases:
        require(phrase in text, f"{rel} missing required phrase: {phrase}")

print("skill validation ok")
PY
