# Unity Agent Workflows

A practical skill for using AI agents on Unity game projects without letting them guess their way through the codebase.

I made this after running into the same Unity-agent problems over and over: the agent edits the nearby script instead of the runtime owner, changes prefab or scene values that get overwritten in Play mode, grows one more huge controller, or says "validated" without proving the path that actually runs.

This skill is the set of guardrails I wish every Unity coding agent had loaded before touching a game project.

## What It Helps With

Use it when an agent is working on Unity game code and the task needs more discipline than "grep a name and patch the first match."

It is especially useful for:

- runtime-visible bugs where the edited value might not be the value the player sees
- UI fixes that depend on parent hierarchy, anchors, safe area, CanvasScaler, or TMP refresh paths
- modular C# work where new responsibility needs the right folder, namespace, and dependency direction
- gameplay content changes that should go through data/config instead of hardcoded one-offs
- cleanup work where deleted files need real reference proof
- repeated "still not fixed" passes where the agent needs to stop changing random constants

The main rule is simple:

```text
No proof, no edit.
```

For visible Unity behavior, proof means tracing the owner chain:

```text
visible object -> scene/prefab/reference -> script/component -> mutating method -> serialized/runtime override
```

If that chain is missing, the agent has not earned the patch yet.

## Mindmap

This is the mental model I use when deciding whether the agent is allowed to edit.

```mermaid
mindmap
  root((Unity Agent Workflows))
    Runtime proof
      Visible object
      Scene or prefab reference
      Script or component owner
      Mutating method
      Runtime override
    Code routing
      Core
      Contracts
      Systems
      Features
      Data first content
    UI and assets
      Parent hierarchy
      Anchors and safe area
      CanvasScaler and TMP
      Source asset gate
    Validation
      Smallest useful check
      Exact command output
      Residual risk
    Cleanup
      Reference proof
      Generated file safety
      Git status clarity
```

## Data Flow by Step

The mindmap is not just a list of topics. Each branch feeds a specific step, and each step must produce something useful before the agent moves on.

```mermaid
flowchart TD
    A["Request<br/>what the user wants changed"] --> C["3. Classify the task"]
    B["Local rules<br/>AGENTS.md / README / architecture notes"] --> R["1. Read local rules"]
    S["Repo state<br/>git status --short / dirty files"] --> G["2. Check repo state"]
    M["Graph and source context<br/>Graphify / code search / references"] --> C

    R --> R1["Output:<br/>hard constraints, project rules, out-of-scope areas"]
    G --> G1["Output:<br/>dirty-file boundary and files to preserve"]
    R1 --> C
    G1 --> C

    C --> C1{"Route"}
    C1 --> RP["Runtime proof route"]
    C1 --> CR["Code routing route"]
    C1 --> UI["UI and asset route"]
    C1 --> VA["Validation route"]
    C1 --> CL["Cleanup route"]

    RP --> RP1["Input:<br/>visible object, scene/prefab reference, script/component owner, mutating method, runtime override"]
    RP1 --> O["4. Prove the owner"]

    CR --> CR1["Input:<br/>Core / Contracts / Systems / Features, data-first content, dependency direction, hub risk"]
    CR1 --> O

    UI --> UI1["Input:<br/>parent hierarchy, anchors, safe area, CanvasScaler, TMP refresh path, source asset gate"]
    UI1 --> O

    CL --> CL1["Input:<br/>YAML/GUID references, Resources paths, generated-file status, git status clarity"]
    CL1 --> O

    O --> P{"Proof complete?"}
    P -- "No" --> X["Inspect deeper<br/>read the missing owner/source data"]
    X --> O
    P -- "Yes" --> F["5. Name file boundary<br/>allowed files, not-touched files, out-of-scope systems"]

    F --> H["6. Patch smallest file set<br/>change only the proven owner"]
    VA --> V1["Input:<br/>syntax, compile, Play Mode, graph, package dry-run, exact command output"]
    H --> V["7. Run useful validation"]
    V1 --> V
    V --> Z["8. Close out<br/>changed files, proof, validation result, residual risk"]
```

Here is the same flow in a more practical table:

| Mindmap branch | Enters step | What it carries | Required output before moving on |
|---|---:|---|---|
| Runtime proof | Step 4 | visible object, scene/prefab link, script/component, mutating method, runtime override | owner chain that proves where the live behavior is controlled |
| Code routing | Step 3-5 | Core/Contracts/Systems/Features, data source, dependency direction, hub risk | route choice, Routing Card when structural work is needed, and a file boundary |
| UI and assets | Step 3-6 | hierarchy, anchors, safe area, CanvasScaler, TMP, asset gate | layout owner or asset decision; PixelLab only when a new/replaced source visual asset is required |
| Validation | Step 7-8 | smallest useful check, exact command output, known gaps | validation result and residual risk that can be reported honestly |
| Cleanup | Step 3-8 | YAML/GUID refs, `Resources.Load` paths, generated-file status, git status | deletion/keep proof, safe cleanup scope, and clean Git explanation |

The important bit: data does not jump straight from "I found a file" to "I edited it." It has to pass through classification, owner proof, file boundary, patch, validation, and closeout.

## Install

From the private GitHub repo:

```bash
npx git+ssh://git@github.com/Aun-Phuwanan/unity-agent-workflows.git
```

If the repo is public, this shorthand also works:

```bash
npx github:Aun-Phuwanan/unity-agent-workflows
```

The npm package, installed skill name, and GitHub repo name are all `unity-agent-workflows`.

After the package is published to npm:

```bash
npx unity-agent-workflows
```

Install to both Codex and Claude-style skill folders:

```bash
npx unity-agent-workflows --target both
```

Preview the install without writing files:

```bash
npx unity-agent-workflows --dry-run
```

By default the installer writes to:

```text
~/.codex/skills/unity-agent-workflows
```

If that folder already exists, the installer backs it up with a timestamp before replacing it.

Manual install is fine too:

```bash
git clone git@github.com:Aun-Phuwanan/unity-agent-workflows.git ~/.codex/skills/unity-agent-workflows
```

## Use

Ask your agent to load the skill before it works on Unity game changes:

```text
Use $unity-agent-workflows to route, implement, and validate this Unity gameplay change safely.
```

For narrow bugs, I usually ask for three things:

```text
Use $unity-agent-workflows.
Prove the runtime owner first.
Patch the smallest file set and show the validation command.
```

For structural work, the skill makes the agent fill a Routing Card before editing. That card forces it to name the owner, layer, cross-module communication path, graph/source proof, validation plan, and files it will not touch.

## What Is Inside

```text
unity-agent-workflows/
├── SKILL.md
├── README.md
├── package.json
├── agents/
│   └── openai.yaml
├── bin/
│   └── unity-agent-workflows.js
├── references/
│   ├── ai-workflows.md
│   ├── cleanup-and-git.md
│   ├── content-and-systems.md
│   ├── modular-architecture.md
│   ├── runtime-owner-proof.md
│   ├── session-mining.md
│   ├── ui-and-visual-assets.md
│   └── unity-validation.md
└── scripts/
    └── validate_skill.sh
```

[SKILL.md](SKILL.md) stays short on purpose. The deeper notes live in `references/` so the agent only loads them when the task calls for it.

## Reference Files

- [ai-workflows.md](references/ai-workflows.md): the general workflow, Routing Card, task recipes, and closeout shape
- [runtime-owner-proof.md](references/runtime-owner-proof.md): how to prove the real owner of visible/runtime behavior
- [modular-architecture.md](references/modular-architecture.md): Core, Contracts, Systems, Features, asmdef boundaries, and hub gates
- [unity-validation.md](references/unity-validation.md): compile checks, stale response files, Roslyn/Bee notes, and validation levels
- [ui-and-visual-assets.md](references/ui-and-visual-assets.md): UI layout, mobile readability, safe areas, localization, and visual asset gates
- [content-and-systems.md](references/content-and-systems.md): gameplay data, progression, stages, waves, and system readiness
- [cleanup-and-git.md](references/cleanup-and-git.md): safe deletion, generated files, commit hygiene, and push proof
- [session-mining.md](references/session-mining.md): turning old agent lessons into durable rules without dumping raw chat into the skill

## Validate

Run:

```bash
bash scripts/validate_skill.sh
```

This checks the required skill files, `SKILL.md` frontmatter, `agents/openai.yaml`, the `package.json` bin entry, and the installer script syntax.

For npm packaging:

```bash
npm pack --dry-run
npm publish --dry-run
```

The package name is:

```text
unity-agent-workflows
```

## What This Is Not

This is not a replacement for Unity Play Mode, device testing, code review, or a project's own `AGENTS.md`.

It also will not magically know your project structure. It forces the agent to read the live repo, prove the owner chain, and explain what it changed. That is the point.

## License

No license is specified yet. Add a `LICENSE` file before public reuse or outside contribution.
