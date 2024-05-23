package;

import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;

typedef WeaponStats =
{
    precision:Int,
    bulletSpeed:Int,
    damage:Int,
    fireRate:Int,
    bulletSize:Int,
    multishot:Int,
    passive:Bool
}

class Weapon extends FlxTypedWeapon<Bullet>{
    
}