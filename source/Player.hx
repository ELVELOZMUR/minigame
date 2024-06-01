package;

import Bullet;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.helpers.FlxBounds;

class Player extends FlxSprite {
    public var health:Int = 100;

    public var speed:Int = 200;
	public var weapons:Array<Weapon> = [];
    public var hurtCooldown:Float = 1;

	public var modifiers:Array<Modifier>;

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

		modifiers = [];

        makeGraphic(20, 20, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawTriangle(this, 0, 0, 20, FlxColor.fromRGB(124, 124, 255));
        #if desktop
            angle = FlxAngle.degreesBetweenMouse(this);
        #end
		updateHitbox();
		screenCenter();

		var weapon = new Weapon("gun",
		function (_) {
            var bullet = new Bullet(_);
			bullet.makeGraphic(20, 10, FlxColor.fromRGB(239, 255, 124));
			bullet.scale.set(cast(_, Weapon).stats.bulletSize, cast(_, Weapon).stats.bulletSize);
			bullet.updateHitbox();
			bullet.damage = cast(_, Weapon).stats.damage;
			PlayState.instance.add(bullet);
			return bullet;
		},
			PARENT(this, new FlxBounds(new FlxPoint(width / 2, height / 2), new FlxPoint(width / 2, height / 2)), true), SPEED(new FlxBounds(300.0, 300.0)));
		weapon.fireRate = 1000;

		// immovable = true;

        weapons.push(weapon);
    }

    var time = 0.0;

    override function update(elapsed:Float) {
        super.update(elapsed);

        time += elapsed;

        velocity.x = 0;
		velocity.y = 0;

            angle = FlxAngle.degreesBetweenMouse(this) + 90;

		    if (FlxG.keys.pressed.W || FlxG.keys.pressed.UP)
            {
                velocity.y = -speed;
            }
            if (FlxG.keys.pressed.A || FlxG.keys.pressed.LEFT)
            {
                velocity.x = -speed;
            }
            if (FlxG.keys.pressed.S || FlxG.keys.pressed.DOWN)
            {
                velocity.y = speed;
            }
            if (FlxG.keys.pressed.D || FlxG.keys.pressed.RIGHT)
            {
                velocity.x = speed;
            }

        if (FlxG.mouse.pressed)
		{
			for (weapon in weapons)
			{
				weapon.fire();
			}
		}
	}

    public function hurt(damageTaken:Int) {
        if (time >= hurtCooldown)
        {
            health -= damageTaken;
            time = 0;
			FlxG.sound.play("hurt", Preferences.config.volume / 10, false);
            FlxFlicker.flicker(this, hurtCooldown, 0.1, true, false);
        }

    }

	public function addWeapon(weapon:Weapon)
	{
		weapons.push(weapon);
		weapons[weapons.length - 1].resetStatsAndAdd(modifiers);
	}

	public function addModifier(modifier:Modifier)
	{
		switch (modifier)
		{
			case HEALTH(health):
				health += health;
			case SPEED(speed):
				speed += speed;
			default:
				// avoids crashes and compilation errors
		}

		modifiers.push(modifier);

		for (weapon in weapons)
		{
			weapon.resetStatsAndAdd(modifiers);
		}
	}
}

enum Modifier
{
	SPEED(speed:Int);
	FIRERATE(fireRate:Int);
	PRECISION(precision:Float);
	BULLETSPEED(speed:Int);
	DAMAGE(damage:Int);
	BULLETSIZE(size:Float);
	MULTISHOTS(shots:Int);
	HEALTH(health:Int);
}