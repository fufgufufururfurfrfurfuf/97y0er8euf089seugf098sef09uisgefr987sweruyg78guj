package options;

import flixel.group.FlxSpriteGroup;

/**
 * Category tab bar shown at the top of every options screen (Modding+ style).
 * Left/Right switches category while the bar is focused, PageUp/PageDown works everywhere.
 */
class CategoryTabs extends FlxSpriteGroup
{
	public var focused(default, set):Bool = false;

	var labels:Array<FlxText> = [];
	var highlight:FlxSprite;
	var arrowLeft:FlxText;
	var arrowRight:FlxText;
	var current:Int = 0;

	public function new(current:Int)
	{
		super();
		this.current = current;
		scrollFactor.set();

		var bar:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		bar.alpha = 0.55;
		add(bar);

		highlight = new FlxSprite().makeGraphic(1, 1, FlxColor.WHITE);
		add(highlight);

		var names:Array<String> = OptionsState.getCategoryNames();
		var totalWidth:Float = 0;
		for (name in names)
		{
			var label:FlxText = new FlxText(0, 12, 0, name, 28);
			label.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			label.borderSize = 2;
			labels.push(label);
			totalWidth += label.width;
		}

		// Spread the labels out, but squeeze the gaps if the translated names are long
		var gap:Float = Math.max(12, Math.min(36, (FlxG.width - 120 - totalWidth) / Math.max(1, names.length - 1)));
		var x:Float = (FlxG.width - (totalWidth + gap * (names.length - 1))) / 2;
		for (label in labels)
		{
			label.x = x;
			x += label.width + gap;
			add(label);
		}

		arrowLeft = makeArrow('<', 18);
		arrowRight = makeArrow('>', FlxG.width - 38);

		updateTabs();
		focused = false;
	}

	function makeArrow(symbol:String, x:Float):FlxText
	{
		var arrow:FlxText = new FlxText(x, 12, 0, symbol, 28);
		arrow.setFormat(Paths.font('vcr.ttf'), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		arrow.borderSize = 2;
		arrow.visible = false;
		add(arrow);
		return arrow;
	}

	function updateTabs()
	{
		for (i => label in labels)
			label.alpha = (i == current) ? 1 : 0.5;

		var sel:FlxText = labels[current];
		if (sel == null) return;
		highlight.setPosition(sel.x - 12, 6);
		highlight.setGraphicSize(Std.int(sel.width + 24), 44);
		highlight.updateHitbox();
		highlight.setPosition(sel.x - 12, 6);
		highlight.alpha = focused ? 0.45 : 0.2;
	}

	function set_focused(value:Bool):Bool
	{
		focused = value;
		if (arrowLeft != null)
		{
			arrowLeft.visible = arrowRight.visible = value;
			updateTabs();
		}
		return value;
	}

	/** -1 = previous category, 1 = next category, 0 = nothing pressed */
	public static function pollSwitch(allowShoulders:Bool = false):Int
	{
		if (FlxG.keys.justPressed.PAGEUP) return -1;
		if (FlxG.keys.justPressed.PAGEDOWN) return 1;
		if (allowShoulders)
		{
			if (FlxG.gamepads.anyJustPressed(LEFT_SHOULDER)) return -1;
			if (FlxG.gamepads.anyJustPressed(RIGHT_SHOULDER)) return 1;
		}
		return 0;
	}
}
