package;

import Bullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.effects.FlxFlicker;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.util.helpers.FlxBounds;

class Player extends FlxSprite {
    public var health:Int = 100;

    public var speed:Int = 200;
    public var weapons:Array<FlxTypedWeapon<Bullet>> = [];
    public var hurtCooldown:Float = 1;

    public function new(x:Float = 0, y:Float = 0) {
        super(x, y);

        makeGraphic(20, 20, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawTriangle(this, 0, 0, 20, FlxColor.fromRGB(124, 124, 255));
        #if desktop
            angle = FlxAngle.degreesBetweenMouse(this);
        #end
		updateHitbox();
		screenCenter();

        var weapon = new FlxTypedWeapon<Bullet>("gun",
		function (_) {
            var bullet = new Bullet(_);
			bullet.makeGraphic(20, 10, FlxColor.fromRGB(239, 255, 124));
			PlayState.instance.add(bullet);
			return bullet;
		},
		PARENT(this, new FlxBounds(new FlxPoint(0, 0), new FlxPoint(0, 0)), true, 20),
		SPEED(new FlxBounds(300.0, 300.0)));
		weapon.fireRate = 500;

        weapons.push(weapon);
    }

    var time = 0.0;

    override function update(elapsed:Float) {
        super.update(elapsed);

        time += elapsed;

        #if dekstop
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
                    if (weapon.fireAtMouse())
                    {
                        weapon.currentBullet.angle = FlxAngle.degreesBetweenMouse(weapon.currentBullet);
                    }
                }
            }
        #end
    }

    public function hurt(damageTaken:Int) {
        if (time >= hurtCooldown)
        {
            health -= damageTaken;
            time = 0;
            FlxFlicker.flicker(this, hurtCooldown, 0.1, true, false);
        }

    }
    
}