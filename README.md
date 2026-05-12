# Unity Game AI Workflows

A practical skill for using AI agents on Unity game projects without letting them guess their way through the codebase.

I made this after running into the same Unity-agent problems over and over: the agent edits the nearby script instead of the runtime owner, changes prefab or scene values that get overwritten in Play mode, grows one more huge controller, or says "validated" without proving the path that actually runs.

This skill is the set of guardrails I wish every Unity coding agent had loaded before touching a game project.

The agent entrypoint is [SKILL.md](SKILL.md). This README is just the human-readable overview.

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

## Install

From the private GitHub repo:

```bash
npx git+ssh://git@github.com/Aun-Phuwanan/unity-game-ai-workflows.git
```

If the repo is public, this shorthand also works:

```bash
npx github:Aun-Phuwanan/unity-game-ai-workflows
```

After the package is published to npm:

```bash
npx unity-game-ai-workflows
```

Install to both Codex and Claude-style skill folders:

```bash
npx unity-game-ai-workflows --target both
```

Preview the install without writing files:

```bash
npx unity-game-ai-workflows --dry-run
```

By default the installer writes to:

```text
~/.codex/skills/unity-game-ai-workflows
```

If that folder already exists, the installer backs it up with a timestamp before replacing it.

Manual install is fine too:

```bash
git clone git@github.com:Aun-Phuwanan/unity-game-ai-workflows.git ~/.codex/skills/unity-game-ai-workflows
```

## Use

Ask your agent to load the skill before it works on Unity game changes:

```text
Use $unity-game-ai-workflows to route, implement, and validate this Unity gameplay change safely.
```

For narrow bugs, I usually ask for three things:

```text
Use $unity-game-ai-workflows.
Prove the runtime owner first.
Patch the smallest file set and show the validation command.
```

For structural work, the skill makes the agent fill a Routing Card before editing. That card forces it to name the owner, layer, cross-module communication path, graph/source proof, validation plan, and files it will not touch.

## What Is Inside

```text
unity-game-ai-workflows/
├── SKILL.md
├── README.md
├── package.json
├── agents/
│   └── openai.yaml
├── bin/
│   └── unity-game-ai-workflows.js
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
unity-game-ai-workflows
```

## What This Is Not

This is not a replacement for Unity Play Mode, device testing, code review, or a project's own `AGENTS.md`.

It also will not magically know your project structure. It forces the agent to read the live repo, prove the owner chain, and explain what it changed. That is the point.

## License

No license is specified yet. Add a `LICENSE` file before public reuse or outside contribution.
