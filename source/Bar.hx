package;

import flixel.util.FlxColor;

class Bar extends FlxSpriteGroup {

    public static var color1:FlxColor = FlxColor.fromRGB(44, 26, 64);
    public static var color2:FlxColor = FlxColor.BLACK;

    var bg:FlxSprite;
    var bar:FlxSprite;

    public var value(default, set):Float;
    private function set_value(numb:Float) {
        value = numb;

        if (value < min)
            value = min;
        else if (value > max)
            value = max;

        if (bar != null)
            bar.makeGraphic(Math.ceil((width / max) * numb), Math.ceil(height), color1);

        trace(value);

        return numb;
    }
    public var min:Float = 0;
    public var max(default, set):Float = 100;
    private function set_max(numb:Float) {
        max = numb;

        if (max <= min)
        {
            #if FLX_DEBUG
                FlxG.log.error("ERROR: Max is less or equal to min. moving one number up");
            #end
            trace("ERROR: Max is less or equal to min. moving one number up");

            max++;
        }

        if (bar != null)
            bar.makeGraphic(Math.ceil((width / max) * numb), Math.ceil(height), color1);

        return numb;
    }

    var parentRef:Dynamic;
    var variable:String;

    public function new(x:Float = 0, y:Float = 0, height:Int, width:Int, min:Float, max:Float, parentRef:Dynamic, variable:String) {
        super();

        bg = new FlxSprite(x, y);
        bg.makeGraphic(width, height, color2);
        add(bg);

        this.parentRef = parentRef;
        this.variable = variable;

        this.height = height;
        this.width = width;

        value = Reflect.getProperty(parentRef, variable);
        
        bar = new FlxSprite(x, y);
        bar.makeGraphic(Math.ceil((width / max) * value), height, color1);
        add(bar);

        this.min = min;
        this.max = max;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Reflect.getProperty(parentRef, variable) != value)
            value = Reflect.getProperty(parentRef, variable);
    }
}