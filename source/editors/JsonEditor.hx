package editors;

#if desktop
import Discord.DiscordClient;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
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
import meta.state.*;
import meta.state.menus.*;

using StringTools;

//haxe may be outdated and stuff but seriously musicbeatstate fuck you
class JsonEditor extends MusicBeatState
{

      //private var ididyourmom:Bool;
      public var savetext:String;
      public var savegtext:String;
      public var saventext:String;

      public var na:FlxUIInputText;
      public var ney:FlxUIInputText;
      public var neya:FlxUIInputText;
      public var coolInput:FlxUIInputText;
      public var coolInput2:FlxUIInputText;

      //ui shit
      public var nae:FlxUIInputText;
      private var UI_characterbox:FlxUITabMenu;

      //gameplay shit
      public var anan:FlxUIInputText;
      public var gbutonum:FlxButton;

      //grabbing shit from JsonSettings.hx (gameplay)
      public var letterG:Bool;
      public var divide:String;
      public var ratingDivider:String;
      public var mash:Bool;

      //grabbing shit from JsonSettings.hx (ui)
      public var icon:Bool;
      public var judgement:String;
      public var splash:String;

      //these will be save backup directory
      public var savedir:String = "backup/uiBackup.txt";
      public var backup:String;
      public var gbackup:String;
      public var gsavedir:String = "backup/gameplayBackup.txt";

      //these will be content
      public var appearance:String;
      public var gameplay:String;
      public var note:String;
       
      //this will be readme text
      public var readme:String = JsonSettings.read;

       /*reminder to all devs: this state has broken boxes for the note section and
		gameplay section, do not try to use it until it's completely fixed
		- Gui iago*/
      #if sys
     override public function create()
      {
            var ctrltext:FlxText = new FlxText(0, 40, FlxG.width, "", 20);
            ctrltext.text = "";

            FlxG.mouse.useSystemCursor = true;
            FlxG.mouse.visible = true;

            var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
            bg.color = FlxColor.GRAY;
		bg.screenCenter();
		add(bg);

            var tabs = [
			{name: 'Appearance', label: 'Appearance'},
			{name: 'Gameplay', label: 'Gameplay'},
                  {name: 'Notes', label: 'Notes'}
		];
		UI_characterbox = new FlxUITabMenu(null, tabs, true);

		UI_characterbox.resize(400, 400);
		UI_characterbox.x = FlxG.width - 835;
		UI_characterbox.y = 175;
		UI_characterbox.scrollFactor.set();
		add(UI_characterbox);

            JsonSettings.setJson(JsonSettings.offdir, JsonSettings.dir, JsonSettings.dirtwo);
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
            ratingDivider = JsonSettings.ratingDivider;
            mash = JsonSettings.antiMash;

            icon = JsonSettings.iconSupport;
            judgement = JsonSettings.judgementSkin;

            
            backup = File.getContent(savedir);
            gbackup = File.getContent(gsavedir);

            var tab_group = new FlxUI(null, UI_characterbox);
		tab_group.name = "Appearance";

            var group_two = new FlxUI(null, UI_characterbox);
            group_two.name = "Gameplay";

            var note_group= new FlxUI(null, UI_characterbox);
            note_group.name = "Notes";

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

            var coolText2 = new FlxText(20, 80);
            coolText2.text = "Rating divider:";

            var text = new FlxText(20, 120);
            text.text = "Note Skin:";
            var texttwo = new FlxText(20, 160);
            texttwo.text = "Splash Skin:";


            var textthree = new FlxText(15, 120);
            textthree.text = "Judgement Skin:";

            var textfour = new FlxText(10, 140);
            textfour.text = "Check the README file on the\nsettings folder for more information\nand default skin names.";

            na = new FlxUIInputText(100, 80, 90, note, 8);
            ney = new FlxUIInputText(100, 100, 90, splash, 8);
            neya = new FlxUIInputText(100, 120, 90, judgement, 8);

            coolInput = new FlxUIInputText(100, 40, 90, divide, 8);
            coolInput2 = new FlxUIInputText(100, 40, 90, ratingDivider, 8);

		tab_group.add(text);
            tab_group.add(texttwo);
            tab_group.add(textthree);
            tab_group.add(textfour);
            tab_group.add(nae);
            tab_group.add(neya);
            tab_group.add(coolButton);
            UI_characterbox.addGroup(tab_group);

            group_two.add(coolText);
            group_two.add(coolText2);
            group_two.add(coolButton);
            group_two.add(coolInput);
            group_two.add(coolInput2);
            group_two.add(oof);
            group_two.add(anti);
            UI_characterbox.addGroup(group_two);
            
            note_group.add(na);
            note_group.add(ney);
            note_group.add(text);
            note_group.add(texttwo);
            UI_characterbox.addGroup(note_group);

            super.create();
      }

      override public function update(elapsed:Float)
      {
            JsonSettings.setJson(JsonSettings.offdir, JsonSettings.dir, JsonSettings.dirtwo);

            if (FlxG.keys.justPressed.ESCAPE) {
                  MusicBeatState.switchState(new ExtraMenuState());
                  FlxG.mouse.visible = false;
            }

            #if desktop
            DiscordClient.changePresence("Editing JSON Preferences", null);
            #end

            JsonSettings.setJson(JsonSettings.offdir, JsonSettings.dir, JsonSettings.dirtwo);
           
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
                  "ratingDivider": "'+coolInput2.text+'"
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
                        "divider": "-"
                        }';
                  }          
            }
      }

      function saveNoteSetting()
      {
            saventext =
            '
            {              
                  "noteSkin":"'+na.text+'",
                  "noteSplashSkin":"'+ney.text+'"
            }
            ';
            File.saveContent(JsonSettings.offdir, saventext);
            if (note == null || note.length < 16)
            {
                  saventext =
                  '              
                  "noteSkin":"NOTE_assets",
                  "noteSplashSkin":"noteSplashes"
                  ';
                  File.saveContent(JsonSettings.offdir, saventext);
            }
      }
      #end
}
