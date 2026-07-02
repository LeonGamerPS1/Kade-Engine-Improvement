package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import haxe.io.Path;

class LoadingState extends MusicBeatState
{
	var target:FlxState;

	function new(target:FlxState, stopMusic:Bool = true)
	{
		super();
		this.target = target;
	}

	override function create()
	{
		loadAndSwitchState(target);
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		Paths.setCurrentLevel("week" + PlayState.storyWeek);
		FlxG.switchState(target);
	}
}
