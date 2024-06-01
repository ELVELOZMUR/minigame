package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class Check extends FlxTypedSpriteGroup<FlxSprite>
{
	var bg:FlxSprite;
	var check1:FlxSprite;
	var check2:FlxSprite;
	var checked:Bool;

	var variableToSet:String;

	public function new(x:Float = 0, y:Float = 0, size:Int, color:FlxColor, variableToSet:String, ?text:String)
	{
		super(0, 0);

		checked = Reflect.field(Preferences.config, variableToSet);
		var alpha = 0;
		if (checked)
			alpha = 1;

		this.variableToSet = variableToSet;

		bg = new FlxSprite(x, y);
		bg.makeGraphic(size, size, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(bg, 0, 0, size, size, 10, 10, color);
		add(bg);

		check1 = new FlxSprite(x + 10, bg.y);
		check1.makeGraphic(Math.ceil(size / 2), size, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(check1, 0, 0, size / 4, size, 10, 10, FlxColor.WHITE);
		check1.alpha = alpha;
		check1.angle = 45;
		add(check1);

		check2 = new FlxSprite(x + 10, bg.y);
		check2.makeGraphic(Math.ceil(size / 2), size, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(check2, 0, 0, size / 4, size, 10, 10, FlxColor.WHITE);
		check2.alpha = alpha;
		check2.angle = -45;
		add(check2);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(bg, camera))
		{
			if (FlxG.mouse.justPressed)
			{
				if (checked)
				{
					checked = false;
					Reflect.setField(Preferences.config, variableToSet, checked);
					check1.alpha = 0;
					check2.alpha = 0;
					onChange(checked);
				}
				else
				{
					checked = true;
					Reflect.setField(Preferences.config, variableToSet, checked);
					check1.alpha = 1;
					check2.alpha = 1;
					onChange(checked);
				}
			}
		}
	}

	public dynamic function onChange(bool:Bool) {}
}