package;

import Reflect;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import lime.app.Application;
import lime.app.Event;
import openfl.system.Capabilities;

class OptionsInfo
{
	public var displayMode(default, set):String = "Borderless";
	public var antiAliasing(default, set):Bool = true;
	public var volume(default, set):Int = 100;

	function set_displayMode(s:String):String
	{
		#if desktop
		switch (s)
		{
			case "Fullscreen":
				Application.current.window.fullscreen = true;
				Application.current.window.borderless = false;
			case "Borderless":
				Application.current.window.fullscreen = false;
				Application.current.window.borderless = true;
				Application.current.window.resize(Std.int(Capabilities.screenResolutionX), Std.int(Capabilities.screenResolutionY));
				Application.current.window.move(0, 0);
			case "Window":
				Application.current.window.borderless = false;
				Application.current.window.fullscreen = false;
		}
		#end

		displayMode = s;
		return s;
	}

	function set_antiAliasing(bool:Bool):Bool
	{
		FlxSprite.defaultAntialiasing = bool;
		antiAliasing = bool;
		return bool;
	}

	function set_volume(n:Int):Int
	{
		volume = n;
		return n;
	}

	public function new() {}
}

class Preferences
{
	public static var config:OptionsInfo;

	public static var save:FlxSave;

	public static function initialize():Void
	{
		save = new FlxSave();
		save.bind("Minigame");

		config = new OptionsInfo();

		getSave();
	}

	public static function saveData():Void
	{
		save.data.displayMode = config.displayMode;
		save.data.antiAliasing = config.antiAliasing;
		save.data.volume = config.volume;

		save.flush();
	}

	public static function getSave():Void
	{
		if (save.data.displayMode != null)
		{
			config.displayMode = save.data.displayMode;
		}
		if (save.data.antiAliasing != null)
		{
			config.antiAliasing = save.data.antiAliasing;
		}
		if (save.data.volume != null)
		{
			config.volume = save.data.volume;
		}
	}

	public static function saveObject(tag:String, object:Dynamic):Void
	{
		Reflect.setProperty(save, 'data.$tag', object);
	}

	/*
		retireves an object from save
		if object doesn't exists returns null
	 */
	public static function getObjectSave(tag:String):Dynamic
	{
		if (Reflect.hasField(save, 'data$tag'))
		{
			return Reflect.getProperty(save, 'data.$tag');
		}
		else
		{
			return null;
		}
	}
}
