---
name: unity-agent-workflows
description: Use for AI-assisted Unity game development when a task needs disciplined repo discovery, feature routing, runtime-owner proof, modular C# architecture, asmdef boundaries, UI/scene safety, visual asset gating, gameplay content/data-first decisions, validation, cleanup proof, or mining prior agent lessons into durable workflow rules. Best for Unity games with Core/Systems/Features-style structure, runtime-built UI, mobile UX, generated assets, Graphify-style code graphs, or repeated "fix still not visible" failures.
---

# Unity Agent Workflows

Use this skill as the AI operating system for Unity game work. It turns project-specific lessons into a reusable workflow: read the live repo first, prove the real runtime owner, route code to the right layer, avoid hub growth, validate the smallest useful surface, and publish durable rules only to the artifact that owns them.

## Start Here

1. Read the live project instructions first: `AGENTS.md`, `README.md`, architecture docs, or any repo-local agent file.
2. Check `git status --short` and preserve unrelated dirty files.
3. Inspect relevant files before editing. Do not start from memory or nearest-name guessing.
4. If a graph exists, read it before architecture claims: `graphify-out/GRAPH_REPORT.md`, `graphify-out/wiki/index.md`, `graph.json`, or equivalent.
5. Classify the task before touching files:
   - Runtime/visible bug -> prove owner chain.
   - New or expanded C# responsibility -> modular routing.
   - UI layout/readability -> UI workflow.
   - Visual source asset -> visual asset gate.
   - Gameplay tuning/content -> data-first content workflow.
   - Compile/runtime doubt -> validation workflow.
   - Cleanup/deletion -> cleanup proof.
   - Rule/session mining -> durable-rule workflow.
6. Edit the smallest safe file set.
7. Close with changed files, validation, scope boundary, and residual risk.

## Reference Map

Load only the reference needed for the current task.

- `references/ai-workflows.md`: Routing Card, universal workflow, task recipes, closeout shape.
- `references/modular-architecture.md`: Core/Contracts/Systems/Features layering, asmdef rules, hub gates.
- `references/runtime-owner-proof.md`: Visible object proof chain, repeated-fix diagnostics, scene/prefab/runtime override tracing.
- `references/unity-validation.md`: `git diff --check`, Unity/Bee/Roslyn checks, stale response files, validation ladder.
- `references/ui-and-visual-assets.md`: mobile UI, safe area, localized text, source asset/Pixellab-style gates.
- `references/content-and-systems.md`: data-first content, stage systems, production-readiness system stack.
- `references/cleanup-and-git.md`: source-vs-generated artifacts, deletion proof, commit/push hygiene.
- `references/session-mining.md`: how to mine prior AI sessions into reusable rules without copying raw chat.

## Hard Rules

- No proof, no edit. For visible/runtime changes, prove the owner chain first.
- Do not grow a hub when a focused collaborator, data object, contract, event, bridge, or service can own the new responsibility.
- Do not add direct sibling feature references. Route cross-feature facts through contracts, events, gateways, or bridges.
- Do not add new scripts to legacy broad folders if the repo already has a modular layout.
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
Placement layer: Core / Contract / System / Feature / Content / Scene-Prefab / Asset
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
- **New gameplay feature**: read `references/modular-architecture.md` and `references/content-and-systems.md`; prefer data-first content or focused collaborators.
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
