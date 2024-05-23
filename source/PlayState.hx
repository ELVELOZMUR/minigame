package;

import flixel.util.helpers.FlxBounds;
import flixel.FlxState;
import flixel.addons.weapon.*;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
#if mobile
	import flixel.input.touch.FlxTouchManager;
	import flixel.ui.FlxAnalog;
	import flixel.ui.FlxVirtualPad;
#end

class PlayState extends FlxState
{

	public var player:Player;

	var enemies:FlxTypedSpriteGroup<Enemy>;

	public static var enemySpawnTime = 1.5;
	public static var enemySpeed = 300;
	public var score = 0;
	public static var randomAngle = 20;

	var scoreText:FlxText;
	var tween:FlxTween = null;
	public var levelBar:Level;

	public static var instance:PlayState;

	#if mobile
		public var multitouch:Bool =  FlxTouchManager.maxTouchPoints > 1 ? true : false;
        public var moveButtons:FlxVirtualPad;
        public var analog:FlxAnalog;
	#end

	override public function create()
	{
		super.create();

		bgColor = FlxColor.fromRGB(23, 21, 21);
		instance = this;

		enemies = new FlxTypedSpriteGroup<Enemy>();
		add(enemies);

		player = new Player();
		add(player);

		scoreText = new FlxText(20, 20, 600, 'Score: $score', 20);
		scoreText.wordWrap = false;
		scoreText.autoSize = true;
		scoreText.antialiasing = true;
		add(scoreText);

		levelBar = new Level();
		add(levelBar);

		#if mobile
			moveButtons = new FlxVirtualPad(FULL, A_B_X_Y);
			add(moveButtons);

			if (multitouch)
			{
				analog = new FlxAnalog(0, 0, 40, 1);
				add(analog);
			}
		#end
		
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

		if (time >= enemySpawnTime - Math.log(time2) / 100)
		{
			var enemy = new Enemy(FlxG.random.int(-100, FlxG.width + 100), FlxG.random.int(-100, FlxG.height + 100));
			enemies.add(enemy);
			time = 0;
		}

		#if mobile

			player.velocity.x = 0;
			player.velocity.y = 0;

			if (multitouch)
			{
				player.angle = analog.angle;

				if (analog.pressed)
				{
					for (weapon in player.weapons)
					{
						weapon.fireFromAngle(new FlxBounds(analog.angle, analog.angle));
					}
				}
			}
			else
			{
				var enemy = getClosestEnemy();
				if (enemy != null)
				{
					player.angle = FlxAngle.degreesBetween(player, enemy);

					for (weapon in player.weapons)
						{
							weapon.fireFromAngle(new FlxBounds(player.angle, player.angle));
						}
				}
			}

			if (moveButtons.buttonUp.pressed)
			{
				player.velocity.y = -player.speed;
			}
			if (moveButtons.buttonLeft.pressed)
			{
				player.velocity.x = -player.speed;
			}
			if (moveButtons.buttonDown.pressed)
			{
				player.velocity.y = player.speed;
			}
			if (moveButtons.buttonRight.pressed)
			{
				player.velocity.x = player.speed;
			}
		#end

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

	function die() {
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

	#if mobile
	function getClosestEnemy():Enemy {

		var enemy:Enemy;

		for (enemy in enemies.members)
		{
			if (FlxMath.distanceBetween(player, enemy) <= 100)
			{
				return enemy;
			}
		}

		return null;
	}
	#end
}
