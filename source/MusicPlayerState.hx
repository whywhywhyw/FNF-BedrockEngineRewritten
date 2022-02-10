package;

// da imports
import openfl.display.Tile;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import JsonSettings;
#if MODS_ALLOWED
import sys.FileSystem;
#end

//this is literally just a copy of freeplay, feel free to use it
//a few things here were taken from Dave & Bambi, so shoutots to that mod too

using StringTools;

class MusicPlayerState extends MusicBeatState
{
	// variables
	var bg:FlxSprite;
	var colorTween:FlxTween;
	var scoreBG:FlxSprite;
	var songs:Array<MPlayerMeta> = [];

	// variable floats
	var lerpRating:Float = 0;
	var intendedRating:Float = 0;

	//timebar
	public var timeBar:FlxBar;
	public var playdist:Float = 0;
	private var timeBarBG:AttachedSprite;
	private var updateTime:Bool = true;
	var timeTxt:FlxText;
	var songLength:Float = 0;

	// variable Int
	var curDifficulty:Int = -1;
	var intendedColor:Int;
	var intendedScore:Int = 0;
	var lerpScore:Int = 0;

	// variable texts
	var scoreText:FlxText;
	var diffText:FlxText;
	var selector:FlxText;

	// private static variables
	private static var curSelected:Int = 0;
	private static var lastDifficultyName:String = '';
	public static var curPlaying:Bool = false;

	// private variables
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		Main.curStateS = 'MusicPlayerState';

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		for (i in 0...WeekData.weeksList.length)
		{
			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];
			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.setDirectoryFromWeek();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		songLength = FlxG.sound.music.length;
		//create time bar
		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText((FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.sprTracker = timeBar;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;

		if (ClientPrefs.timeBarUi == 'Kade Engine')
			timeBarBG.screenCenter(X);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		if (ClientPrefs.timeBarUi == 'Kade Engine')
			timeBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
		else
			timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; // How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;

		add(timeBar);
		add(timeBarBG);
		add(timeTxt);

        hideBar();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}
		WeekData.setDirectoryFromWeek();

		if (curSelected >= songs.length)
			curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if (lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		if (curPlaying && !JsonSettings.iconSupport)
		{
			iconArray[instPlaying].canBounce = true;
			iconArray[instPlaying].animation.curAnim.curFrame = 2;
		}

		changeSelection();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		var leText:String = "Press ACCEPT to Listen to the Song / Press CTRL to Disable Song Vocals. / Press ALT to go to Freeplay / LEFT or RIGHT to Skip/Go Back on the Song.";
		var size:Int = 14;
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	override function closeSubState()
	{
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new MPlayerMeta(songName, weekNum, songCharacter, color));
	}

	public static var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;

	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		FlxG.camera.zoom = FlxMath.lerp(1, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));

		// Keybind Vars
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var leftP = controls.UI_LEFT_P;
		var rightP = controls.UI_RIGHT_P;
		var accepted = controls.ACCEPT;
		var ctrl = FlxG.keys.justPressed.CONTROL;
		var alt = FlxG.keys.justPressed.ALT;

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

            if (leftP)
            {
                if (vocals != null)
                {
                    vocals.time -= 5000;
                }
                FlxG.sound.music.time -= 5000;
            }
            if (rightP)
            {
                if (vocals != null)
                {
                    vocals.time += 5000;
                }
                FlxG.sound.music.time += 5000;
            }

			if (controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
				}
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP)
			changeDiff();

			if (controls.BACK)
			{
				if (curPlaying)
				{
					persistentUpdate = false;
					if (colorTween != null)
					{
						colorTween.cancel();
					}
					FlxG.sound.play(Paths.sound('cancelMenu'));
					{
						#if desktop
						DiscordClient.changePresence('In the Music Player', null);
						#end
						persistentUpdate = false;

						if (colorTween != null)
						{
							colorTween.cancel();
						}
						
						destroyFreeplayVocals();
						hideBar();
						FlxG.sound.music.stop();
						curPlaying = false;
						iconArray[instPlaying].canBounce = false;
						iconArray[instPlaying].animation.curAnim.curFrame = 0;
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						if (ClientPrefs.useClassicSongs)
						{
							FlxG.sound.playMusic(Paths.music('freakyMenuC'));
						}
						}
					}
					else
					{
						FlxG.switchState(new ExtraMenuState());
					}
				}

		if (accepted)
		{
			if (instPlaying != curSelected)
			{
				#if desktop
				DiscordClient.changePresence('In the Music Player', '\nListening To: ' + CoolUtil.formatString(songs[curSelected].songName), null);
				#end
				
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				//showBar();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				Conductor.changeBPM(PlayState.SONG.bpm);
				for (i in 0...iconArray.length)
				{
					iconArray[i].canBounce = false;
					iconArray[i].animation.curAnim.curFrame = 0;
				}
				iconArray[instPlaying].canBounce = true;
				iconArray[instPlaying].animation.curAnim.curFrame = 2;
				curPlaying = true;
				#end
			}
		}
		else if (ctrl) //I kinda copied BACK a little bit for this one
		{
			if (curPlaying)
			{
				persistentUpdate = false;
				if (colorTween != null)
				{
					colorTween.cancel();
				}
				{
					#if desktop
					DiscordClient.changePresence('In the Music Player', '\nListening To: ' + CoolUtil.formatString(songs[curSelected].songName), null);
					#end

					destroyFreeplayVocals();
					curPlaying = true;
					}
				}
			}
		else if (alt)
		{
			MusicBeatState.switchState(new FreeplayState());
			destroyFreeplayVocals();
			curPlaying = true;
		}
		super.update(elapsed);
	}

	override function beatHit()
	{
		super.beatHit();

		if (curPlaying)
			iconArray[instPlaying].bounce();

		if (FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
			FlxG.camera.zoom += 0.015;
	}

	public static function destroyFreeplayVocals()
	{
		if (vocals != null)
		{
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function hideBar()
		{
			FlxTween.tween(timeBar, {alpha: 0}, 0.15);
			FlxTween.tween(timeBarBG, {alpha: 0}, 0.15);
			FlxTween.tween(timeTxt, {alpha: 0}, 0.15);
			new FlxTimer().start(0.15, function(bitchFuckAssDickCockBalls:FlxTimer)
			{
				timeBar.visible = false;
				timeBarBG.visible = false;
				timeTxt.visible = false;
			});
		}

	function showBar()
		{
			timeBar.alpha = 0;
			timeBarBG.alpha = 0;
			timeTxt.alpha = 0;
			timeBar.visible = true;
			timeBarBG.visible = true;
			timeTxt.visible = true;
			FlxTween.tween(timeBar, {alpha: 1}, 0.15);
			FlxTween.tween(timeBarBG, {alpha: 1}, 0.15);
			FlxTween.tween(timeTxt, {alpha: 1}, 0.15);
		}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length - 1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if (playSound)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var newColor:Int = songs[curSelected].color;
		if (newColor != intendedColor)
		{
			if (colorTween != null)
			{
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween)
				{
					colorTween = null;
				}
			});
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (diffStr != null)
			diffStr = diffStr.trim(); // Fuck you HTML5

		if (diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if (diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if (diffs[i].length < 1)
						diffs.remove(diffs[i]);
				}
				--i;
			}

			if (diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}

		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		// trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if (newPos > -1)
		{
			curDifficulty = newPos;
		}
	}
}

class MPlayerMeta
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if (this.folder == null)
			this.folder = '';
	}
}
