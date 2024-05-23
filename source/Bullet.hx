package;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;

class Bullet extends FlxBullet {

    public var pierce(default, set):Int = 1;
    public var parent:FlxTypedWeapon<Bullet>;
    private function set_pierce(numb:Int):Int {
        pierce = numb;
        if (pierce <= 0)
        {
            exists = false;
            destroy();
            if (parent != null)
            {
                parent.group.remove(this, true);
            }
        }
        return numb;
    }
    public var damage:Int = 5;
    public var enemiesHitted:Array<FlxObject> = [];

    public function new(?parent:FlxTypedWeapon<Bullet>) {
        super();

        this.parent = parent;
    }
}