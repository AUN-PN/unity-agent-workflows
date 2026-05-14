---
name: unity-agent-workflows
description: Use for AI-assisted Unity work that needs live repo discovery, project-derived routing, runtime-owner proof, modular C#/asmdef safety, UI/scene/visual asset gates, data-first content changes, validation, cleanup proof, or durable workflow rules. Best when agents must prove the actual folder/module/scene/prefab/runtime owner before editing, especially runtime UI, generated assets, code graphs, or repeated "fix still not visible" failures.
---

# Unity Agent Workflows

Use this skill as the AI operating system for Unity work: read the live repo, derive structure, prove runtime ownership, route to the existing owner/layer, avoid hub growth, validate the smallest useful surface, and publish rules only to the artifact that owns them.

## Start Here

1. Treat this injected `SKILL.md` body as authoritative. Do not search for this skill's own `SKILL.md` again unless the file body is missing or the user explicitly asks for path diagnostics.
2. Read the live project instructions first: `AGENTS.md`, `README.md`, architecture docs, or any repo-local agent file.
3. Check `git status --short` and preserve unrelated dirty files.
4. If the user says `$unity-agent-workflows. Teach`, run the Teach command directly: create/refresh `UNITY_STRUCTURE.md` as a short index and split focused maps by category. Do not search for the skill path first. Do not make one huge all-project document.
5. Derive only relevant live structure before architecture claims: folders, namespaces, `.asmdef` files, scenes/prefabs, bootstraps, graphs, and docs. Do not impose this skill's sample structure.
6. Inspect relevant files before editing. Do not start from memory or nearest-name guessing.
7. If a code graph exists, read it before architecture claims only when dependency/routing proof needs graph data: graph report, graph wiki, `graph.json`, or equivalent.
8. Classify the task before touching files:
   - Runtime/visible bug -> prove owner chain.
   - Visible target alignment, interactive/visual target focus, spotlight, modal dimming, duplicate names, hardcoded layout/position, or "do not guess" -> runtime visible target lock.
   - New or expanded C# responsibility -> project-derived routing.
   - UI layout/readability -> UI workflow.
   - Visual source asset -> visual asset gate.
   - Gameplay tuning/content -> data-first content workflow.
   - Compile/runtime doubt -> validation workflow.
   - Cleanup/deletion -> cleanup proof.
   - Rule/session mining -> durable-rule workflow.
9. Before editing, load the task's required references, not only this `SKILL.md`. UI/screenshot/visible-target work must load `references/ui-and-visual-assets.md`, `references/runtime-owner-proof.md`, and `references/unity-validation.md`.
10. If a required reference is missing or inaccessible, stop broad edits, use only rules already visible in this `SKILL.md`, and report the missing reference in closeout.
11. Edit the smallest safe file set.
12. Close with changed files, validation, scope boundary, references loaded, and residual risk.

## Local Skill Path Rules

For reference files, resolve paths relative to this skill directory:

```text
references/runtime-owner-proof.md
references/unity-validation.md
references/ui-and-visual-assets.md
```

If a reference is missing, continue with this `SKILL.md` only and report it in closeout. Do not do broad path discovery unless debugging installation.

## Teach Command

When the user writes only `$unity-agent-workflows. Teach`, create or refresh a short `UNITY_STRUCTURE.md` index plus focused maps only for categories that exist or are needed:

```text
UNITY_STRUCTURE.ui.md
UNITY_STRUCTURE.runtime.md
UNITY_STRUCTURE.content.md
UNITY_STRUCTURE.assemblies.md
UNITY_STRUCTURE.cleanup.md
```

Read `references/project-structure-discovery.md` for the full Teach contract. Do not scan unrelated categories just to fill every file.

## Structure Map File Router

When a later task starts, read `UNITY_STRUCTURE.md` plus the matching focused map only. Load all focused maps only for broad all-project audits or explicit all-category requests. If the needed map is missing, refresh only that map; if refresh is not possible, use live inspection and report the gap.

## Reference Map

Load only the reference needed for the current task.

- `references/ai-workflows.md`: Routing Card, universal workflow, closeout shape; loads `references/workflow-recipes.md` only when named recipes are needed.
- `references/project-structure-discovery.md`: how to learn the user's actual Unity structure and create/read `UNITY_STRUCTURE.md` project context.
- `references/modular-architecture.md`: project-derived layering, dependency rules, asmdef rules, hub gates; Core/Contracts/Systems/Features is only a fallback example.
- `references/runtime-owner-proof.md`: Visible object proof chain, runtime visible target lock, repeated-fix diagnostics, and routing to deeper target files.
- `references/runtime-visible-targets.md`: focus/highlight/click target rules, marker/visual/interactive rect choice, hardcoded fallback contract.
- `references/target-bounds-catalog.md`: object-type bounds choices for UI controls, HUD, world units, projectiles, VFX, safe area, and TMP labels.
- `references/coordinate-space-conversion.md`: world/local/screen/viewport/canvas/camera/safe-area/RenderTexture conversion rules.
- `references/unity-validation.md`: `git diff --check`, Unity/Bee/Roslyn checks, stale response files, validation ladder.
- `references/ui-and-visual-assets.md`: UI, safe area, localized text, and project-approved source asset gates.
- `references/content-and-systems.md`: data-first content, runtime systems, production-readiness system stack.
- `references/cleanup-and-git.md`: source-vs-generated artifacts, deletion proof, commit/push hygiene.
- `references/session-mining.md`: how to mine prior AI sessions into reusable rules without copying raw chat.

## Required Reference Gate

Before editing, load the matching reference files below. This prevents the failure mode where the agent reads only `SKILL.md` and skips the detailed workflow.

| Task trigger | Required references before editing |
|---|---|
| UI, screenshot, HUD, menu, safe area, TMP, visible target, focus, highlight, spotlight, modal dimming | `references/ui-and-visual-assets.md`, `references/runtime-owner-proof.md`, `references/unity-validation.md` |
| Runtime-visible bug, repeated "still wrong", duplicate object names, real object/position request | `references/runtime-owner-proof.md`, `references/unity-validation.md` |
| New files/classes, moved scripts, asmdef/module routing, dependency direction, hub deflation/refactor | `references/project-structure-discovery.md`, `references/modular-architecture.md`, `references/ai-workflows.md` |
| New runtime feature, content, progression, levels, economy, objective/data-first work | `references/project-structure-discovery.md`, `references/content-and-systems.md`, `references/ai-workflows.md` |
| Compile error, validation repair, stale Bee/Roslyn response files, Play Mode proof | `references/unity-validation.md` |
| Cleanup/deletion/generated files/git hygiene | `references/cleanup-and-git.md` |
| Rule/session mining/workflow update | `references/session-mining.md` |

After loading a required reference, follow its own `Read`/`Load Extra Detail` table instead of preloading every linked file.

Closeout must include `References loaded:` with the exact reference filenames, or `References missing:` with the filename and how the task was safely narrowed.

Closeout must also include `Project maps loaded:` with the exact `UNITY_STRUCTURE*` filenames, or `Project maps missing:` with the filename and live-inspection fallback used.

## Hard Rules

- No proof, no edit. For visible/runtime changes, prove the owner chain first.
- No fixed structure. Derive module names, layers, folders, namespaces, assemblies, bootstraps, and scene/prefab ownership from the user's project before routing new work.
- No guessed targeting. If the user asks to bind, focus, highlight, click, or align a visible object, resolve the real runtime object and coordinate space before editing.
- Do not grow a hub when a focused collaborator, data object, contract, event, bridge, or service can own the new responsibility.
- Do not add direct sibling feature references. Route cross-feature facts through contracts, events, gateways, or bridges.
- Do not add new scripts to broad folders when the repo already exposes a more specific owner, module, assembly, feature folder, scene owner, or content definition path.
- Do not treat scene YAML, prefab scale, or a searched constant as runtime truth until startup/layout/animation writers are checked.
- Do not mix source refactors with cache cleanup, generated build output, or unrelated scene/prefab churn.
- Visual source asset creation/replacement happens before integration code. If the required generator/tool is unavailable, stop and report the limitation instead of silently substituting another generator.
- Compact answers are fine, but never compress away exact paths, class names, object names, commands, errors, validation results, or rollback notes.

## Routing Card

For new files, moved files, new classes, changed module placement, expanded responsibility, architecture updates, or hub deflation, fill the useful parts of this card before editing. If a field is unknown and relevant, inspect more.

```text
Task type:
Structural trigger:
Runtime-visible target:
Current owner file(s):
Project structure source: live scan / docs / graph / UNITY_STRUCTURE.md / mixed
Placement layer/category from repo:
Module/system name:
Data/definition source:
Runtime source-of-truth values:
Coordinate/rendering space checked: yes/no
New responsibility added? yes/no
Cross-module communication needed? yes/no
Hub risk: low / medium / stop
Visual source asset required? yes/no
Validation plan:
Files allowed to touch:
Files explicitly not touched:
```

Add graph, God Node, edge count, over-500 status, and architecture-doc sync only when architecture or C# responsibility changed and graph/source data exists.

## Task Router

- **Narrow bug fix**: read the call path, patch the true owner, validate, report owner chain.
- **Repeated "still wrong" visible fix**: read `references/runtime-owner-proof.md`; search alternate owner paths before changing more values.
- **Visible target lock**: read `references/runtime-owner-proof.md`; then load `references/runtime-visible-targets.md`, `references/target-bounds-catalog.md`, or `references/coordinate-space-conversion.md` only when its trigger matches.
- **New runtime/content feature**: read `references/project-structure-discovery.md`, then `references/modular-architecture.md` and `references/content-and-systems.md`; prefer the repo's existing owner/content path and focused collaborators.
- **Cross-module communication**: use contracts/events/gateways. Do not import one feature module from another.
- **Hub deflation/refactor**: read `references/modular-architecture.md`; prove a callsite, edge, responsibility, or asmdef boundary changed.
- **UI or screenshot work**: read `references/ui-and-visual-assets.md`, `references/runtime-owner-proof.md`, and `references/unity-validation.md` before editing. Report those references as loaded in closeout.
- **Visual asset work**: read `references/ui-and-visual-assets.md`; generate/approve the source asset before Unity integration.
- **Compile or validation repair**: read `references/unity-validation.md`; capture exact errors and rerun the same check after fixing.
- **Cleanup/deletion**: read `references/cleanup-and-git.md`; prove unused status through code refs, YAML GUID refs, resources paths, and runtime reachability.
- **Rule or workflow update**: read `references/session-mining.md`; patch only the owning artifact.

## Closeout

Report compactly:

- Changed files.
- Non-requested systems touched: yes/no.
- Runtime-owner or structural proof.
- Validation command and result.
- References loaded/missing and project maps loaded/missing.
- Residual risk.

Add only when relevant:

- Largest touched `.cs` files and over-500 status for C# responsibility changes.
- Graph/God Node/edge-gate status for architecture changes when graph data exists.
- Visual asset tool used plus reason for visual source asset work.
- Play Mode, Game view, device, batchmode, or graph refresh gaps when those validations were needed but skipped.
