# Unity Workflows

Installable Codex plugin bundle for Unity Agent Workflows.

## Example Case: FTUE Sentinel Install Focus

**Before using the plugin: the focus is still on the Sentinel menu button/prompt.**

![Before command: Sentinel menu prompt](assets/case-ftue-sentinel-before-plugin.png)

**Fix with `Unity Workflows`: the focus moves to the real Sentinel `ADD` button.**

![After Unity Workflows: ADD button focus](assets/case-ftue-sentinel-after-plugin.png)

**Fix without plugin rules: the install prompt appears, but the focus lands around the ship position instead of `ADD`.**

![Without plugin rules: wrong ship-area focus](assets/case-ftue-sentinel-without-plugin.png)

Main prompt:

```text
Use $unity-agent-workflows.
Fix the FTUE Stage 5 Sentinel ADD focus mismatch. Treat it as a repeated visible-output failure: spawn read-only sub-agents first, gather runtime numeric proof/checker requirements, lock scope before patching, and do not touch Earth/background/camera/unrelated systems.
```

Source repository:

```text
https://github.com/AUN-PN/unity-agent-workflows
```

See the source repository README for installation, usage, validation, support, and contribution details.
