package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Menu extends FlxState{
    override function create() {
        super.create();

        FlxG.scaleMode = new flixel.system.scaleModes.FillScaleMode();

        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(23, 21, 21));
        add(bg);

        var text = new FlxText(0, 0, 200, "Press anywhere to start", 20);
        text.autoSize = true;
        text.wordWrap = false;
        text.alpha = 0;
        text.color = FlxColor.fromRGB(124, 124, 255);
        text.screenCenter();
        add(text);

        FlxTween.tween(text, {alpha: 1}, 5, {type: PINGPONG, ease: FlxEase.sineInOut});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        #if desktop
        if (FlxG.mouse.justPressed)
        {
            FlxG.switchState(PlayState.new);
        }
        #end

        #if mobile
            if (FlxG.touches.getFirst().justPressed)
            {
                FlxG.switchState(PlayState.new);
            }
        #end
    }
}