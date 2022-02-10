package editors;

#if desktop
import Discord.DiscordClient;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import flixel.FlxG;
import flixel.addons.ui.FlxUICheckBox;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

using StringTools;

//haxe may be outdated and stuff but seriously musicbeatstate fuck you
class JsonEditor extends MusicBeatState
{

      public var coolSick:FlxUIInputText;
      public var coolMarv:FlxUIInputText;
      public var coolGood:FlxUIInputText;
      public var coolBad:FlxUIInputText;

      //private var ididyourmom:Bool;
      public var savetext:String;
      public var savegtext:String;
      public var saventext:String;

      public var na:FlxUIInputText;
      public var ney:FlxUIInputText;
      public var neya:FlxUIInputText;
      public var coolInput:FlxUIInputText;

      //ui shit
      public var nae:FlxUIInputText;
      private var UI_characterbox:FlxUITabMenu;

      //gameplay shit
      public var anan:FlxUIInputText;
      public var gbutonum:FlxButton;

      //grabbing shit from JsonSettings.hx (gameplay)
      public var letterG:Bool;
      public var divide:String;
      public var mash:Bool;

      //grabbing shit from JsonSettings.hx (ui)
      public var icon:Bool;
      public var judgement:String;
      public var splash:String;

      //grabbing shit from JsonSettings.hx (note)
      public var sickOff:Int;
      public var marvOff:Int;
      public var goodOff:Int;
      public var badOff:Int;

      //these will be save backup directory
      public var savedir:String = "backup/uiBackup.txt";
      public var backup:String;
      public var gsavedir:String = "backup/gameplayBackup.txt";
      public var gbackup:String;


      //these will be content
      public var appearance:String;
      public var gameplay:String;
      public var note:String;
       
      //this will be readme text
      public var readme:String = JsonSettings.read;

     override public function create()
      {
            var ctrltext:FlxText = new FlxText(0, 40, FlxG.width, "", 20);
            ctrltext.text = "";

            FlxG.mouse.useSystemCursor = true;
	    FlxG.mouse.visible = true;
            Main.curStateS = 'JsonEditor'; //this is used for showing states

            var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.screenCenter();
		add(bg);

            var tabs = [
			{name: 'Appearance', label: 'Appearance'},
			{name: 'Gameplay', label: 'Gameplay'},
                  {name: 'Note', label: 'Note'}
		];
		UI_characterbox = new FlxUITabMenu(null, tabs, true);

		UI_characterbox.resize(400, 400);
		UI_characterbox.x = FlxG.width - 835;
		UI_characterbox.y = 175;
		UI_characterbox.scrollFactor.set();
		add(UI_characterbox);

            JsonSettings.dev(JsonSettings.dir);
            
            
	      
	    appearance = File.getContent(JsonSettings.dir);
            gameplay = File.getContent(JsonSettings.dirtwo);
            note = File.getContent(JsonSettings.offdir);
            
	      
	    if (FileSystem.exists(savedir) && FileSystem.exists(gsavedir))
	    {
		    backup = appearance;
		    gbackup = gameplay;
	    }
		     

            /* if (FileSystem.exists("backup/") && !FileSystem.exists("backup/uiBackup.txt") && !FileSystem.exists("backup/gameplayBackup.txt"))
                  ididyourmom = true;
            else
                  ididyourmom = false;

            if (!FileSystem.exists("backup/"))
            {
                #if windows
		Sys.command("mkdir backup/");
		#else
	        Sys.command("mkdir -p backup/");
		#end
		    
                ididyourmom = true;
            }*/

            letterG = JsonSettings.letterGrader;
            divide = JsonSettings.divider;
            mash = JsonSettings.antiMash;

            icon = JsonSettings.iconSupport;
            judgement = JsonSettings.judgementSkin;

            sickOff = JsonSettings.sickWindow;
            marvOff = JsonSettings.marvWindow;
            goodOff = JsonSettings.goodWindow;
            badOff = JsonSettings.badWindow;

            backup = File.getContent(savedir);
            gbackup = File.getContent(gsavedir);

            var tab_group = new FlxUI(null, UI_characterbox);
		tab_group.name = "Appearance";

            var group_two = new FlxUI(null, UI_characterbox);
            group_two.name = "Gameplay";

            var note_group= new FlxUI(null, UI_characterbox);
            note_group.name = "Note";

            var nae = new FlxUICheckBox(20, 60, null, null, "300x150 icon support", 200);
		nae.checked = icon;
		nae.callback = function()
		{
                  icon = !icon;
                 // saveUISetting();
		};

            var oof = new FlxUICheckBox(20, 60, null, null, "Letter Grader", 200);
		oof.checked = letterG;
		oof.callback = function()
		{
                  letterG = !letterG;
		};

            var anti = new FlxUICheckBox(20, 100, null, null, "Antimash", 200);
		anti.checked = mash;
	      anti.callback = function()
		{
                  mash = !mash;
		};

            var coolButton = new FlxButton(FlxG.width - 855, 25, "Save Prefs", function()
            {
                  saveUISetting();
		      saveGameplaySetting();
                  saveNoteSetting();
            });

            var coolText = new FlxText(20, 40);
            coolText.text = "Score divider:";


            var sick = new FlxText(20, 60);
            sick.text = "Sick Offset:";
            var marv = new FlxText(20, 40);
            marv.text = "Marv Offset:";
            var good = new FlxText(20, 80);
            good.text = "Good Offset:";
            var bad = new FlxText(20, 100);
            bad.text = "Bad Offset:";
            var shit = new FlxText(20, 120);
            shit.text = "Shits will be handled automatically.";

            var text = new FlxText(20, 80);
            text.text = "Note Skin:";
            var texttwo = new FlxText(20, 100);
            texttwo.text = "Splash Skin:";


            var textthree = new FlxText(15, 120);
            textthree.text = "Judgement Skin:";

            var textfour = new FlxText(10, 140);
            textfour.text = "Check the README file on the\nsettings folder for more information\nand default skin names.";

            na = new FlxUIInputText(100, 80, 90, note, 8);
            ney = new FlxUIInputText(100, 100, 90, splash, 8);
            neya = new FlxUIInputText(100, 120, 90, judgement, 8);

            coolInput = new FlxUIInputText(100, 40, 90, divide, 8);
            
            coolSick = new FlxUIInputText(100, 60, 90, sickOff, 8);
            coolMarv = new FlxUIInputText(100, 40, 90, marvOff, 8);
            coolGood = new FlxUIInputText(100, 80, 90, goodOff, 8);
            coolBad = new FlxUIInputText(100, 100, 90, badOff, 8);

		tab_group.add(text);
            tab_group.add(texttwo);
            tab_group.add(textthree);
            tab_group.add(textfour);
            tab_group.add(nae);
            tab_group.add(neya);
            tab_group.add(coolButton);
            UI_characterbox.addGroup(tab_group);

            group_two.add(coolText);
            group_two.add(coolButton);
            group_two.add(coolInput);
            group_two.add(oof);
            group_two.add(anti);
            UI_characterbox.addGroup(group_two);

            note_group.add(sick);
            note_group.add(marv);
            note_group.add(good);
            note_group.add(bad);
            note_group.add(shit);
            note_group.add(coolSick);
            note_group.add(coolMarv);
            note_group.add(coolGood);
            note_group.add(coolBad);
            UI_characterbox.addGroup(note_group);

            super.create();
      }

      override public function update(elapsed:Float)
      {
            JsonSettings.dev(JsonSettings.dir);

            if (FlxG.keys.justPressed.ESCAPE) {
                  MusicBeatState.switchState(new ExtraMenuState());
                  FlxG.mouse.visible = false;
            }

            #if desktop
            DiscordClient.changePresence("Editing JSON Preferences", null);
            #end

            JsonSettings.dev(JsonSettings.dir);
           
            if (appearance == null || gameplay == null)
            {
                  var error:FlxText = new FlxText(240, 150, 25, "Something went wrong\nwith Json settings.\n
                  Created a json temporarily\nso you can fix it.", 10);
                  error.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                  error.scrollFactor.set();
		      error.borderSize = 1.25;
                  add(error);      
            }
      super.update(elapsed);
      }

      function saveUISetting()
      {
            savetext = 
            '
            {
                  "iconSupport":'+icon+',
	            "judgementSkin": "'+neya.text+'" 
            }
            ';
            File.saveContent(JsonSettings.dir, savetext);
            if (appearance == null)
            {
                  if (FileSystem.exists(backup) && backup.contains("iconSupport") && backup.contains("judgementSkin"))
                        File.saveContent(savedir, backup);
                  else
                  {
                        appearance = '{
                        "iconSupport":false,
                        "judgementSkin": "bedrock"         
                        }';
                  }          
	    }
      }

      function saveGameplaySetting()
      {
            savegtext = 
            '
            {
                  "letterGrader":'+letterG+',
	            "antiMash":'+mash+',
	            "divider": "'+coolInput.text+'"
            }
            ';
            File.saveContent(JsonSettings.dirtwo, savegtext);
            if (gameplay == null)
            {
                  if (FileSystem.exists(gbackup) && gbackup.contains("letterGrader") && gbackup.contains("antiMash") && gbackup.contains("divider"))
                        File.saveContent(gsavedir, gbackup);
                  else
                  {
                        gameplay = '{
                        "letterGrader":true,
                        "antiMash":true,
                        "divider": " - "
                        }';
                  }          
            }
      }

      function saveNoteSetting()
      {
            saventext =
            '
            {
                  "marvOffset": '+coolMarv.text+',
                  "sickOffset": '+coolSick.text+',
                  "goodOffset": '+coolGood.text+',
                  "badOffset": '+coolBad.text+',
              
                  "noteSkin":"'+na.text+'",
                  "noteSplashSkin":"'+ney.text+'"
            }
            ';
            File.saveContent(JsonSettings.offdir, saventext);
            if (note == null || note.length < 64)
            {
                  saventext =
                  '
                  "marvOffset": 25,
                  "sickOffset": 45,
                  "goodOffset": 90,
                  "badOffset": 135,
              
                  "noteSkin":"NOTE_assets",
                  "noteSplashSkin":"notesplashes"
                  ';
                  File.saveContent(JsonSettings.offdir, saventext);
            }
      }
}
