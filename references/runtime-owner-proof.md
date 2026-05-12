# Runtime Owner Proof

Use this when a visible fix may not show in Play mode, a screenshot target is ambiguous, or a previous change "did nothing".

## Owner Chain

Prove this before editing visible/runtime behavior:

```text
visible object
-> scene/prefab/reference
-> script/component
-> mutating method
-> serialized/runtime override
```

If one link is missing, search another direction before stopping.

## Search Directions

- Visible text, object name, sprite name, material name, method name.
- Scene YAML and prefab YAML refs.
- Script GUID from `.meta` files.
- Serialized field names and `FormerlySerializedAs`.
- Runtime builders: `Awake`, `OnEnable`, `Start`, `LateUpdate`, layout builders, factories, presenters.
- Refresh paths that rewrite labels/colors/sizes after creation.
- `GameObject.Find`, `FindObjectOfType`, `Resources.Load`, addressables, service locators.
- Animation, tween, clone, pooling, safe-area, CanvasScaler, or camera scripts that override values.

## Do Not Assume

- Scene transform scale is not runtime truth if a startup script rewrites it.
- Prefab default is not runtime truth if the scene has overrides.
- A constant is not owner proof if a presenter/layout helper later clamps it.
- Compile passing is not visual proof.
- A semantically related file is not proof that it owns the marked screenshot target.

## Coordinate Spaces

Do not copy values across spaces without conversion:

- World-space `Transform.localScale`.
- `SpriteRenderer` bounds and pixels-per-unit.
- Screen-space `RectTransform.sizeDelta`.
- Canvas scaler reference resolution.
- Camera orthographic units.
- Device safe-area pixels.
- RenderTexture or world-space Canvas units.

## Repeated-Fix Flow

When the user says the result is still wrong:

1. Stop tuning constants.
2. Re-read the screenshot/target wording.
3. Prove exact visible target.
4. Search runtime writers and refresh paths.
5. Check whether the edited script is in the compiled assembly.
6. Check whether scene/prefab overrides also need updating.
7. Patch both creation and refresh paths when state reverts.
8. Validate with Game view/device/screenshot proof when possible.

## Screenshot Ambiguity

If the screenshot and text disagree, ask one concise clarifying question before editing. If the screenshot clearly marks one object, scope the patch to that object and direct dependencies only.
