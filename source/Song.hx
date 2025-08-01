package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var stage:String;

	@:optional var gameOverChar:String;
	@:optional var gameOverSound:String;
	@:optional var gameOverLoop:String;
	@:optional var gameOverEnd:String;

	@:optional var disableNoteRGB:Bool;

	var songCredit:String;
	var songCreditBarPath:String;
	var songCreditIcon:String;
	var event7:String;
	var event7Value:String;

	var windowName:String;
	var specialAudioName:String;
	var specialEventsName:String;

	var arrowSkin:String;
	var splashSkin:String;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var events:Array<Dynamic>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var arrowSkin:String;
	public var splashSkin:String;
	public var gameOverChar:String;
	public var gameOverSound:String;
	public var gameOverLoop:String;
	public var gameOverEnd:String;
	public var disableNoteRGB:Bool = false;
	public var speed:Float = 1;
	public var stage:String;
	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = 'gf';

	private static function onLoadJson(songJson:Dynamic) // Convert old charts to newest format
	{
		if(songJson.gfVersion == null)
		{
			songJson.gfVersion = songJson.player3;
			songJson.player3 = null;
		}

		if(songJson.events == null)
		{
			songJson.events = [];
			for (secNum in 0...songJson.notes.length)
			{
				var sec:SwagSection = songJson.notes[secNum];

				var i:Int = 0;
				var notes:Array<Dynamic> = sec.sectionNotes;
				var len:Int = notes.length;
				while(i < len)
				{
					var note:Array<Dynamic> = notes[i];
					if(note[1] < 0)
					{
						songJson.events.push([note[0], [[note[2], note[3], note[4]]]]);
						notes.remove(note);
						len = notes.length;
					}
					else i++;
				}
			}
		}
	}

	public static function hasDifficulty(songName:String, difficulty:String):Bool
	{
		var formattedSong:String = Paths.formatToSongPath(songName);
		var formDiff:String = Paths.formatToSongPath(difficulty);
		var jsonToFind:String = Paths.json(formattedSong + '/' + formattedSong + '-' + formDiff);
		#if MODS_ALLOWED
			if (!CoolUtil.defaultSongs.contains(formattedSong) && !CoolUtil.defaultSongsFormatted.contains(formattedSong))
				jsonToFind = Paths.modsJson(formattedSong + '/' + formattedSong + '-' + formDiff); #end
		if(FileSystem.exists(jsonToFind)) return true;

		return false;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson:String = null;

		var formattedFolder:String = Paths.formatToSongPath(folder);
		var formattedSong:String = Paths.formatToSongPath(jsonInput);
		#if MODS_ALLOWED
		var moddyFile:String = Paths.modsJson('$formattedFolder/$formattedSong');
		if(FileSystem.exists(moddyFile)) {
			rawJson = File.getContent(moddyFile).trim();
		}
		#end

		if(rawJson == null) {
			var path:String = Paths.json('$formattedFolder/$formattedSong');
			#if sys
			if(FileSystem.exists(path))
				rawJson = File.getContent(path);
			else
			#end
				rawJson = Assets.getText(path);
		}

		var songJson:Dynamic = parseJSONshit(rawJson);
		if(jsonInput != 'events') StageData.loadDirectory(songJson);
		onLoadJson(songJson);
		return songJson;
	}

	public static function parseJSONshit(rawJson:String):SwagSong {
		return cast Json.parse(rawJson).song;
	}
}
