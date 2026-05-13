# Content And Systems

## Data-First Rule

Add new runtime/content behavior as data first when the repo has definition/config surfaces.

Use definitions/config for:

- level/step/session numbers, duration, pressure, unlocks
- entity/object HP, speed, score, size, tint, resistance, or availability
- actions/abilities/tools, cooldown, duration, radius, potency
- user/player/unit/support loadout and availability
- state effects, stack/refresh policy, duration bounds
- synergy rules
- localization keys and presentation identity

Add C# only when:

- a definition declares a behavior key that no runtime handler supports
- the content introduces a genuinely new runtime mechanic
- an existing service lacks the required integration seam

## System Stack For Production Readiness

When asked for broad "what is missing" or "finish the game systems" passes, verify live code first. High-value foundations often include:

- Analytics/telemetry.
- FTUE/onboarding.
- Adaptive difficulty/relief.
- Missions/objectives.
- Status effects/resistance.
- Skill + support-unit synergy.
- Stage mastery/progression.
- Save migration/cloud-ready snapshots.
- Accessibility/haptics/reduced motion.
- Runtime performance/adaptive visual budget.

Do not add all of these blindly. Mark a phase complete only when a live owner exists under the correct layer and has runtime path, gateway, event, persistence, or UI proof.

## Thin System Slice

For a missing foundation, add the smallest useful owner:

1. Contract/gateway in the repo's existing contract/event/gateway boundary.
2. Runtime service in the repo's existing service/system/runtime owner path.
3. Thin feature hook beside the feature that already knows the runtime fact.
4. Event or bridge route instead of a direct feature reference.
5. Architecture docs/asmdef sync if dependency structure changes.

## Runtime Experience Pattern

For level/session pacing, tutorials, objectives, and difficulty shaping, prefer a thin planning layer:

```text
Content config/data
-> RuntimeExperiencePlan
-> director/adaptive relief/objectives/analytics
```

The planner should feed existing seams instead of growing the main manager, controller, or scene owner.

## Balance Pass Rules

- Read current data/config and runtime override paths before changing values.
- Include user/player capability, action/tool power, support systems, economy, and pacing in broad balance passes.
- Make small targeted changes unless the user explicitly asks for a broad rebalance.
- Report exact constants/assets changed.
- Re-scan after broad localization or balance sweeps until the next search is clean or remaining items are out of scope.
