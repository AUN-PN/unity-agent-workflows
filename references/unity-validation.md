# Unity Validation

Use the smallest useful check. Validation should match the edited surface and risk.

## Validation Ladder

1. Text/metadata:
   - `git diff --check -- <files>`
   - Parse changed JSON/YAML/TOML when applicable.

2. C# compile:
   - Prefer Unity-generated Bee `.rsp` files matching the touched asmdef.
   - If `dotnet` is unavailable, use Unity-bundled Roslyn.
   - If Bee `.rsp` files are stale after moves, copy to `Temp/`, rewrite only stale paths for the check, and report that Unity must regenerate durable artifacts.

3. Graph/architecture:
   - Refresh or inspect graph when code changed and architecture proof depends on it.
   - Report God Node, edge gate, and largest touched `.cs` status for structural edits.

4. Runtime-owner:
   - For visible behavior, prove scene/prefab/component/mutator/override chain.
   - For runtime-built UI, validate the builder/presenter path, not only scene YAML.

5. Runtime visual:
   - Use Game view, Device Simulator, Play mode, screenshot, or device build only when the task/risk justifies it.
   - State clearly when visual runtime validation was not run.

## Common Commands

```bash
git diff --check -- <files>
rg --files Library/Bee | rg '\\.rsp$'
rg -n "error CS|warning CS" <log-file>
```

## Roslyn/Bee Pattern

1. Find `.rsp` files:

```bash
rg --files Library/Bee | rg '\\.rsp$'
```

2. Pick the response file matching the touched assembly, such as a feature/module/system asmdef.
3. Locate Unity Roslyn under the installed Unity editor.
4. Run the compiler from the repo root with the response file.
5. Report only actionable errors. Separate analyzer warnings or unrelated dirty-file failures from requested changes.

## Batchmode Guardrails

- Another open Unity editor can block batchmode. Report it as an environment blocker.
- Do not chase unrelated compile errors unless they block the requested proof.
- Do not edit `Library/`, Bee output, generated `.csproj`, or `.sln` as durable source fixes.

## Final Validation Report

Include:

- Command run.
- Pass/fail.
- Exact error text if failed.
- Whether failures are related to touched files.
- Residual risk if Play mode/Game view/device was skipped.
