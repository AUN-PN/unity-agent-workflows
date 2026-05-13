# Coordinate Space Conversion

Read this only for cross-canvas overlays, world-to-UI markers, safe area/screen edge work, or coordinate mismatch bugs.

## Target Selection Check

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

Use when a focus ring, tutorial spotlight, dim hole, blocker, or modal overlay is drawn in a different canvas/root than the target.

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
6. If safe area, `CanvasScaler`, content frame, layout group, tween, or parent scale mutates either root after conversion, convert after that writer has run or re-convert on the next layout tick.
7. Validation must report source canvas, destination overlay root, conversion API, and screenshot/runtime proof. If hardcoded fallback remains, report why runtime conversion failed.

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
