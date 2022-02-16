package;

import meta.state.TitleState;
import meta.DisplayCounters;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;

	/*Information about the new Folder System 
	new states always go to "meta/state", if they aren't there
	files will try to read them on the Source folder, they may fail on doing so
	almost every file has at least PlayState imported, so it's not a big deal
	for starters, create a new State inside "meta/state" then on the targets
	add "import meta.state.YourState;" anywhere on the imports
	it should work without any problems, but in case you get 1 or more errors about
	other States being missing, try to import them too, or just import
	the entire state directory with "import meta.state.*"
	
	more files will be moved to these folders eventually*/

class Main extends Sprite
{
	public static var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	public static var mainClassState:Class<FlxState> = TitleState; // Determine the main class state of the game
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		#if !debug
		initialState = TitleState;
		#end
	
		ClientPrefs.loadDefaultKeys();
		// fuck you, persistent caching stays ON during sex
		FlxGraphic.defaultPersist = true;
		// the reason for this is we're going to be handling our own cache smartly
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		var displaycounters:DisplayCounters = new DisplayCounters(10, 3, 0xFFFFFF);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		#end

		#if !debug
		addChild(displaycounters);
		if (displaycounters != null)
		{
			displaycounters.visible = ClientPrefs.showFPS;
		}
		#end
	}
}
