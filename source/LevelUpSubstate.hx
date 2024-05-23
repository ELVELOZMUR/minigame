package;

import flixel.util.FlxColor;

class LevelUpSubstate extends FlxSubState {
    public function new() {
        super();
    }

    override function create() {
        super.create();

        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(23, 21, 21));
        bg.alpha = 0.5;
        add(bg);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        #if desktop
        if (FlxG.mouse.justPressed)
        {
            PlayState.instance.closeSubState();
        }
        #end

        #if mobile
            if (FlxG.touches.getFirst().justPressed)
            {
                PlayState.instance.closeSubState();
            }
        #end
    }
}