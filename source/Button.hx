package;

class Button extends FlxGroup
{
	var bg:FlxSprite;

	public var text:FlxText;

	public var justPressed(get, null):Bool;

	var tween:FlxTween = null;
	var tween2:FlxTween = null;

	public var hovering(default, null):Bool = false;

	public var x(default, set):Float;
	public var y(default, set):Float;
	public var width(default, set):Int;
	public var height(default, set):Int;
	public var color:FlxColor;

	@:noCompletion private function set_x(xs):Float
	{
		x = xs;
		if (bg != null)
			bg.x = xs;
		if (text != null)
			text.x = xs;
		return xs;
	}

	@:noCompletion private function set_y(ys):Float
	{
		y = ys;
		if (bg != null)
			bg.y = ys;
		if (text != null)
			text.y = bg.y + bg.height / 2 - text.height / 2;
		return ys;
	}

	@:noCompletion function set_width(numb):Int
	{
		width = numb;
		if (bg != null)
		{
			bg.makeGraphic(numb, height, FlxColor.TRANSPARENT);
			bg.updateHitbox();
			FlxSpriteUtil.drawRoundRect(bg, 0, 0, numb, height, 20, 20, color);
		}
		if (text != null)
			text.fieldWidth = numb;
		return numb;
	}

	@:noCompletion function set_height(numb):Int
	{
		height = numb;
		if (bg != null)
		{
			bg.makeGraphic(width, numb, FlxColor.TRANSPARENT);
			bg.updateHitbox();
			FlxSpriteUtil.drawRoundRect(bg, 0, 0, width, numb, 20, 20, color);
		}
		if (text != null)
			text.y = bg.y + bg.height / 2 - text.height / 2;
		return numb;
	}

	@:noCompletion private function get_justPressed()
	{
		if (bg != null)
		{
			if (FlxG.mouse.overlaps(bg, camera))
			{
				if (FlxG.mouse.justPressed)
				{
					return true;
				}
			}
		}

		return false;
	}

	public function new(x:Float = 0, y:Float = 0, width:Int, height:Int, color:FlxColor, ?text:String)
	{
		super();

		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.color = color;

		bg = new FlxSprite(x, y);
		bg.makeGraphic(width, height, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRoundRect(bg, 0, 0, width, height, 20, 20, color);
		add(bg);

		if (text != null)
		{
			this.text = new FlxText(bg.x, 0, width, text, Math.ceil(height / 8));
			this.text.alignment = CENTER;
			this.text.y = bg.y + bg.height / 2 - this.text.height / 2;
			add(this.text);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(bg, camera))
		{
			if (tween != null && !hovering)
				tween.cancel();

			if (bg.scale.x != 1.1)
			{
				tween = FlxTween.tween(bg, {"scale.x": 1.1, "scale.y": 1.1}, 0.1, {
					type: ONESHOT,
					onComplete: function(_)
					{
						tween = null;
					},
					ease: FlxEase.circInOut
				});

				tween = FlxTween.tween(text, {"scale.x": 1.1, "scale.y": 1.1}, 0.1, {
					type: ONESHOT,
					onComplete: function(_)
					{
						tween2 = null;
					},
					ease: FlxEase.circInOut
				});
			}

			if (FlxG.mouse.justPressed)
			{
				onClick();
			}
			hovering = true;
		}
		else
		{
			if (bg.scale.x == 1.1)
			{
				if (tween != null && hovering)
					tween.cancel();

				tween = FlxTween.tween(bg, {"scale.x": 1, "scale.y": 1}, 0.1, {
					type: ONESHOT,
					onComplete: function(_)
					{
						tween = null;
					},
					ease: FlxEase.circInOut
				});
				tween = FlxTween.tween(text, {"scale.x": 1, "scale.y": 1}, 0.1, {
					type: ONESHOT,
					onComplete: function(_)
					{
						tween2 = null;
					},
					ease: FlxEase.circInOut
				});
			}
			hovering = false;
		}
	}

	public dynamic function onClick() {}
}