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

## Visual Target Selection

A runtime target can have multiple useful bounds. Pick the bounds for the requested visual job, not the first object with the right name.

A live object is not enough proof. The agent must prove the correct bounds type for the requested job.

Always classify these separately:

- `interactiveRect`: click/tap/hit area such as `Button`, `Selectable`, `Collider`, `EventTrigger`
- `visualRect`: the pixels/mesh/sprite/text/card the player actually sees
- `logicRect`: gameplay area such as attack radius, trigger volume, spawn region, lock-on range
- `markerRect`: explicit author-provided focus/anchor marker such as `Focus Target`, `Highlight Target`, `Visual Target`, `Aim Point`, `Socket`, `Muzzle`, `Pivot`
- `overlayRect`: selected rect after conversion into the destination overlay/root coordinate space

For focus rings, spotlight holes, tutorial highlights, selection brackets, arrows, tooltip anchors, and visual alignment, prefer:

1. explicit `markerRect`
2. `visualRect`
3. `interactiveRect`
4. named hardcoded fallback

Do not use `interactiveRect` as the primary visual target when visible children or marker transforms exist.

## Visual Focus Target Decision

For focus rings, spotlight holes, tutorial arrows, and forced-click blockers, do not assume the best target is the root object center.

Resolve and report these candidates before choosing:

- `markerRect`: child `RectTransform` or transform named `* Focus Target`, `* Highlight Target`, `* Visual Target`
- `visualRect`: visible graphic cluster, icon + label + visible frame
- `interactiveRect`: `Button`, `Selectable`, `EventTrigger`, or `Collider` hit area
- `overlayRect`: selected rect after conversion into destination overlay/root space

Selection order:

1. `markerRect`
2. `visualRect`
3. `interactiveRect`
4. named hardcoded fallback

If `markerRect` is missing and `visualRect` differs strongly from `interactiveRect`, do not silently pick one. Report ambiguity and recommend adding a marker.

If an object is found but no marker exists:

- Do not claim the target is proven from the object alone.
- Show candidate rects before choosing.
- If the selected rect does not match the user-visible point, recommend adding a marker.
- Do not patch hardcoded coordinates from root/object center by guessing.

## Required Target Report

For every UI focus/highlight target, closeout or diagnosis must include:

- target name
- parent chain
- owner script/component
- `interactiveRect`
- `visualRect`
- `markerRect`
- selected rect
- source canvas
- destination overlay/root
- conversion method
- whether fallback was used

Do not patch coordinates until the selected rect is proven.

## Target Bounds By Object Type

### UI Button / Tab / Menu Item

Use:
1. `markerRect`: child marker named `* Focus Target`, `* Highlight Target`, `* Visual Target`
2. `visualRect`: visible graphic cluster from active `Image`, `RawImage`, `Text`, `TMP_Text`, icon, label, card/frame children
3. `interactiveRect`: `Button` / `Selectable` root rect only as fallback

Reject:
- full-size invisible hitbox
- transparent background image
- layout-only parent
- mask/clip root unless it is the visible frame

Report:
- `interactiveRect`
- `visualRect`
- `markerRect`
- selected rect
- whether root button fallback was used

### UI Card / Panel / Modal

Use:
1. `markerRect`: explicit marker rect
2. `visualRect`: visible panel/frame image rect
3. content group rect if the card has padding or transparent margins

Reject:
- parent section root
- full-screen container
- scroll viewport unless the viewport itself is the target

### Icon / Badge / Currency / Resource Counter

Use:
1. icon image rect + value text rect combined
2. icon rect only if the user points to the icon
3. text rect only if the user points to the number/label

Do not use the whole HUD bar unless the request names the whole bar.

### Scroll/List Row

Use:
1. active row visible frame
2. row content cluster
3. row button/hitbox fallback

Before converting:
- ensure row is active after layout/rebuild
- ensure scroll content has completed positioning
- reject pooled inactive row templates

### Tooltip / Coach Bubble / Tutorial Panel

Use:
1. panel visible rect
2. arrow tip / pointer marker if aligning to target
3. text bounds only when user asks for text position

### World Unit / Enemy / Player / Sentinel

Use:
1. explicit marker transform: `FocusPoint`, `AimPoint`, `Core`, `Center`, `Head`, `Socket`
2. `Renderer.bounds` combined across visible renderers
3. `Collider.bounds` only for hitbox/debug or when the user asks for gameplay hitbox bounds
4. root transform position fallback

Reject:
- pooled inactive prefab
- parent container bounds that include offscreen helpers
- weapon/projectile child unless requested

### Projectile / Bullet / Missile / Beam

Use:
1. active renderer bounds
2. collider bounds for hitbox debug
3. trail/line renderer bounds only if visual trail is the target

For fast-moving objects:
- sample after movement update or in `LateUpdate`
- avoid stale spawn-position bounds

### VFX / Particle / Explosion / Area Effect

Use:
1. explicit center marker
2. `ParticleSystemRenderer.bounds` for visible effect
3. authored radius fallback or area config for gameplay area

Do not use particle system root if renderer bounds or radius exists.

### 3D Object / Mesh / Prop

Use:
1. explicit marker transform
2. combined `Renderer.bounds`
3. `Collider.bounds` if collision/hitbox target

Convert world to UI through:
- active gameplay camera
- destination canvas render mode/camera
- screen point to overlay root

### Spawn Point / Path / Invisible Trigger

Use:
1. marker transform/shape gizmo if visible target is a marker
2. collider/trigger bounds if debugging gameplay area
3. never use invisible trigger bounds for a visual focus unless the user asked for trigger/debug view

### Safe Area / Screen Edge / Camera View

Use:
1. `Screen.safeArea` converted into destination canvas/root
2. camera viewport corners converted through the active camera
3. do not use raw `Screen.width` / `Screen.height` as overlay-local coordinates

### Text / TMP Label

Use:
1. text rect after layout rebuild
2. preferred values only for sizing decisions, not final screen bounds
3. include outline/shadow padding if focus ring must visually surround text

Reject:
- parent row/card unless request targets the whole row/card

## Target Selection Decision

Before patching focus/highlight/tooltip/arrow position, answer internally:

1. What is the user-visible thing?
2. Is the requested target visual, interactive, logical, or debug?
3. Which runtime object owns that thing?
4. Which bounds represent the thing: marker, visual cluster, renderer, collider, or hitbox?
5. Are there duplicate names or inactive prefab/template objects?
6. Which coordinate space draws the result?
7. Which writer may move the target after this frame?

If bounds type is not proven, do not patch coordinates.

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
