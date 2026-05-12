# Project Structure Discovery

## Purpose

Use this before routing architecture, new files, new classes, cross-module calls, or broad Unity edits. The agent must learn the user's actual project structure instead of forcing this skill's sample layout.

The output is a live structure map that can be written as `UNITY_STRUCTURE.md`, `PROJECT_STRUCTURE.md`, or kept in the task notes when the user does not want files added.

## Discovery Inputs

Read only what exists in the target repo:

- `AGENTS.md`, `README.md`, architecture docs, ADRs, package docs.
- `Assets/` top-level folders.
- `Assets/Scripts/` folders, namespaces, assembly names, `.asmdef` references.
- Scene and prefab ownership paths.
- Bootstrap/composition roots.
- Content/data paths: ScriptableObjects, configs, localization, addressables/resources.
- Graph reports: `graphify-out/GRAPH_REPORT.md`, `graphify-out/wiki/index.md`, `graph.json`, or equivalent.
- Existing generated maps such as `UNITY_STRUCTURE.md`, `PROJECT_STRUCTURE.md`, `DESIGN.md`, or project-local workflow docs.

Do not invent folders or layer names that are not visible in the repo.

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

When the user wants a teach/document flow, create or refresh a project context file:

```text
UNITY_STRUCTURE.md
```

Recommended sections:

```text
Project Identity
Source Layout
Assemblies And Dependencies
Scenes And Prefabs
Runtime Owners
UI And Presentation
Content And Data
Validation
Rules For Agents
Known Gaps
```

Rules:

- Keep it descriptive, not prescriptive.
- Use exact paths from the repo.
- Mark inferred facts as inferred.
- Do not copy huge graphs or raw file dumps.
- Refresh it when structure changes meaningfully.

## Fallback Pattern

If a project has no structure docs and no obvious layering, use local ownership:

```text
new behavior -> beside the proven runtime owner
shared data -> beside the existing data/config path
shared contract -> smallest existing boundary or local interface near the caller
visual/UI -> beside the scene/prefab/presenter that owns the visible layer
```

Core/Systems/Features is only a sample pattern. Use it only when the repo already follows it or the user explicitly asks to migrate toward it.
