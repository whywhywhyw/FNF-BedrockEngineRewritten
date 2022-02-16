package;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import haxe.Json;
import flixel.FlxG;
import meta.*;


class JsonSettings
{

    //use this to call the function: JsonSettings.setJson(JsonSettings.offdir, JsonSettings.dir, JsonSettings.dirtwo);
    //NOTE TO SELF YOU DO NOT NEED TO IMPORT THIS YOU DUMBASS

    //this is used for log counts
    public static var logs:Int = 0; 

    //readme stuff
    public static var read:String = "settings/do-READ-me.txt";

    //jsons content
    public static var customGame:String = null;
    public static var customJson:String = null;
    public static var offset:String = null;

    //ui settings 
    public static var iconSupport:Null<Bool>;
    public static var judgementSkin:String;

    //note settings
    public static var noteSkin:String;
    public static var noteSplashSkin:String;

    //gameplay settings 
    public static var divider:String;
    public static var ratingDivider:String;
    public static var antiMash:Null<Bool>;

    //json directories
    public static var dirtwo:String = "settings/gameplaySettings.json";
    public static var dir:String = "settings/uiSettings.json";
    public static var offdir:String = "settings/note.json";

    #if MODS_ALLOWED
    public static var dirmod:String = "mods/settings/settings.json";
    #end

    public static function setJson(offdir, dir, dirtwo)
    {
        if (FileSystem.exists(offdir) && FileSystem.exists(dir) && FileSystem.exists(dirtwo))
        {
            offset = File.getContent(offdir);
            customJson = File.getContent(dirtwo);
            customGame = File.getContent(dir);

            if (customJson != null && customJson.length > 4 && customGame != null && customGame.length > 4 && offset != null && offset.length > 4)
            {
                logs++;

                var piss:Dynamic = Json.parse(offset);
                var shit:Dynamic = Json.parse(customGame);
                var poop:Dynamic = Json.parse(customJson);

                //////////////////////////NOTE//////////////////////////////////
                var noteSplashSkinTEMPLATE:String = Reflect.getProperty(piss, "noteSplashSkin");
                var noteSkinTEMPLATE:String = Reflect.getProperty(piss, "noteSkin");

                noteSkin = noteSkinTEMPLATE;
                noteSplashSkin = noteSplashSkinTEMPLATE;

                if (noteSkinTEMPLATE == null || noteSkinTEMPLATE.length < 0)
                {
                    if (logs <= 10)
                        trace("invalid note skin, reverting back to the defaults.");
                    noteSkin = 'NOTE_assets';
                }
    
                if (noteSplashSkinTEMPLATE == null || noteSplashSkinTEMPLATE.length < 0)
                {
                    if (logs <= 10)
                        trace("invalid note splash, reverting back to the defaults.");
                    noteSplashSkin = 'noteSplashes';
                }

                ///////////////////////////////UI///////////////////////////////////////

                var iconSupportTEMPLATE:Bool = Reflect.getProperty(shit, "iconSupport");
				var judgementSkinTEMPLATE:String = Reflect.getProperty(shit, "judgementSkin");

                judgementSkin = judgementSkinTEMPLATE;
                iconSupport = iconSupportTEMPLATE;

                if (judgementSkinTEMPLATE == null || judgementSkinTEMPLATE.length < 0)
                {
                   if (logs <= 10) 
                    trace("invalid judgement skin, reverting back to the defaults.");
                   judgementSkin = 'bedrock';
                }

                ///////////////////////////////GAMEPLAY//////////////////////////////////////

				var antiMashTEMPLATE:Bool = Reflect.getProperty(poop, "antiMash");
				var dividerTEMPLATE:String = Reflect.getProperty(poop, "divider");
                var ratingDividerTEMPLATE:String = Reflect.getProperty(poop, "ratingDivider");

                antiMash = antiMashTEMPLATE;
                divider = dividerTEMPLATE;
                ratingDivider = ratingDividerTEMPLATE;

                if (dividerTEMPLATE != null && dividerTEMPLATE.length > 6 || ratingDividerTEMPLATE != null && ratingDividerTEMPLATE.length > 6)
                {
                    if  (logs <= 15)
                     trace("did you really think you could abuse dividers LMAO");
                    divider = '-';
                    ratingDivider = '|';
                }
                
                if (dividerTEMPLATE==null && ratingDividerTEMPLATE==null)
                {
                    divider = "-";
                    ratingDivider = '|';
                    if (FlxG.random.bool(10)) //this has a 10% chance of happening
                    {
                        if (FileSystem.exists("settings/lmao.log"))
                        {
                            if (logs <= 30)
                                trace("you already got this one lmao");
                        }
                        else
                            File.saveContent("settings/lmao.log", "did you really think you could make noteskins null? LMFAO someone thought about this already dumbass");
                        divider = "permission-denied";
                    }
                }
            }
        }
    }
   

    //use this on your mods and add your options 
    #if MODS_ALLOWED
    public static function devmod(dirmod:String)
    {
        if (FileSystem.exists(dir))
        {
            var customMod:String = File.getContent(dirmod);
            if (customMod != null)
            {
                logs++;

                trace("wow no mod options installed");
            }
        }
    }
    #end
}
