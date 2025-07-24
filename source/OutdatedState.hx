package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.display.BlendMode;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	public static var currChanges:String = "dk";

	var warnText:FlxText;
	var changelog:FlxText;
	var updateText:FlxText;
	var checker:FlxBackdrop;
	var bg:FlxSprite;

	override function create()
	{
		// Prevent this screen from showing
		FlxG.switchState(new MainMenuState());
	}

	override function update(elapsed:Float)
	{
		// Do nothing
	}
}
