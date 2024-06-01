package;

import flixel.FlxState;
import flixel.system.scaleModes.*;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

class Menu extends FlxState{
	var bg:FlxSprite;
	var text:FlxText;

    override function create() {
        super.create();

		Preferences.initialize();

		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.keys.preventDefaultKeys = [W, A, S, D];
		Application.current.window.setMinSize(FlxG.width, FlxG.height);

		bgColor = FlxColor.fromRGB(23, 21, 21);

		text = new FlxText(0, 0, 200, "Press anywhere to start", 20);
        text.autoSize = true;
        text.wordWrap = false;
        text.alpha = 0;
        text.color = FlxColor.fromRGB(124, 124, 255);
        text.screenCenter();
        add(text);

		FlxG.sound.cacheAll();

		FlxG.sound.playMusic("potatoGame", Preferences.config.volume / 10, true);

        FlxTween.tween(text, {alpha: 1}, 5, {type: PINGPONG, ease: FlxEase.sineInOut});
	}

	override function onResize(Width:Int, Height:Int)
	{
		super.onResize(Width, Height);

		if (text != null)
			text.screenCenter();

		FlxG.worldBounds.set(0, 0, Width, Height);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			FlxG.switchState(PlayState.new);
		}
    }
}