package;

import Player.Modifier;
import Weapon.Directions;
import Weapon.WeaponStats;
import Weapon.WeaponType;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;
import flixel.util.typeLimit.OneOfTwo;

class LevelUpSubstate extends FlxSubState {

    public function new() {
        super();
    }

	var weaponNames:Array<String> = [
		"Gun",
		"Shotgun?",
		"Idk",
		"*Insert gun name*",
		"PotATo",
		"Tomato",
		"Real Gun!!1",
		"Cheese",
		"Im out of name ideas"
	];

	var modifiers:Array<String> = [
		"HEALTH",
		"SPEED",
		"DAMAGE",
		"FIRERATE",
		"PRECISION",
		"BULLETSPEED",
		"BULLETSIZE",
		"MULTISHOTS"
	];

	var buttons:Array<Button> = [];
	var bgs:Array<FlxSprite> = [];
	var texts:Array<FlxText> = [];

	var choiceQuantity:Int = 4;

	var bg:FlxSprite;

    override function create() {
		super.create();

		bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.8;
		add(bg);

		inline generateChoices();
	}

	function generateChoices():Void
	{
		// destroys old buttons
		for (button in buttons)
		{
			button.visible = false;
			button.destroy();
		}

		// destroys old texts
		for (text in texts)
		{
			text.visible = false;
			text.destroy();
		}
		for (bg in bgs)
		{
			bg.visible = false;
			bg.destroy();
		}
		// empties the array
		bgs = [];

		// empties the array
		texts = [];

		// empties the array
		buttons = [];

		//generates the ney stuff
		for (i in 0...choiceQuantity)
		{
			//gets a 50 - 50 bool if true is a Weapon else a Modifier
			if (FlxG.random.bool())
			{
				var stats = giveWeaponStats();
				genText(stats, i);
			}
			else
			{
				var mod = giveModifier();
				genText(mod, i);
			}
		}
	}

	function genText(data:OneOfTwo<Weapon, Modifier>, i:Int) {
		if ((data is Weapon))
		{
			var bg = new FlxSprite(camera.viewX + camera.viewWidth / choiceQuantity * i, camera.viewY + 50);
			bg.makeGraphic(Math.ceil(FlxG.width/choiceQuantity), FlxG.height - 100, FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawRoundRect(bg, 0, 0, FlxG.width/choiceQuantity, FlxG.height - 100, 20, 20, FlxColor.GRAY);
			bg.alpha = 0.6;
			add(bg);
			bgs.push(bg);
			
			var text = new FlxText(bg.x + 10, bg.y, bg.width,
				'Name: ${cast (data, Weapon).name}\nPrecision: ${cast (data, Weapon).stats.precision}\nDamage: ${cast (data, Weapon).stats.damage}\nFire Rate: ${(cast(data, Weapon).stats.fireRate / 1000)}\nBullet per shot: ${cast (data, Weapon).stats.multishot}\nBullet Size: ${FlxMath.roundDecimal(cast(data, Weapon).stats.bulletSize, 1)}\nBullet Speed: ${cast (data, Weapon).stats.bulletSpeed}\nPassive: ${cast (data, Weapon).stats.passive}',
			16);
			text.color = FlxColor.BLACK;
			add(text);
			texts.push(text);

			var button = new Button(text.x, text.y + text.height + 5, Math.ceil(bg.width) - 50, 50, Enemy.enemyColor, "Choose Weapon");
			button.onClick = function () {
				_parentState.closeSubState();
				trace(cast(data, Weapon).stats);
				PlayState.instance.player.addWeapon(data);
			} 
			add(button);
			buttons.push(button);
		}
		else
		{
			var bg = new FlxSprite(camera.viewX + camera.viewWidth / choiceQuantity * i, camera.viewY + 50);
			bg.makeGraphic(Math.ceil(FlxG.width / choiceQuantity), FlxG.height - 100, FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawRoundRect(bg, 0, 0, Math.ceil(FlxG.width / choiceQuantity), FlxG.height - 100, 20, 20, FlxColor.GRAY);
			bg.alpha = 0.6;
			add(bg);
			bgs.push(bg);
			
			var text = new FlxText(bg.x + 10, bg.y, bg.width, '${cast (data, Modifier).getName()}: ${cast (data, Modifier).getParameters()}', 16);
			text.color = FlxColor.BLACK;
			add(text);
			texts.push(text);

			var button = new Button(text.x, text.y + text.height + 5, Math.ceil(bg.width) - 50, 50, Enemy.enemyColor, "Choose Modifier");
			button.onClick = function () {
				_parentState.closeSubState();
				trace(cast(data, Modifier));
				PlayState.instance.player.addModifier(data);
			} 
			add(button);
			buttons.push(button);
		}
	}
	
	function giveWeaponStats():Weapon
	{
		var wep = ["PISTOL", "SHOTGUN", "RIFLE", "DIRECTIONAL"];
		var name = wep[FlxG.random.int(0, wep.length - 1)];
		var type = WeaponType.createByName(name, name == "DIRECTIONAL" ? [[0.0]] : null);

		switch (type)
		{
			case SHOTGUN:
				var stats:WeaponStats = {
					precision: FlxG.random.int(0, 40),
					bulletSpeed: FlxG.random.int(50, 200),
					damage: FlxG.random.int(10, 20),
					fireRate: FlxG.random.int(1000, 3000),
					bulletSize: FlxG.random.float(0.9, 1.1),
					multishot: FlxG.random.int(3, 6),
					passive: false,
					type: SHOTGUN
				}
				return new Weapon(weaponNames[FlxG.random.int(0, weaponNames.length - 1)],
				function (_) {
					var bullet = new Bullet(_);
					bullet.makeGraphic(20, 10, FlxColor.fromRGB(239, 255, 124));
					bullet.scale.set(cast(_, Weapon).stats.bulletSize, cast(_, Weapon).stats.bulletSize);
					bullet.updateHitbox();
					bullet.damage = cast(_, Weapon).stats.damage;
					PlayState.instance.add(bullet);
					return bullet;
				},
				PARENT(PlayState.instance.player, new FlxBounds(new FlxPoint(20 / 2, 20 / 2), new FlxPoint(20 / 2, 20 / 2)), true),
				SPEED(new FlxBounds(stats.bulletSpeed, stats.bulletSpeed)), stats);
	
			case PISTOL:
				var stats:WeaponStats = {
					precision: FlxG.random.int(0, 30),
					bulletSpeed: FlxG.random.int(50, 200),
					damage: FlxG.random.int(5, 15),
					fireRate: FlxG.random.int(800, 2000),
					bulletSize: FlxG.random.float(0.7, 1.1),
					multishot: 1,
					passive: false,
					type: PISTOL
				}
				return new Weapon(weaponNames[FlxG.random.int(0, weaponNames.length - 1)],
				function (_) {
					var bullet = new Bullet(_);
					bullet.makeGraphic(20, 10, FlxColor.fromRGB(239, 255, 124));
					bullet.scale.set(cast(_, Weapon).stats.bulletSize, cast(_, Weapon).stats.bulletSize);
					bullet.updateHitbox();
					bullet.damage = cast(_, Weapon).stats.damage;
					PlayState.instance.add(bullet);
					return bullet;
				},
				PARENT(PlayState.instance.player, new FlxBounds(new FlxPoint(20 / 2, 20 / 2), new FlxPoint(20 / 2, 20 / 2)), true),
				SPEED(new FlxBounds(stats.bulletSpeed, stats.bulletSpeed)), stats);
			case RIFLE:
				var stats:WeaponStats = {
					precision: FlxG.random.int(0, 20),
					bulletSpeed: FlxG.random.int(50, 300),
					damage: FlxG.random.int(10, 15),
					fireRate: FlxG.random.int(200, 2000),
					bulletSize: FlxG.random.float(0.8, 1.2),
					multishot: 1,
					passive: false,
					type: RIFLE
				}
				return new Weapon(weaponNames[FlxG.random.int(0, weaponNames.length - 1)],
				function (_) {
					var bullet = new Bullet(_);
					bullet.makeGraphic(20, 10, FlxColor.fromRGB(239, 255, 124));
					bullet.scale.set(cast(_, Weapon).stats.bulletSize, cast(_, Weapon).stats.bulletSize);
					bullet.updateHitbox();
					bullet.damage = cast(_, Weapon).stats.damage;
					PlayState.instance.add(bullet);
					return bullet;
				},
				PARENT(PlayState.instance.player, new FlxBounds(new FlxPoint(20 / 2, 20 / 2), new FlxPoint(20 / 2, 20 / 2)), true),
				SPEED(new FlxBounds(stats.bulletSpeed, stats.bulletSpeed)), stats);
	
			case DIRECTIONAL(directions):
				var stats:WeaponStats = {
					precision: FlxG.random.int(0, 10),
					bulletSpeed: FlxG.random.int(50, 200),
					damage: FlxG.random.int(5, 10),
					fireRate: FlxG.random.int(500, 2000),
					bulletSize: FlxG.random.float(0.8, 1),
					multishot: FlxG.random.int(1, 2),
					passive: true,
					type: DIRECTIONAL(Directions.getBySides(FlxG.random.bool(50), FlxG.random.bool(50), FlxG.random.bool(50), FlxG.random.bool(50),
						FlxG.random.bool(50), FlxG.random.bool(50), FlxG.random.bool(50), FlxG.random.bool(50)))
				}
				return new Weapon(weaponNames[FlxG.random.int(0, weaponNames.length - 1)],
				function (_) {
					var bullet = new Bullet(_);
					bullet.makeGraphic(20, 10, FlxColor.fromRGB(239, 255, 124));
					bullet.scale.set(cast(_, Weapon).stats.bulletSize, cast(_, Weapon).stats.bulletSize);
					bullet.updateHitbox();
					bullet.damage = cast(_, Weapon).stats.damage;
					PlayState.instance.add(bullet);
					return bullet;
				},
				PARENT(PlayState.instance.player, new FlxBounds(new FlxPoint(20 / 2, 20 / 2), new FlxPoint(20 / 2, 20 / 2)), true),
				SPEED(new FlxBounds(stats.bulletSpeed, stats.bulletSpeed)), stats);
		}
	}

	function giveModifier():Modifier
	{
		var modName = modifiers[FlxG.random.int(0, modifiers.length - 1)];
		switch (modName) 
		{
			case "HEALTH":
				return Modifier.createByName(modName, [FlxG.random.int(10, 100)]);
			case "SPEED":
				return Modifier.createByName(modName, [FlxG.random.int(10, 50)]);
			case "DAMAGE":
				return Modifier.createByName(modName, [FlxG.random.int(5, 50)]);
			case "FIRERATE":
				return Modifier.createByName(modName, [FlxG.random.int(10, 150)]);
			case "PRECISION":
				return Modifier.createByName(modName, [FlxG.random.int(1, 10)]);
			case "BULLETSPEED":
				return Modifier.createByName(modName, [FlxG.random.int(10, 50)]);
			case "BULLETSIZE":
				return Modifier.createByName(modName, [FlxG.random.float(0.1, 0.2)]);
			case "MULTISHOTS":
				return Modifier.createByName(modName, [FlxG.random.int(1, 3)]);
			default:
				return Modifier.createByName(modName, [FlxG.random.int(10, 100)]);
		}
	}
}
