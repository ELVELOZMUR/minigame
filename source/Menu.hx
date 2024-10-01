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

		camera.focusOn(new FlxPoint(FlxG.width / 2, FlxG.height / 2));

		Preferences.initialize();

		FlxG.keys.preventDefaultKeys = [W, A, S, D];
		Application.current.window.setMinSize(FlxG.width, FlxG.height);

		bgColor = FlxColor.fromRGB(23, 21, 21);

		#if !mobile
		var startButton = new Button(50, FlxG.height / 2 - 75, 400, 150, FlxColor.fromRGB(124, 124, 255), "Press anywhere to start");
		startButton.onClick = function()
		{
			FlxG.switchState(PlayState.new);
		}
		add(startButton);
		#end

		#if mobile
		text = new FlxText(0, 0, 200, "This device is not supported, sorry!", 20);
        text.autoSize = true;
        text.wordWrap = false;
        text.alpha = 0;
        text.color = FlxColor.fromRGB(124, 124, 255);
        text.screenCenter();
        add(text);

        FlxTween.tween(text, {alpha: 1}, 5, {type: PINGPONG, ease: FlxEase.sineInOut});
		#end

		FlxG.sound.cacheAll();
		FlxG.sound.playMusic("potatoGame", Preferences.config.volume / 100, true);
	}
}