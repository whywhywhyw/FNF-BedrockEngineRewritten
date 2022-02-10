package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import haxe.Json;

using StringTools;
typedef MenuData =
{
	menulocation:Int,
	menuangle:Int
}

class NewMenuState extends MusicBeatState
{
	public static var bedrockEngineVersion:String = '0.3'; // This is also used for Discord RPC
	public static var psychEngineVersion:String = '0.5.1'; // this one too
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods',
		#end
		#if ACHIEVEMENTS_ALLOWED
		'awards',
		#end
		#if !switch
		'donate',
		#end
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var bg:FlxSprite;

	public var note1:FlxSprite;
	public var note2:FlxSprite;
	public var note3:FlxSprite;
	public var note4:FlxSprite;
	public var note1go:Bool = false;
	public var note2go:Bool = false;
	public var note3go:Bool = false;
	public var note4go:Bool = false;
	public var notes:FlxTypedGroup<Note>;

	var randomY1:Array<Float> = [54, 46, 24, 67, 45, 34, 76];
	var randomY2:Array<Float> = [65, 85, 43, 86, 87, 29, 95];

	var downshadow:FlxSprite; // idk how to exsit --Luis

	var logoBl:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var menuJSON:MenuData;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Main Menu", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		#if (desktop && MODS_ALLOWED)
		var path = "mods/" + Paths.currentModDirectory + "/images/menuJson.json";
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)) {
			path = "mods/images/menuJson.json";
		}
		//trace(path, FileSystem.exists(path));
		if (!FileSystem.exists(path)) {
			path = "assets/images/menuJson.json";
		}
		//trace(path, FileSystem.exists(path));
		menuJSON = Json.parse(File.getContent(path));
		#else
		var path = Paths.getPreloadPath("menuJson.json");
		menuJSON = Json.parse(Assets.getText(path)); 
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175 * scaleRatio));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		// magenta.scrollFactor.set();

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175 * scaleRatio));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		magenta.visible = false;
		add(magenta);

		danote('create');

		downshadow = new FlxSprite(0, 0).loadGraphic(Paths.image('idkhowtonameit'));
		downshadow.scrollFactor.set();
		downshadow.updateHitbox();
		downshadow.screenCenter();
		downshadow.antialiasing = ClientPrefs.globalAntialiasing;
		downshadow.color = FlxColor.BLACK;
		downshadow.alpha = 0.6;
		add(downshadow);

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(menuJSON.menulocation, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.setGraphicSize(Std.int(menuItem.width * 0.8));
			menuItem.ID = i;
			menuItem.x = 100;
			menuItem.angle = menuJSON.menuangle;
			// menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			// menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		if (!ClientPrefs.lowQuality)
		{
			logoBl = new FlxSprite(-100, -100);

			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
			logoBl.scrollFactor.set();
			logoBl.antialiasing = ClientPrefs.globalAntialiasing;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
			logoBl.setGraphicSize(Std.int(logoBl.width * 0.5));
			logoBl.animation.play('bump');
			logoBl.alpha = 0;
			logoBl.angle = 0;
			logoBl.updateHitbox();
			// add(logoBl);
			FlxTween.tween(logoBl, {
				y: logoBl.y + 150,
				x: logoBl.x + 150,
				angle: -4,
				alpha: 1
			}, 1.4, {ease: FlxEase.expoInOut});
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		// Version Text
		var versionShit:FlxText = new FlxText(12, ClientPrefs.getResolution()[1] - 64, 0, "Bedrock Engine v" + bedrockEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, ClientPrefs.getResolution()[1] - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		// FNF Version Text (Global)
		var versionShit:FlxText = new FlxText(12, ClientPrefs.getResolution()[1] - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'),
			12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
		{
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2]))
			{ // It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
				// Main Menu Back Animations
				FlxTween.tween(FlxG.camera, {zoom: 5, angle: 45, alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				// FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
				// FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
				// FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
				// FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					if (ClientPrefs.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							// Main Menu Select Animations
							FlxTween.tween(FlxG.camera, {zoom: 5, angle: 45, alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							// FlxTween.tween(bg, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							// FlxTween.tween(magenta, {angle: 45}, 0.8, {ease: FlxEase.expoIn});
							// FlxTween.tween(bg, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							// FlxTween.tween(magenta, {alpha: 0}, 0.8, {ease: FlxEase.expoIn});
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										MusicBeatState.switchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		danote('update');
		danote('move them');

		FlxG.watch.addQuick("note1.y:", note1.y);
		FlxG.watch.addQuick("note2.y:", note2.y);
		FlxG.watch.addQuick("note3.y:", note3.y);
		FlxG.watch.addQuick("note4.y:", note4.y);

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (menuJSON.menulocation == 640) spr.screenCenter(X) else spr.x = menuJSON.menulocation;
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if (menuItems.length > 4)
				{
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}

	override function beatHit()
	{
		super.beatHit();
		if (curBeat % 4 == 0 && ClientPrefs.camZooms)
			FlxG.camera.zoom = 1.015;
	}

	function danote(whatvar:String)
	{
		switch (whatvar)
		{
			case 'create':
				{
					note1 = new FlxSprite();
					note1.frames = Paths.getSparrowAtlas('NOTE_assets');
					note1.scrollFactor.set();
					note1.antialiasing = ClientPrefs.globalAntialiasing;
					note1.animation.addByPrefix('purpleScroll', 'purple0', 24, false);
					note1.setGraphicSize(Std.int(note1.width * 0.7));
					note1.animation.play('purpleScroll');
					note1.updateHitbox();
					note1.x = 700;
					switch (FlxG.random.int(1, 2))
					{
						case 1:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note1.y += 132;
								case 2:
									note1.y += 96;
								default:
									note1.y += 86;
							}
						default:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note1.y -= 304;
								case 2:
									note1.y -= 35;
								case 3:
									note1.y -= 72;
							}
					}

					note2 = new FlxSprite();
					note2.frames = Paths.getSparrowAtlas('NOTE_assets');
					note2.scrollFactor.set();
					note2.antialiasing = ClientPrefs.globalAntialiasing;
					note2.animation.addByPrefix('blueScroll', 'blue0');
					note2.setGraphicSize(Std.int(note2.width * 0.7));
					note2.animation.play('blueScroll');
					note2.updateHitbox();
					note2.x = note1.x + 120;
					switch (FlxG.random.int(1, 2))
					{
						case 1:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note2.y += 132;
								case 2:
									note2.y += 96;
								default:
									note2.y += 86;
							}
						default:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note2.y -= 304;
								case 2:
									note2.y -= 35;
								case 3:
									note2.y -= 6;
							}
					}

					note3 = new FlxSprite();
					note3.frames = Paths.getSparrowAtlas('NOTE_assets');
					note3.scrollFactor.set();
					note3.antialiasing = ClientPrefs.globalAntialiasing;
					note3.animation.addByPrefix('greenScroll', 'green0');
					note3.setGraphicSize(Std.int(note3.width * 0.7));
					note3.animation.play('greenScroll');
					note3.updateHitbox();
					note3.x = note2.x + 120;
					switch (FlxG.random.int(1, 2))
					{
						case 1:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note3.y += 132;
								case 2:
									note3.y += 96;
								default:
									note3.y += 86;
							}
						default:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note3.y -= 304;
								case 2:
									note3.y -= 104;
								case 3:
									note3.y -= 6;
							}
					}

					note4 = new FlxSprite();
					note4.frames = Paths.getSparrowAtlas('NOTE_assets');
					note4.scrollFactor.set();
					note4.antialiasing = ClientPrefs.globalAntialiasing;
					note4.animation.addByPrefix('redScroll', 'red0');
					note4.setGraphicSize(Std.int(note4.width * 0.7));
					note4.animation.play('redScroll');
					note4.updateHitbox();
					note4.x = note3.x + 120;
					switch (FlxG.random.int(1, 2))
					{
						case 1:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note4.y += 132;
								case 2:
									note4.y += 96;
								default:
									note4.y += 104;
							}
						default:
							switch (FlxG.random.int(1, 3))
							{
								case 1:
									note4.y -= 250;
								case 2:
									note4.y -= 35;
								case 3:
									note4.y -= 141;
							}
					}

					add(note1);
					add(note2);
					add(note3);
					add(note4);
				}
			case 'update':
				{
					if (note1.y < 800)
					{
						note1.y += 1 / (ClientPrefs.framerate / 100);
					}
					if (note2.y < 800)
					{
						note2.y += 1 / (ClientPrefs.framerate / 100);
					}
					if (note3.y < 800)
					{
						note3.y += 1 / (ClientPrefs.framerate / 100);
					}
					if (note4.y < 800)
					{
						note4.y += 1 / (ClientPrefs.framerate / 100);
					}
					if (note1.y > 800)
						note1go = true;
					if (note2.y > 800)
						note2go = true;
					if (note3.y > 800)
						note3go = true;
					if (note4.y > 800)
						note4go = true;
				}
			case 'move them':
				{
					if (note1go)
					{
						switch (FlxG.random.int(1, 3))
						{
							case 1:
								note1.y -= 800 + 30 + 68;
							case 2:
								note1.y -= 800 + 30 + 76;
							case 3:
								note1.y -= 800 + 30 + 56;
							case 4:
								note1.y -= 800 + 30 + 16;
						}
						note1go = false;
					}
					if (note2go)
					{
						switch (FlxG.random.int(1, 3))
						{
							case 1:
								note2.y -= 800 + 30 + 104;
							case 2:
								note2.y -= 800 + 30 + 76;
							case 3:
								note2.y -= 800 + 30 + 72;
							case 4:
								note2.y -= 800 + 30 + 12;
						}
						note2go = false;
					}
					if (note3go)
					{
						switch (FlxG.random.int(1, 3))
						{
							case 1:
								note3.y -= 800 + 30 + 87;
							case 2:
								note3.y -= 800 + 30 + 76;
							case 3:
								note3.y -= 800 + 30 + 56;
							case 4:
								note3.y -= 800 + 30 + 16;
						}
						note3go = false;
					}
					if (note4go)
					{
						switch (FlxG.random.int(1, 3))
						{
							case 1:
								note4.y -= 800 + 30 + 76;
							case 2:
								note4.y -= 800 + 30 + 68;
							case 3:
								note4.y -= 800 + 30 + 130;
							case 4:
								note4.y -= 800 + 30 + 10;
						}
						note4go = false;
					}
				}
		}
	}
}
