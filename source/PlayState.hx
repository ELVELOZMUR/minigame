package;

import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;

class PlayState extends FlxState
{

	public var player:Player;

	var enemies:FlxTypedSpriteGroup<Enemy>;

	public static var enemySpawnTime = 1.5;
	public static var enemySpeed = 300;
	public var score = 0;
	public static var randomAngle = 20;
	var timeText:FlxText;

	var scoreText:FlxText;
	var tween:FlxTween = null;
	public var levelBar:Level;

	public static var instance:PlayState;

	override public function create()
	{
		super.create();

		bgColor = FlxColor.fromRGB(23, 21, 21);
		instance = this;

		enemies = new FlxTypedSpriteGroup<Enemy>();
		add(enemies);

		player = new Player();
		add(player);

		scoreText = new FlxText(20, 20, 600, 'SCORE: $score', 20);
		scoreText.wordWrap = false;
		scoreText.autoSize = true;
		scoreText.antialiasing = true;
		add(scoreText);

		levelBar = new Level();
		add(levelBar);

		timeText = new FlxText(0, 0, FlxG.width, "0", 20);
		timeText.alignment = CENTER;
		timeText.screenCenter(X);
		add(timeText);
	}

	var time = 0.0;
	var time2 = 0.0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (player.health <= 0)
		{
			die();
		}

		time += elapsed;
		time2 += elapsed;

		timeText.text = FlxStringUtil.formatTime(time2, false);

		if (time >= enemySpawnTime - Math.log(time2) / 5)
		{
			var enemy = new Enemy(FlxG.random.int(-100, FlxG.width + 100), FlxG.random.int(-100, FlxG.height + 100),
				Math.log(time2) / 10 > 1 ? Math.ceil(5 * Math.log(time2) / 5) : 5, 10);
			enemies.add(enemy);
			time = 0;
		}

		for (weapon in player.weapons)
		{
			weapon.bulletsOverlap(enemies, function (a, b) {
				if (cast(a, Enemy).fullyAppeared)
				{
					cast(a, Enemy).hurt(cast(b, Bullet));
					if (!a.alive)
					{
						enemies.remove(cast(a, Enemy), true);
					}
		
					scorePop(cast(a, Enemy).score);
				}
			});
		}


		FlxG.collide(player, enemies, function (a, b) {
			player.hurt(cast(b, Enemy).damage);
		});

	}

	override function onResize(Width:Int, Height:Int)
	{
		super.onResize(Width, Height);

		timeText.screenCenter(X);
		levelBar.bar.bar.y = Height - levelBar.bar.bar.height;
		levelBar.bar.bg.y = Height - levelBar.bar.bg.height;
		levelBar.text.y = Height - levelBar.bar.bar.height + (levelBar.bar.height / 2 - levelBar.text.height / 2);
		levelBar.text.screenCenter(X);
		FlxG.worldBounds.set(0, 0, Width, Height);
		levelBar.bar.bg.makeGraphic(Width, 20, Bar.color2);
		levelBar.bar.bar.makeGraphic(Math.ceil((Width / levelBar.bar.max) * levelBar.bar.value), 20, Bar.color1);
		levelBar.bar.width = Width;
		player.screenCenter();
		for (weapon in player.weapons)
		{
			weapon.bounds.set(0, 0, Width, Height);
		}

		if (subState != null)
			subState.onResize(Width, Height);
	}

	function die() {
		for (weapon in player.weapons)
		{
			weapon.group.forEach(function(_)
			{
				_.destroy();
			}, true);
			weapon.group.clear();
		}
		if (subState != null)
			closeSubState();
		
		FlxG.switchState(Menu.new);
	}

	function scorePop(scar:Int) {
		score += scar;
		scoreText.text = 'Score: $score';
		scoreText.scale.set(1.2, 1.2);
		scoreText.angle = FlxG.random.int(-randomAngle, randomAngle);
		if (tween != null) tween.cancel();
		tween = FlxTween.tween(scoreText, {"scale.x": 1, "scale.y": 1}, 1, {type: ONESHOT, ease: FlxEase.smoothStepInOut, onComplete: function (_) {
			tween = null;
		}});
	}
}
