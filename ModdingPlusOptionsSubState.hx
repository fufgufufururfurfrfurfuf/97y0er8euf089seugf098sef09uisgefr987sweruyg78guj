package options;

import options.Option.OptionType;

/**
 * Modding+ settings integrated into Psych Engine's existing options framework.
 *
 * These settings use a namespaced section of ClientPrefs.data.gameplaySettings,
 * so they are persisted by the normal Psych Engine preferences save pipeline
 * without requiring Modding+'s separate options.json / OptionsHandler runtime.
 */
class ModdingPlusOptionsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Modding+ Settings';
		rpcTitle = 'Modding+ Settings Menu';
		useTabs = true;

		// Flow and unlock behavior
		addMPBool('Skip Victory Screen', 'Skip the post-song victory screen.', 'skipVictoryScreen', false);
		addMPBool('Skip Modifier Menu', 'Skip the song modifier selection menu.', 'skipModifierMenu', false);
		addMPBool('Always Show Cutscenes', 'Force cutscenes to play, including in Freeplay.', 'alwaysDoCutscenes', false);
		addMPBool('Ignore Unlocks', 'Make songs and weeks available without meeting unlock requirements.', 'ignoreUnlocks', false);
		addMPBool('Allow Story Mode', 'Show Story Mode in the main menu.', 'allowStoryMode', true);
		addMPBool('Allow Freeplay', 'Show Freeplay in the main menu.', 'allowFreeplay', true);
		addMPBool('Allow Donate Button', 'Show the donate button in the main menu.', 'allowDonate', false);

		// HUD, audio, and gameplay behavior not already exposed by Psych's Gameplay tab
		addMPBool('Show Song Position', 'Display the song position bar.', 'showSongPos', false);
		addMPBool('Style Mode', 'Enable Modding+ style presentation where supported by the mod.', 'style', false);
		addMPBool('Funny Songs', 'Enable the Modding+ funny-song behavior.', 'stressTankmen', false);
		addMPBool('New Judgement Layout', 'Use the alternate judgement position.', 'newJudgementPos', false);
		addMPBool('Emulate Osu Lifts', 'Add lift notes at the ends of sustains.', 'emuOsuLifts', false);
		addMPBool('Show Combo Breaks', 'Flash the screen when a combo is broken.', 'showComboBreaks', false);
		addMPBool('Use Kade Health', 'Use the alternate Kade-style health gain and loss behavior.', 'useKadeHealth', false);
		addMPBool('Use Miss Stun', 'Briefly prevent note hits after a miss.', 'useMissStun', false);
		addMPBool('Do Not Mute on Miss', 'Keep vocals playing when a note is missed.', 'dontMuteMiss', false);
		addMPBool('Hit Sounds', 'Play a sound when a note is hit.', 'hitSounds', false);
		addMPBool('Ignore Vile Rating', 'Disable the Vile judgement rating.', 'ignoreVile', false);

		// Numeric legacy settings
		addMPNumber('Judge', 'Select the Modding+ judgement preset index.', 'judge', 0, 0, 10, 1);
		addMPNumber('Preferred Judgement', 'Select the preferred judgement display index.', 'preferJudgement', 0, 0, 20, 1);
		addMPNumber('Accuracy Mode', '0 = Simple, 1 = Complex, 2 = Binary, -1 = Disabled.', 'accuracyMode', 0, -1, 2, 1);
		addMPNumber('FPS Cap', 'Set the Modding+ frame-rate cap preference.', 'fpsCap', 60, 20, 240, 10);
		addMPBool('Title Background', 'Enable the Modding+ title-screen background behavior.', 'titleToggle', true);

		super();
	}

	function addMPBool(name:String, description:String, key:String, defaultValue:Bool):Option
	{
		var option:Option = new Option(name, description, 'moddingPlus_' + key, BOOL);
		bindStoredValue(option, 'moddingPlus_' + key, defaultValue);
		addOption(option);
		return option;
	}

	function addMPNumber(name:String, description:String, key:String, defaultValue:Float, min:Float, max:Float, step:Float):Option
	{
		var option:Option = new Option(name, description, 'moddingPlus_' + key, INT);
		bindStoredValue(option, 'moddingPlus_' + key, defaultValue);
		option.minValue = min;
		option.maxValue = max;
		option.changeValue = step;
		option.scrollSpeed = step * 8;
		option.displayFormat = '%v';
		addOption(option);
		return option;
	}

	function bindStoredValue(option:Option, key:String, defaultValue:Dynamic):Void
	{
		option.defaultValue = defaultValue;
		option.getValue = function():Dynamic
		{
			var value:Dynamic = ClientPrefs.data.gameplaySettings.get(key);
			return value == null ? defaultValue : value;
		};
		option.setValue = function(value:Dynamic):Dynamic
		{
			ClientPrefs.data.gameplaySettings.set(key, value);
			return value;
		};

		if (option.getValue() == null)
			option.setValue(defaultValue);
	}
}
