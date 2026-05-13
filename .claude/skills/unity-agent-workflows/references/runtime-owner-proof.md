# Runtime Owner Proof

Use this when a visible fix may not show in Play mode, a screenshot target is ambiguous, a target object may have duplicate names, or a previous change "did nothing".

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

## Runtime Visible Target Lock

Use this lock when the user asks to move, focus, highlight, click, bind, align, dim around, brighten, select, inspect, or fix any visible UI/gameplay target.

Trigger examples:

- The highlighted/focused target is in the wrong place.
- The target may be a button, icon, card, chip, panel, HUD slot, tooltip, marker, collider, unit, prop, VFX target, or other visible runtime object.
- The user asks for the real object, runtime object, real UI element, real world object, or object position.
- The code uses hardcoded layout, fixed anchor, fixed position, guessed size, or screenshot-measured coordinates for a visible/focus/interactive target.
- The user says not to guess, not to measure from screenshot, or that the target is still in the same place.
- The user asks what an object is, how many duplicate names exist, or says not to edit yet.

Required proof before editing:

```text
user-visible target
-> runtime GameObject
-> runtime RectTransform/Transform
-> scene/prefab/source creator
-> script/component owner
-> runtime layout/movement writer
-> duplicate-name result
-> measurement coordinate space
-> validation method
```

If the proof chain is incomplete, do not patch coordinates. Inspect deeper or ask one concise question if two live owners are equally plausible.

## Hardcoded Layout Guard

Hardcoded layout is not runtime object proof.

For any focus ring, tutorial spotlight, modal hole, tap/click target, highlight, selection marker, or visual alignment:

1. Do not start from fixed `Vector2`, anchor, `sizeDelta`, screen pixels, normalized percentages, or helper methods that only return expected coordinates.
2. First resolve the live target object: visible text/icon -> active `GameObject` -> `RectTransform`/`Transform` -> interactive component -> parent chain -> owner/builder.
3. Compute the overlay/focus bounds from `RectTransform.GetWorldCorners()`, `Renderer.bounds`, `Collider.bounds`, or an explicit runtime marker transform.
4. Use hardcoded values only as a named fallback after target resolution fails, and report the fallback as residual risk.
5. If a fallback is used, log or surface the missing target name/parent chain so the next run can fix the real owner path.

Bad proof:

```text
expected position -> hardcoded layout -> overlay
```

Required proof:

```text
visible target -> runtime object -> runtime bounds -> converted coordinate space -> overlay
```

## Hardcoded Fallback Contract

Keep hardcoded layout only as a named fallback, never as the primary path, when a live runtime target can be resolved.

Allowed fallback shape:

```text
try runtime target -> try runtime bounds conversion -> if lookup/conversion fails, use named hardcoded fallback -> report residual risk
```

Do not remove a fallback until runtime target lookup and coordinate conversion have been validated across the relevant scene timing, orientation, safe area, and device layout cases.

When fallback runs, the closeout or runtime log must include:

- target name or identifier that failed
- expected parent chain or owner
- source canvas and destination overlay root, if known
- failed step: lookup, duplicate ambiguity, inactive target, missing camera, layout not ready, or conversion failure
- fallback anchor/size name used

## Read-Only Target Inspection

When the user says not to edit yet, or asks what the object is:

- Do not edit files.
- List candidate objects with parent chain, scene/prefab source, active state, component type, and owner script when available.
- Count duplicate names and explain which candidates are runtime-active.
- Wait for explicit edit approval before patching.

## UI Target Resolution

For Unity UI targets such as buttons, icons, cards, chips, panels, HUD slots, meters, labels, tooltips, list rows, overlays, and modal controls:

1. Resolve the exact active `RectTransform`.
2. Require an expected parent chain, owner component, or source builder when names are not unique.
3. For interactive targets, require the `Button`, `Toggle`, `Slider`, `Selectable`, `EventTrigger`, raycast target, collider, or input component to be active/enabled/interactable when applicable.
4. Reject ambiguous duplicates. Do not choose the first object returned by `GameObject.Find(name)`.
5. Read bounds with `RectTransform.GetWorldCorners()`.
6. Convert bounds into the same overlay/canvas/root coordinate space used to draw the focus, hole, ring, or blocker.
7. Compute focus/highlight/spotlight from the converted runtime bounds, not guessed constants.
8. Reject hardcoded focus anchors/sizes as the primary path when an active UI target exists.

## Cross-Canvas UI Conversion

Use this when a focus ring, tutorial spotlight, dim hole, blocker, or modal overlay is drawn in a different canvas/root than the target button, icon, or panel.

1. Prove both spaces before editing:
   - source target `RectTransform` and parent chain
   - source `Canvas.renderMode`, `worldCamera`, and `CanvasScaler`
   - destination overlay canvas/root `RectTransform`
   - destination safe-area/content-frame writer
2. Do not treat `Screen.width` / `Screen.height` normalized values as overlay-local coordinates.
3. Do not assume two UI roots share the same scale, anchors, safe area, or reference resolution.
4. Convert the target world corners through screen space, then into the destination overlay root:

```csharp
target.GetWorldCorners(worldCorners);
for (int i = 0; i < 4; i++)
{
    Vector2 screenPoint = RectTransformUtility.WorldToScreenPoint(sourceCamera, worldCorners[i]);
    RectTransformUtility.ScreenPointToLocalPointInRectangle(
        overlayRoot,
        screenPoint,
        overlayCamera,
        out overlayLocalCorners[i]);
}
```

Use `null` camera only for `ScreenSpaceOverlay`; use the canvas camera for `ScreenSpaceCamera` or `WorldSpace`.

5. Build the spotlight/focus/blocker from min/max of `overlayLocalCorners`, then assign it in the same root that draws the overlay.
6. If any writer such as safe area, `CanvasScaler`, content frame, layout group, tween, or parent scale mutates either root after conversion, convert after that writer has run or re-convert on the next layout tick.
7. Validation must report source canvas, destination overlay root, conversion API used, and screenshot/runtime proof. If the implementation still uses hardcoded fallback, report why runtime conversion failed.

Target proof format:

```text
target:
component:
active/interactable:
parent chain:
source creator:
duplicate names:
bounds source:
source canvas:
destination overlay root:
conversion:
validation:
```

## World Target Resolution

For non-UI visible targets such as units, enemies, props, projectiles, spawn markers, colliders, VFX anchors, interactables, and camera/world markers:

1. Resolve the exact active `GameObject`.
2. Identify scene/prefab source and runtime creator.
3. Use `Renderer.bounds`, `Collider.bounds`, or an explicit marker transform as the target bounds.
4. If UI follows the target, convert world position through the active camera and target canvas render mode.
5. Validate camera, canvas, scale, pooling, clone, and animation writers before editing offsets.

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
- A `GameObject.Find(name)` match is not proof when duplicate names or inactive scene objects can exist.
- Screenshot pixels are not runtime object proof when the user asks for object, hierarchy, or code-derived position.
- Hardcoded layout/position is not proof for a visible target when a live `RectTransform`, `Transform`, `Renderer`, `Collider`, or marker can be resolved.

## Coordinate Spaces

Do not copy values across spaces without conversion:

- World-space `Transform.localScale`.
- `SpriteRenderer` bounds and pixels-per-unit.
- Screen-space `RectTransform.sizeDelta`.
- Canvas scaler reference resolution.
- Camera orthographic units.
- Device safe-area pixels.
- RenderTexture or world-space Canvas units.

For UI focus/highlight/spotlight, use one coordinate space for all related pieces:

- target bounds
- focus ring or outline
- spotlight hole
- dim scrim
- input blocker
- modal panel

## Repeated-Fix Flow

When the user says the result is still wrong:

1. Stop tuning constants.
2. Re-read the screenshot/target wording.
3. Re-run the Runtime Visible Target Lock proof chain.
4. Check duplicate names, inactive scene objects, cloned runtime objects, and parent-chain ambiguity.
5. Search runtime writers and refresh paths.
6. Check whether the edited script is in the compiled assembly.
7. Check whether scene/prefab overrides also need updating.
8. Patch both creation and refresh paths when state reverts.
9. Validate with Game view/device/screenshot proof when possible.

## Screenshot Ambiguity

If the screenshot and text disagree, ask one concise clarifying question before editing. If the screenshot clearly marks one object, scope the patch to that object and direct dependencies only.
