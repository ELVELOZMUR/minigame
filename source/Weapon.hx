package;

import Player.Modifier;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import flixel.util.helpers.FlxBounds;
import weapon.FlxWeapon;

typedef WeaponStats =
{
	precision:Float,
	bulletSpeed:Float,
    damage:Int,
    fireRate:Int,
	bulletSize:Float,
    multishot:Int,
	passive:Null<Bool>,
	type:WeaponType
}

enum WeaponType
{
	SHOTGUN;
	PISTOL;
	RIFLE;
	DIRECTIONAL(directions:Array<Float>);
}

enum abstract Directions(Float) to Float
{
	var UP = -90.0;
	var DOWN = 90.0;
	var LEFT = 180.0;
	var RIGHT = 0.0;
	var LU = -135.0;
	var RU = -45.0;
	var LD = 135.0;
	var RD = 45.0;

	public static function getBySides(up:Bool, down:Bool, left:Bool, right:Bool, lu:Bool, ru:Bool, ld:Bool, rd:Bool):Array<Float>
	{
		var array:Array<Float> = [];
		if (up)
			array.push(-90);
		if (down)
			array.push(90);
		if (left)
			array.push(180);
		if (right)
			array.push(-180);
		if (lu)
			array.push(-135);
		if (ru)
			array.push(-45);
		if (ld)
			array.push(135);
		if (rd)
			array.push(45);

		return array;
	}
}

class Weapon extends FlxTypedWeapon<Bullet>{
	var defaultStats:WeaponStats = {
		precision: 40.0,
		bulletSpeed: 200,
		damage: 5,
		fireRate: 1000,
		bulletSize: 1,
		multishot: 1,
		passive: false,
		type: PISTOL
	}

	public var stats:WeaponStats;

	public function new(name:String, bulletFactory:FlxTypedWeapon<Bullet>->Bullet, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode, ?stats:WeaponStats)
	{
		super(name, bulletFactory, fireFrom, speedMode);

		rotateBulletTowardsTarget = true;
		bulletLifeSpan = new FlxBounds(10.0, 10.0);

		if (stats != null)
		{
			this.stats = stats;
			defaultStats = stats;
		}
		else
			this.stats = defaultStats;

		fireRate = this.stats.fireRate;

		FlxG.signals.preUpdate.add(function()
		{
			if (!this.stats.passive)
				return;

			fireFromAngle(new FlxBounds((parent.angle - 90) + -stats.precision, (parent.angle - 90) + stats.precision), stats.multishot,
				Type.enumIndex(this.stats.type) == 3 ? this.stats.type.getParameters()[0] : null);
		});

		onPostFireSound = FlxG.sound.load("shoot", FlxG.sound.volume);
	}

	public function fire():Bool
	{
		if (stats.passive)
			return false;

		return fireFromAngle(new FlxBounds((parent.angle - 90) + -stats.precision, (parent.angle - 90) + stats.precision), stats.multishot,
			Type.enumIndex(this.stats.type) == 3 ? this.stats.type.getParameters()[0] : null);
	}

	public function resetStats():Void
	{
		fireRate = defaultStats.fireRate;
		speedMode = SPEED(new FlxBounds(defaultStats.bulletSpeed, defaultStats.bulletSpeed));
		stats = defaultStats;
	}

	public function resetStatsAndAdd(modifiers:Array<Modifier>)
	{
		fireRate = defaultStats.fireRate;
		stats = defaultStats;

		for (modify in modifiers)
		{
			switch (modify)
			{
				case DAMAGE(damage):
					stats.damage += damage;
				case FIRERATE(fireRate):
					stats.fireRate -= fireRate;
					if (stats.fireRate < 100)
						stats.fireRate = 100;
				case BULLETSIZE(size):
					stats.bulletSize += size;
				case MULTISHOTS(shots):
					stats.multishot += shots;
					switch (stats.type)
					{
						case PISTOL:
							if (stats.multishot > 4) stats.multishot = 4;
						case RIFLE:
							if (stats.multishot > 3) stats.multishot = 3;
						case DIRECTIONAL(directions):
							if (stats.multishot > 1) stats.multishot = 1;
						default:
					}
				case PRECISION(precision):
					precision -= precision;
					if (precision < 0)
						precision = 0;
				case BULLETSPEED(speed):
					stats.bulletSpeed += speed;
				default:
					continue;
			}
		}

		speedMode = SPEED(new FlxBounds(defaultStats.bulletSpeed, defaultStats.bulletSpeed));
	}
}