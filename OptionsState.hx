package options;

import states.MainMenuState;
import backend.StageData;

/**
 * Modding+ style options: one menu, with categories you flip through using the tab bar
 * at the top (Left/Right while the bar is focused, PageUp/PageDown anywhere).
 * Each category is still its own substate, this state just hosts them and swaps between them.
 */
class OptionsState extends MusicBeatState
{
	public static var categoryIds:Array<String> = [
		'Gameplay',
		'Graphics',
		'Visuals',
		'Controls',
		'Note Colors',
		'Modding+',
		'Adjust Delay and Combo'
		#if TRANSLATIONS_ALLOWED , 'Language' #end
	];

	public static var curCategory:Int = 0;
	static var lastRealCategory:Int = 0; //The delay menu is a full state, so we remember which tab to come back to
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	public static var instance:OptionsState;

	var pendingCategory:Int = -1;
	var leaving:Bool = false;

	public static function getCategoryNames():Array<String>
	{
		var names:Array<String> = [];
		for (id in categoryIds)
		{
			if (id == 'Adjust Delay and Combo') names.push(Language.getPhrase('options_tab_delay', 'Delay'));
			else names.push(Language.getPhrase('options_$id', id));
		}
		return names;
	}

	/** Called by the category menus. Returns false if there's no options menu to switch in. */
	public static function switchCategory(dir:Int):Bool
	{
		if (instance == null) return false;
		instance.requestCategory(FlxMath.wrap(curCategory + dir, 0, categoryIds.length - 1));
		return true;
	}

	function requestCategory(idx:Int)
	{
		pendingCategory = idx;
		if (subState != null) subState.close();
		else openPending();
	}

	function openPending()
	{
		var idx:Int = pendingCategory;
		pendingCategory = -1;
		if (idx >= 0) openCategory(idx);
	}

	function openCategory(idx:Int)
	{
		curCategory = FlxMath.wrap(idx, 0, categoryIds.length - 1);

		switch (categoryIds[curCategory])
		{
			case 'Adjust Delay and Combo':
				curCategory = lastRealCategory;
				MusicBeatState.switchState(new options.NoteOffsetState());
				return;
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals':
				openSubState(new options.VisualsSettingsSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Note Colors':
				openSubState(new options.NotesColorSubState());
			case 'Modding+':
				openSubState(new options.ModdingPlusOptionsSubState());
			#if TRANSLATIONS_ALLOWED
			case 'Language':
				openSubState(new options.LanguageSubState());
			#end
		}
		lastRealCategory = curCategory;
	}

	override function create()
	{
		instance = this;

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);
		menuBG = bg;

		super.create();
		ClientPrefs.saveSettings();

		openCategory(curCategory);
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();

		// A tab was pressed: swap straight to the next category
		if (pendingCategory >= 0)
		{
			openPending();
			return;
		}

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Options Menu", null);
		#end
		exitOptions();
	}

	function exitOptions()
	{
		if (leaving) return;
		leaving = true;

		if (onPlayState)
		{
			StageData.loadDirectory(PlayState.SONG);
			LoadingState.loadAndSwitchState(new PlayState());
			FlxG.sound.music.volume = 0;
		}
		else MusicBeatState.switchState(new MainMenuState());
	}

	override function destroy()
	{
		if (instance == this) instance = null;
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}
