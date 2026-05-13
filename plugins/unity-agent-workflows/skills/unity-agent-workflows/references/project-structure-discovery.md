# Project Structure Discovery

## Purpose

Use this before routing architecture, new files, new classes, cross-module calls, or broad Unity edits. The agent must learn only the relevant part of the user's actual project structure instead of forcing this skill's sample layout or scanning the whole repo by default.

The output is a focused structure map that can be written as a short `UNITY_STRUCTURE.md` index, split into focused files, or kept in task notes when the user does not want files added.

## Discovery Inputs

Read only what exists and only what the task needs:

- Always-read: `AGENTS.md`, relevant `README.md`/architecture docs, existing focused structure maps.
- UI/runtime bug: scene/prefab path, presenter/controller, Canvas/TMP/safe-area code.
- Gameplay feature: owning gameplay module, related data/config, event/contract path.
- Content/balance: ScriptableObjects/config/localization that own the values.
- Assembly/refactor: folders, namespaces, `.asmdef`, graph edges for touched modules.
- Cleanup: code refs, YAML/GUID refs, Resources/addressable paths.
- Graph reports only when routing or dependency proof depends on them: `graphify-out/GRAPH_REPORT.md`, `graphify-out/wiki/index.md`, `graph.json`, or equivalent.

Do not invent folders or layer names that are not visible in the repo.
Do not scan unrelated categories just to fill a template.

## Teach Command Contract

The short command is:

```text
$unity-agent-workflows. Teach
```

This means:

1. Create or refresh a short `UNITY_STRUCTURE.md` index.
2. Auto-split detailed structure into focused files by category.
3. Create a focused file only when the category is present, useful, or requested.
4. Never dump every folder, scene, graph node, or raw search result into one file.

Default files:

```text
UNITY_STRUCTURE.md
UNITY_STRUCTURE.ui.md
UNITY_STRUCTURE.gameplay.md
UNITY_STRUCTURE.content.md
UNITY_STRUCTURE.assemblies.md
UNITY_STRUCTURE.cleanup.md
```

Each focused file must include:

```text
When to read:
Primary paths:
Runtime/source owners:
Data/config owners:
Cross-module routes:
Validation hints:
Do-not-touch:
Open gaps:
```

## File Router

Use this router after Teach:

| Task | Read |
|---|---|
| UI, HUD, menu, safe area, TMP, visible target | `UNITY_STRUCTURE.md`, `UNITY_STRUCTURE.ui.md` |
| Gameplay behavior, enemies, stages, skills, missions | `UNITY_STRUCTURE.md`, `UNITY_STRUCTURE.gameplay.md` |
| Balance, localization, ScriptableObjects, config | `UNITY_STRUCTURE.md`, `UNITY_STRUCTURE.content.md` |
| New files, refactor, asmdef, namespace, dependency | `UNITY_STRUCTURE.md`, `UNITY_STRUCTURE.assemblies.md` |
| Deletion, cleanup, generated files, Resources/addressables | `UNITY_STRUCTURE.md`, `UNITY_STRUCTURE.cleanup.md` |

If a requested task spans multiple categories, read the index first, then the smallest set of focused maps needed.

## Structure Map

Capture this before structural edits:

```text
Project root:
Unity version/source:
Repo instructions:
Existing structure docs:
Scripts roots:
Observed module folders:
Observed namespaces:
Assemblies/asmdefs:
Scene roots:
Prefab roots:
Bootstrap/composition roots:
Content/data roots:
UI roots:
Asset/art roots:
Generated/cache/build-output roots:
Runtime owner patterns:
Cross-module communication patterns:
Validation commands found:
Do-not-touch areas:
Open uncertainty:
```

## Routing Rules

- Route to the repo's existing owner first.
- Match the repo's folder, namespace, assembly, scene, prefab, and content patterns.
- If the repo has no clear module structure, patch the proven owner in place and keep new code beside the closest live owner.
- If the repo has a modular structure, use the project's own module names and dependency direction.
- If docs disagree with live code, treat live code as source of truth and report the mismatch.
- If multiple owners are equally plausible and the choice changes runtime behavior, ask one focused question before editing.

## Optional Persistent Context

When the user wants a teach/document flow, keep the main file short:

```text
UNITY_STRUCTURE.md
```

Use it as an index plus links to focused maps when needed:

```text
Project Identity
Known Structure Maps
Do-Not-Touch Areas
Validation Notes
Open Gaps
```

Split larger notes by area:

```text
UNITY_STRUCTURE.ui.md
UNITY_STRUCTURE.gameplay.md
UNITY_STRUCTURE.content.md
UNITY_STRUCTURE.assemblies.md
UNITY_STRUCTURE.cleanup.md
```

Rules:

- Prefer focused maps over one huge file.
- Keep it descriptive, not prescriptive.
- Use exact paths from the repo.
- Mark inferred facts as inferred.
- Do not copy huge graphs or raw file dumps.
- Refresh only the stale area when structure changes meaningfully.

## Fallback Pattern

If a project has no structure docs and no obvious layering, use local ownership:

```text
new behavior -> beside the proven runtime owner
shared data -> beside the existing data/config path
shared contract -> smallest existing boundary or local interface near the caller
visual/UI -> beside the scene/prefab/presenter that owns the visible layer
```

Core/Systems/Features is only a sample pattern. Use it only when the repo already follows it or the user explicitly asks to migrate toward it.
