package;

import flixel.input.keyboard.FlxKey;

class StartupState extends MusicBeatState
{
	override public function create():Void
	{
		// Skip startup immediately
		FlxG.switchState(new TitleState());
	}

	override function update(elapsed:Float)
	{
		// Prevent any key inputs or update logic
	}
}
