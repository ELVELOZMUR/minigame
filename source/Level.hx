package;

import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class Level extends FlxSpriteGroup {

	public var bar:FlxBar;
    public static var baseLevel = 500;
    public var currentEXP = 0;
    public var currentLevel = 1;
	public var levelLimit = baseLevel;
	public var text:FlxText;

    public function new() {
        
        super();

		bar = new FlxBar(0, FlxG.height - 20, LEFT_TO_RIGHT, FlxG.width, 20, this, "currentEXP", 0, levelLimit);
		bar.createFilledBar(FlxColor.BLACK, FlxColor.fromRGB(44, 26, 64));
		bar.alpha = 0.8;
        add(bar);

        text = new FlxText(bar.x, FlxG.height - 20, FlxG.width, '$currentEXP / $levelLimit', 10);
        text.alignment = CENTER;
        text.y += bar.height/2 - text.height/2;
        text.color = FlxColor.fromRGB(177, 105, 255);
        add(text);
    }

    public function addEXP(exp:Int):Void {
        currentEXP += exp;
        text.text = '$currentEXP / $levelLimit';
        if (currentEXP >= levelLimit)
        {
            currentEXP -= currentEXP;
            currentLevel += 1;
			levelLimit = Math.ceil(FlxMath.roundDecimal(levelLimit * 1.20, 1));
			bar.setRange(0, levelLimit);
            text.text = '$currentEXP / $levelLimit';
            levelUp();
        }
    }

	public inline function levelUp()
	{
        PlayState.instance.openSubState(new LevelUpSubstate());
    }
}