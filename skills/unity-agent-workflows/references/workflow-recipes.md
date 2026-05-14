# Workflow Recipes

Read this only when a task needs a named recipe beyond `references/ai-workflows.md`.

## WF-0 Orientation

Use when placement or ownership is unclear.

1. Search exact screen text, method names, Unity object names, GUIDs, and runtime/content terms with `rg`.
2. Read likely owners and callsites.
3. Read graph output if present.
4. Fill the structure map from `references/project-structure-discovery.md` when placement matters.
5. Fill the Routing Card.
6. Ask only if two live owners are equally plausible and the choice changes user-visible behavior.

## WF-1 Narrow Bug Fix

1. Locate exact call path.
2. Patch the true owner.
3. Avoid architecture migration unless the boundary caused the bug.
4. Validate the smallest surface.

## WF-2 New Runtime Or Content Feature

1. Decide data-first vs code-first.
2. Prefer definitions/config for tuning and identity.
3. Put code-first feature behavior in the repo's owning feature/module/runtime path.
4. Route cross-module facts through contracts/events/bridges.
5. Extract a collaborator if a controller would gain a new responsibility group.
6. For tutorials, missions, unlocks, equipment, rewards, shops, navigation gates, or other state machines, run the Runtime State Step Guard from `references/content-and-systems.md`.

## WF-3 Cross-Module Communication

1. Treat sibling feature imports as blocked.
2. Find the repo's existing gateway/event/contract boundary.
3. If none exists, create the smallest implementation-free contract.
4. Register implementation from the owner.
5. Update asmdefs/docs only when dependency structure changes.

## WF-4 Hub Deflation

1. Name the responsibility group being added or extracted.
2. Check line count and graph status when available.
3. Extract one focused collaborator with one reason to change.
4. Keep MonoBehaviour serialized fields stable if scenes depend on them.
5. Prove changed callsites, moved state, or removed coupling.

## WF-5 Data, Balance, Or Content

1. Search existing definitions/config/assets before editing code.
2. Prefer content data over branching inside runtime controllers.
3. Add C# only when the data declares behavior not currently handled.
4. Validate asset/catalog lookup names and runtime load paths.
5. Report exact constants/assets changed.

## WF-6 UI Or Screenshot Fix

1. Identify visible layer and runtime owner.
2. If the task involves any runtime visible output, focus, highlight, selection, click/tap target, visual target, bounds-type choice, marker, blocker, mask, world-to-UI label, HUD marker, modal dimming, duplicate names, hardcoded layout/position, or "do not guess", run the Runtime Visible Output Hard Stop from `references/runtime-owner-proof.md` before editing.
3. Separate layout/anchoring from readability/polish.
4. Change only the shown layer unless owner proof requires a direct dependency.
5. Preserve camera, background, composition, and runtime layout unless requested.
6. For world/local/screen/canvas/camera coordinate mismatch, read `references/coordinate-space-conversion.md`.
7. If an object is found but no marker exists, read `references/runtime-visible-targets.md` and report candidate rects/ambiguity before choosing.
8. Validate with screenshot, hierarchy, or serialized/runtime proof.

## WF-7 Visual Source Asset

1. Stop code editing.
2. Define the source asset being created/replaced/redesigned.
3. Generate or obtain the approved source asset.
4. Inspect transparency, import scale, orientation, 9-slice readiness, and pixel crispness.
5. Re-run architecture routing before integration code.

## WF-8 Compile Or Validation Repair

1. Capture exact error and assembly context.
2. Fix the smallest compile/runtime owner.
3. Avoid broad refactors unless the error is a boundary violation.
4. Re-run the same validation.

## WF-9 Architecture Decision

1. Keep always-read repo instructions short.
2. Put detailed process in a workflow doc or skill.
3. Put dependency facts in machine-readable rules when possible.
4. Put current runtime maps in architecture docs.
5. Create an ADR for significant decisions likely to be revisited.
6. Validate docs with `git diff --check`.

## WF-10 Cleanup Or Deletion

1. Prove unused status through code refs, YAML GUID refs, resource paths, asset refs, and runtime reachability.
2. Do not treat isolated graph nodes as deletion proof.
3. Separate generated/cache cleanup from source refactors.
4. Report what was not deleted and why.

## WF-11 Session History Or Rule Mining

1. Parse session files structurally.
2. Filter injected instructions, environment dumps, plugin text, and base64.
3. Group repeated patterns before editing rules.
4. Patch only the owning artifact.
5. Validate the rule/skill/docs change.
