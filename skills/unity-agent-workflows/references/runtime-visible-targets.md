# Runtime Visible Targets

Read this only when a task involves focus, highlight, click/tap target, visual target, spotlight, modal dimming, duplicate names, hardcoded layout/position, or "do not guess".

## Hardcoded Fallback Contract

Keep hardcoded layout only as a named fallback, never as the primary path, when a live runtime target can be resolved.

Allowed fallback shape:

```text
try runtime target -> try runtime bounds conversion -> if lookup/conversion fails, use named hardcoded fallback -> report residual risk
```

Keep the fallback until runtime lookup and coordinate conversion are validated across scene timing, orientation, safe area, and device layout.

When fallback runs, the closeout or runtime log must include:

- target name or identifier that failed
- expected parent chain or owner
- source canvas and destination overlay root, if known
- failed step: lookup, duplicate ambiguity, inactive target, missing camera, layout not ready, or conversion failure
- fallback anchor/size name used

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

A runtime target can have multiple bounds. Pick the one for the requested job, not the first object with the right name. A live object alone is not proof.

Always classify these separately:

- `interactiveRect`: click/tap/hit area such as `Button`, `Selectable`, `Collider`, `EventTrigger`
- `visualRect`: pixels/mesh/sprite/text/card the user sees
- `logicRect`: gameplay area such as attack radius, trigger volume, spawn region, lock-on range
- `markerRect`: author-provided focus/anchor marker such as `Focus Target`, `Highlight Target`, `Visual Target`, `Aim Point`, `Socket`, `Muzzle`, `Pivot`
- `overlayRect`: selected rect after conversion into destination overlay/root space

For focus rings, spotlight holes, tutorial highlights, selection brackets, arrows, tooltip anchors, and visual alignment, prefer:

1. explicit `markerRect`
2. `visualRect`
3. `interactiveRect`
4. named hardcoded fallback

Do not use `interactiveRect` as the primary visual target when visible children or marker transforms exist.

If `markerRect` is missing and `visualRect` differs strongly from `interactiveRect`, report ambiguity and recommend adding a marker.

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

Patch coordinates only after the selected rect is proven.
