---
name: unity-agent-workflows
description: Use for AI-assisted Unity game development when a task needs disciplined repo discovery, project-derived structure mapping, feature routing, runtime-owner proof, modular C# architecture, asmdef boundaries, UI/scene safety, visual asset gating, gameplay content/data-first decisions, validation, cleanup proof, or mining prior agent lessons into durable workflow rules. Best for Unity games where the agent must learn the user's actual folder/module/asmdef/scene structure before editing, plus runtime-built UI, mobile UX, generated assets, Graphify-style code graphs, or repeated "fix still not visible" failures.
---

# Unity Agent Workflows

Use this skill as the AI operating system for Unity game work. It turns project-specific lessons into a reusable workflow: read the live repo first, derive the user's actual project structure, prove the real runtime owner, route code to the existing owner/layer, avoid hub growth, validate the smallest useful surface, and publish durable rules only to the artifact that owns them.

## Start Here

1. Read the live project instructions first: `AGENTS.md`, `README.md`, architecture docs, or any repo-local agent file.
2. Check `git status --short` and preserve unrelated dirty files.
3. Derive the live project structure before architecture claims. Read existing folders, namespaces, `.asmdef` files, scenes/prefabs, bootstraps, graphs, and docs. Do not impose this skill's sample structure on the user's repo.
4. Inspect relevant files before editing. Do not start from memory or nearest-name guessing.
5. If a graph exists, read it before architecture claims: `graphify-out/GRAPH_REPORT.md`, `graphify-out/wiki/index.md`, `graph.json`, or equivalent.
6. Classify the task before touching files:
   - Runtime/visible bug -> prove owner chain.
   - Visible target alignment, interactive/visual target focus, spotlight, modal dimming, duplicate names, or "do not guess" -> runtime visible target lock.
   - New or expanded C# responsibility -> project-derived routing.
   - UI layout/readability -> UI workflow.
   - Visual source asset -> visual asset gate.
   - Gameplay tuning/content -> data-first content workflow.
   - Compile/runtime doubt -> validation workflow.
   - Cleanup/deletion -> cleanup proof.
   - Rule/session mining -> durable-rule workflow.
7. Edit the smallest safe file set.
8. Close with changed files, validation, scope boundary, and residual risk.

## Reference Map

Load only the reference needed for the current task.

- `references/ai-workflows.md`: Routing Card, universal workflow, task recipes, closeout shape.
- `references/project-structure-discovery.md`: how to learn the user's actual Unity structure and create/read `UNITY_STRUCTURE.md` style context.
- `references/modular-architecture.md`: project-derived layering, dependency rules, asmdef rules, hub gates; Core/Contracts/Systems/Features is only a fallback example.
- `references/runtime-owner-proof.md`: Visible object proof chain, runtime visible target lock, repeated-fix diagnostics, scene/prefab/runtime override tracing.
- `references/unity-validation.md`: `git diff --check`, Unity/Bee/Roslyn checks, stale response files, validation ladder.
- `references/ui-and-visual-assets.md`: mobile UI, safe area, localized text, source asset/Pixellab-style gates.
- `references/content-and-systems.md`: data-first content, stage systems, production-readiness system stack.
- `references/cleanup-and-git.md`: source-vs-generated artifacts, deletion proof, commit/push hygiene.
- `references/session-mining.md`: how to mine prior AI sessions into reusable rules without copying raw chat.

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

For new files, moved files, new classes, changed module placement, expanded responsibility, architecture updates, or hub deflation, write this card for yourself before editing. If you cannot fill it, inspect more.

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
Architecture docs sync needed? yes/no
Hub risk: low / medium / stop
Graph source used:
God Node status:
Edge count:
Largest touched .cs line count:
Over-500 gate:
Visual source asset required? yes/no
Validation plan:
Files allowed to touch:
Files explicitly not touched:
```

## Task Router

- **Narrow bug fix**: read the call path, patch the true owner, validate, report owner chain.
- **Repeated "still wrong" visible fix**: read `references/runtime-owner-proof.md`; search alternate owner paths before changing more values.
- **Visible target lock**: read `references/runtime-owner-proof.md`; use it for any visible UI/gameplay target such as buttons, icons, cards, chips, panels, HUD slots, tooltips, markers, colliders, units, props, VFX targets, highlight, spotlight, modal dimming, duplicate object names, "do not guess", or "do not edit yet" requests.
- **New gameplay feature**: read `references/project-structure-discovery.md`, then `references/modular-architecture.md` and `references/content-and-systems.md`; prefer the repo's existing owner/content path and focused collaborators.
- **Cross-module communication**: use contracts/events/gateways. Do not import one feature module from another.
- **Hub deflation/refactor**: read `references/modular-architecture.md`; prove a callsite, edge, responsibility, or asmdef boundary changed.
- **UI or screenshot work**: read `references/ui-and-visual-assets.md` and `references/runtime-owner-proof.md`.
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
- Largest touched `.cs` files and over-500 status when C# responsibility changed.
- Graph/God Node/edge-gate status when architecture changed and graph data exists.
- Visual asset tool used: yes/no plus reason.
- Residual risk if Play mode, Game view, device, batchmode, or graph refresh was not run.
