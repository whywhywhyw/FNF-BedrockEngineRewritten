package;

import meta.Controls;
import meta.state.*;
import meta.data.Achievements;
import meta.data.PlayerSettings;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var controllerMode:Bool = false;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	
	public static var ratingOffset:Int = 0;
	public static var marvelousWindow:Int = 25;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	// Added by Bedrock Engine
	public static var maxOptimization:Bool = false;
	public static var playMissSounds:Bool = true;
	public static var playHitSounds:Bool = false;
	public static var lightcpustrums:Bool = true;
	public static var hideGf:Bool = false;
	public static var timeBarUi:String = 'Psych Engine';
	public static var lowEndMode:Bool = false;
	public static var strumLineAlpha:Float = 1;
	public static var underlay:Float = 0;
	public static var keAccuracy:Bool = false;
	public static var noteGlow:Bool = false;
	public static var instantRespawn:Bool = false;
	public static var letterGrades:Bool = true;
	public static var showSongDisplay:Bool = true;
	public static var showWatermarks:Bool = true;
	public static var judgCounter:Bool = true;
	public static var maniaMode:Bool = false;
	public static var bgAlpha:Float = 0;
	public static var dynamicCam:Bool = false;
	public static var useClassicSongs:Bool = false;
	public static var ratingSystem:String = 'Bedrock';
	public static var autoPause:Bool = true;

	// Added by Bedrock Engine (via Pull Requests)
	public static var marvelouses:Bool = true;
	public static var watermarkPreferences:String = 'Both';

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;

		// Added by Bedrock Engine 
		FlxG.save.data.maxOptimization = maxOptimization;
		FlxG.save.data.playMissSounds = playMissSounds;
		FlxG.save.data.playHitSounds = playHitSounds;
		FlxG.save.data.lightcpustrums = lightcpustrums;
		FlxG.save.data.hideGf = hideGf;
		FlxG.save.data.lowEndMode = lowEndMode;
		FlxG.save.data.strumLineAlpha = strumLineAlpha;
		FlxG.save.data.timeBarUi = timeBarUi;
		FlxG.save.data.underlay = underlay;
		FlxG.save.data.keAccuracy = keAccuracy;
		FlxG.save.data.noteGlow = noteGlow;
		FlxG.save.data.instantRespawn = instantRespawn;
		FlxG.save.data.letterGrades = letterGrades;
		FlxG.save.data.showSongDisplay = showSongDisplay;
		FlxG.save.data.showWatermarks = showWatermarks;
		FlxG.save.data.judgCounter = judgCounter;
		FlxG.save.data.maniaMode = maniaMode;
		FlxG.save.data.bgAlpha = bgAlpha;
		FlxG.save.data.dynamicCam = dynamicCam;
		FlxG.save.data.useClassicSongs = useClassicSongs;
		FlxG.save.data.ratingSystem = ratingSystem;
		FlxG.save.data.autoPause = autoPause;

		// Added by Bedrock Engine (via Pull Requests)
		FlxG.save.data.marvelousWindow = marvelousWindow;
		FlxG.save.data.marvelouses = marvelouses;
		FlxG.save.data.watermarkPreferences = watermarkPreferences;

		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
			if(Main.fpsVar != null) {
				Main.fpsVar.visible = showFPS;
			}
		}
		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}
		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}
		/*if(FlxG.save.data.cursing != null) {
			cursing = FlxG.save.data.cursing;
		}
		if(FlxG.save.data.violence != null) {
			violence = FlxG.save.data.violence;
		}*/
		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}
		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}
		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.controllerMode != null) {
			controllerMode = FlxG.save.data.controllerMode;
		}
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		// Added by Bedrock Engine 
		if(FlxG.save.data.maxOptimization != null) {
			maxOptimization = FlxG.save.data.maxOptimization;
		}
		if (FlxG.save.data.playHitSounds != null) {
			playHitSounds = FlxG.save.data.playHitSounds;
		}
		if (FlxG.save.data.playMissSounds != null) {
			playMissSounds = FlxG.save.data.playMissSounds;
		}
		if (FlxG.save.data.lightcpustrums != null) {
			lightcpustrums = FlxG.save.data.lightcpustrums;
		}
		if (FlxG.save.data.hideGf != null) {
			hideGf = FlxG.save.data.hideGf;
		}
		if (FlxG.save.data.lowEndMode != null) {
			lowEndMode = FlxG.save.data.lowEndMode;
		}
		if (FlxG.save.data.strumLineAlpha != null) {
			strumLineAlpha = FlxG.save.data.strumLineAlpha;
		}
		if (FlxG.save.data.timeBarUi != null) {
			timeBarUi = FlxG.save.data.timeBarUi;
		}
		if (FlxG.save.data.noteGlow != null) {
			noteGlow = FlxG.save.data.noteGlow;
		}
		if (FlxG.save.data.underlay != null) {
			underlay = FlxG.save.data.underlay;
		}
		if (FlxG.save.data.keAccuracy != null) {
			keAccuracy = FlxG.save.data.keAccuracy;
		}
		if(FlxG.save.data.instantRespawn != null) {
			instantRespawn = FlxG.save.data.instantRespawn;
		}
		if(FlxG.save.data.letterGrades != null) {
			letterGrades = FlxG.save.data.letterGrades;
		}
		if(FlxG.save.data.showSongDisplay != null) {
			showSongDisplay = FlxG.save.data.showSongDisplay;
		}
		if(FlxG.save.data.showWatermarks != null) {
			showWatermarks = FlxG.save.data.showWatermarks;
		}
		if(FlxG.save.data.judgCounter != null) {
			judgCounter = FlxG.save.data.judgCounter;
		}
		if(FlxG.save.data.maniaMode != null) {
			maniaMode = FlxG.save.data.judgCoumaniaModenter;
		}
		if(FlxG.save.data.bgAlpha != null) {
			bgAlpha = FlxG.save.data.bgAlpha;
		}
		if(FlxG.save.data.dynamicCam != null) {
			dynamicCam = FlxG.save.data.dynamicCam;
		}
		if(FlxG.save.data.useClassicSongs != null) {
			useClassicSongs = FlxG.save.data.useClassicSongs;
		}
		if(FlxG.save.data.ratingSystem != null) {
			ratingSystem = FlxG.save.data.ratingSystem;
		}
		if(FlxG.save.data.autoPause != null) {
			autoPause = FlxG.save.data.autoPause;
			FlxG.autoPause = autoPause;
		}
		
		// Added by Bedrock Engine (via Pull Requests)
		if(FlxG.save.data.marvelousWindow != null) {
			marvelousWindow = FlxG.save.data.marvelousWindow;
		}
		if(FlxG.save.data.marvelouses != null) {
			marvelouses = FlxG.save.data.marvelouses;
		}
		if (FlxG.save.data.watermarkPreferences != null) {
			watermarkPreferences = FlxG.save.data.watermarkPreferences;
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'ninjamuffin99');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}
	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
