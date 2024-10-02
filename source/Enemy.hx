package;

import flixel.util.FlxColor;

enum EnemyType {
    ENEMY;
    BOSS;
}

class Enemy extends FlxSprite {

    public static var enemyColor:FlxColor = FlxColor.fromRGB(255, 124, 124);

    public var health(default, set):Int;

    private function set_health(numb:Int):Int {
        health = numb;
        if (health <= 0)
        {
            PlayState.instance.levelBar.addEXP(exp);
            exists = false;
            alive = false;
            destroy();
        }
        return numb;
    }

    public var damage:Int;
    public var type:EnemyType;
    public var fullyAppeared:Bool = false;
    public var score:Int;
    public var exp:Int;

    public function new(x:Float = 0, y:Float = 0, health:Int = 5, damage:Int = 10, type:EnemyType = ENEMY, score:Int = 100, exp:Int = 50) {
        super(x, y);

        this.damage = damage;
        this.health = health;
        this.type = type;
        this.score = score;
        this.exp = exp;

        makeGraphic(40, 40, enemyColor);
        alpha = 0;
        FlxTween.tween(this, {alpha: 1}, 1, {type: ONESHOT, ease: FlxEase.sineIn, onComplete: function (_) {
            fullyAppeared = true;
        }});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

      if (fullyAppeared)
      {
        angle = FlxAngle.angleBetween(this, PlayState.instance.player, true);
        FlxVelocity.moveTowardsObject(this, PlayState.instance.player, PlayState.enemySpeed);
      }
    }

    public function hurt(bullet:Bullet):Void {
        if (!bullet.enemiesHitted.contains(this))
        {
            bullet.enemiesHitted.push(this);
            health -= bullet.damage;
            bullet.pierce -= 1;

            var text = new FlxText(x, y, 1, '-${bullet.damage}', 10);
            text.wordWrap = false;
            text.autoSize = true;
            text.color = FlxColor.fromRGB(255, 84, 84);
            PlayState.instance.add(text);

			FlxG.sound.play("hurt", FlxG.sound.volume);

            FlxTween.tween(text, {alpha: 0, y: text.y - 50}, 1, {type: ONESHOT, ease: FlxEase.smoothStepIn, onComplete: function (_) {
                text.visible = false;
                text.destroy();
            }});
        }
    }
}