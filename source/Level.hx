package;

import Bar;
import flixel.util.FlxColor;

class Level extends FlxSpriteGroup {

    var bar:Bar;
    public static var baseLevel = 500;
    public var currentEXP = 0;
    public var currentLevel = 1;
    public var levelLimit = Math.ceil(FlxMath.roundDecimal(baseLevel * Math.log(2), 1));
    var text:FlxText;

    public function new() {
        
        super();

        bar = new Bar(0, FlxG.height - 20, 20, FlxG.width, 0, levelLimit, this, "currentEXP");
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
            levelLimit = Math.ceil(FlxMath.roundDecimal(baseLevel * Math.log(currentLevel + 1), 1));
            bar.max = levelLimit;
            text.text = '$currentEXP / $levelLimit';
            levelUp();
        }
    }

    public function levelUp() {
        PlayState.instance.openSubState(new LevelUpSubstate());
    }
}