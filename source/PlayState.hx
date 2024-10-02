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
	var enemyDamage = 5.0;
	var enemyHealth = 10.0;

	var scoreText:FlxText;
	/**
	 * This tween avoid crashes, it holds the score pop scale tween
	 */
	var tween:FlxTween = null;
	public var levelBar:Level;


	public static var instance:PlayState;

	override public function create()
	{
		super.create();

		bgColor = FlxColor.fromRGB(23, 21, 21);
		var camHUD = new FlxCamera(0, 0, Math.ceil(camera.viewWidth), Math.ceil(camera.viewHeight), 1);
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		instance = this;

		enemies = new FlxTypedSpriteGroup<Enemy>();
		add(enemies);

		player = new Player();
		add(player);

		scoreText = new FlxText(20, 20, 600, 'SCORE: $score', 20);
		scoreText.wordWrap = false;
		scoreText.autoSize = true;
		scoreText.antialiasing = true;
		scoreText.camera = camHUD;
		add(scoreText);

		levelBar = new Level();
		levelBar.camera = camHUD;
		add(levelBar);

		timeText = new FlxText(0, 0, FlxG.width, "0", 20);
		timeText.alignment = CENTER;
		timeText.camera = camHUD;
		timeText.screenCenter(X);
		add(timeText);
		//
		FlxG.camera.follow(player, TOPDOWN_TIGHT);
	}

	var time = 0.0;
	var time2 = 0.0;
	var tenTimes = 1.0;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.worldBounds.set(camera.viewX, camera.viewY, camera.viewWidth, camera.viewHeight);

		if (player.health <= 0)
			inline die();

		time += elapsed;
		time2 += elapsed;


		timeText.text = FlxStringUtil.formatTime(time2, false);
		tenTimes = Math.floor(time2 / 20);
		if (tenTimes < 1)
			tenTimes = 1;

		// idk anything about logs, they just seem cool
		if (time >= enemySpawnTime - Math.log(time2) / 5)
		{
			var enemy = new Enemy(FlxG.random.float(FlxG.worldBounds.x, FlxG.worldBounds.x + FlxG.worldBounds.width),
				FlxG.random.float(FlxG.worldBounds.y, FlxG.worldBounds.y + FlxG.worldBounds.height), Math.floor(Math.pow(enemyHealth, tenTimes)),
				Math.floor(Math.pow(enemyDamage, tenTimes)), ENEMY, Math.floor(100 * tenTimes));
			enemies.add(enemy);
			time = 0;
		}

		for (weapon in player.weapons)
		{
			weapon.bounds = FlxG.worldBounds;

			weapon.bulletsOverlap(enemies, function (a, b) {
				if (cast(a, Enemy).fullyAppeared)
				{
					cast(a, Enemy).hurt(cast(b, Bullet));
					if (!a.alive)
					{
						enemies.remove(cast(a, Enemy), true);
						scorePop(cast(a, Enemy).score);
					}

				}
			});
		}


		FlxG.collide(player, enemies, function (a, b) {
			player.hurt(cast(b, Enemy).damage);
		});

	}

	function die() {
		instance = null;

		for (weapon in player.weapons)
		{
			weapon.group.forEach(function(_)
			{
				_.destroy();
			}, true);
			weapon.group.clear();
			weapon = null;
		}
		player.destroy();
		levelBar.bar.destroy();

		closeSubState();
		
		if (FlxG.save.data.score != null)
		{
			FlxG.save.data.score = Math.max(score, FlxG.save.data.score);
		}
		else
			FlxG.save.data.score = score;
		FlxG.save.flush();
		FlxG.signals.preUpdate.removeAll();

		FlxG.resetGame();
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
