package;

class OptionsSubstate extends FlxSubState
{
	public function new()
	{
		super();
	}

	var optionsButton:Button;

	override function create()
	{
		super.create();

		var bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.8;
		add(bg);

		optionsButton = new Button(FlxG.width - 120, 20, 100, 50, Enemy.enemyColor, "Close");
		add(optionsButton);

		var antialiasing:Check = new Check(50, 50, 50, Enemy.enemyColor, "antiAliasing");
		add(antialiasing);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (optionsButton.justPressed)
		{
			_parentState.closeSubState();
		}
	}
}