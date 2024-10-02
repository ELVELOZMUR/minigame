package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Menu extends FlxState{
	var bg:FlxSprite;
	var text:FlxText;

	var startButton:Button;
	var optionsButton:Button;

    override function create() {
        super.create();

		camera.focusOn(new FlxPoint(FlxG.width / 2, FlxG.height / 2));

		FlxG.keys.preventDefaultKeys = [W, A, S, D, ESCAPE];

		bgColor = FlxColor.fromRGB(23, 21, 21);

		FlxSprite.defaultAntialiasing = true;

		#if !mobile
		var score = FlxG.save.data.score;

		if (score != null && score != 0)
		{
			var scoreText = new FlxText(0, FlxG.height / 2 - FlxG.height / 5, FlxG.width, 'Highest score: $score', Math.ceil(FlxG.height / 30));
			scoreText.alignment = CENTER;
			add(scoreText);
		}

		startButton = new Button(FlxG.width / 2 - (Math.floor(FlxG.width / 3) / 2), FlxG.height / 2 - (Math.floor(FlxG.height / 5) / 2),
			Math.floor(FlxG.width / 3), Math.floor(FlxG.height / 5), FlxColor.fromRGB(124, 124, 255), "Start");
		startButton.onClick = function()
		{
			FlxG.switchState(PlayState.new);
		}
		add(startButton);
		// space
		var controlsText = new FlxText(0, startButton.y + FlxG.height / 4, FlxG.width, "+ or - to turn volume up or down.\n0 to mute.\nWASD to move.",
			Math.ceil(FlxG.height / 30));
		controlsText.alignment = CENTER;
		add(controlsText);
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
		FlxG.sound.playMusic("potatoGame", FlxG.sound.volume, true);
	}
}