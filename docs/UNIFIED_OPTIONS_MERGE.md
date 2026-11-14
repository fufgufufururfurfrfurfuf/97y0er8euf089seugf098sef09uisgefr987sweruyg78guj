# Unified Options Menu — Modding+ Integration Plan

## Direction

Keep Psych Engine's existing `OptionsState`, `BaseOptionsMenu`, `Option`, and `CategoryTabs` as the single menu framework. Do not ship a second, competing options screen. The visual direction is the supplied reference: saturated blue/purple backdrop, chunky white outlined labels, bright green enabled marks, compact category tabs, and dark rounded save/load panels.

## Proposed top-level tabs

1. Gameplay
2. Graphics
3. Visuals
4. Controls
5. Mod Settings
6. Modding+
7. Save Data
8. Note Colors
9. Delay

The existing per-mod `ModSettingsSubState` remains available for each mod's own metadata-defined settings. The separate **Modding+** page is for engine-wide Modding+ options; it must not be confused with per-mod settings.

## Modding+ options to bring across

Map the legacy `OptionsHandler.TOptions` values into the existing `Option` types and save pipeline:

- Gameplay: `downscroll`, `useCustomInput` (ghost tapping), `dontMuteMiss`, `showComboBreaks`, `emuOsuLifts`, `useMissStun`, `useKadeHealth`, `danceMode`.
- Flow and unlocks: `skipVictoryScreen`, `skipModifierMenu`, `alwaysDoCutscenes`, `ignoreUnlocks`, `allowStoryMode`, `allowFreeplay`, `allowDonate`.
- Judgement: `judge`, `preferJudgement`, `newJudgementPos`, `accuracyMode`, `ignoreVile`.
- Audio and HUD: `hitSounds`, `showSongPos`, `stressTankmen`.
- Performance and presentation: `fpsCap`, `style`, `titleToggle`.

Use the target engine's canonical preference fields where they already exist. For legacy-only fields, retain the Modding+ JSON-backed options store rather than silently writing them into unrelated `ClientPrefs` fields. Keep the legacy `danceMode` constraints enforced by `OptionsHandler`.

## Save Data page

Rebuild the 10-slot save/load selector as a page inside the unified menu, not as a separate state. Preserve slot selection, load, save, delete confirmation, and preferred-slot behavior. Reuse the Modding+ save-slot art and animation atlas only after those assets are present; do not create broken asset paths or fake placeholder references.

## Integration rules

- Save settings when leaving a category and when exiting the menu.
- Preserve keyboard and gamepad rebinding from Psych Engine.
- Keep PageUp/PageDown and shoulder-button category switching.
- Ensure category changes do not accidentally exit the menu or reset the selected tab.
- Respect compile-time guards for desktop-only file access and translation support.
- Avoid duplicating options that already exist in Psych Engine; merge the behavior, not two copies of the same toggle.

## Asset checklist

The supplied target repository currently contains the 13 options-related Haxe files but not the full engine tree or the Modding+ visual assets. Before wiring the illustrated save-slot page, add the matching `save-data.png`, `save-data.xml`, checkmark art, and any required background/menu assets to the target project's normal asset paths. Confirm the engine's existing asset conventions before committing paths.

## Acceptance checklist

- Every tab is reachable by keyboard and gamepad.
- Every toggle/value persists after leaving and reopening Options.
- Legacy-only Modding+ options round-trip through the correct store.
- Save/load/delete operations work for all 10 slots, including canceling deletion.
- No missing asset warnings or compile errors on supported targets.
- Existing Psych Engine options and mod-defined settings continue to work.
