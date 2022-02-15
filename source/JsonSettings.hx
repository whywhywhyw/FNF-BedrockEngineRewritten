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

    /* use this to call the function: JsonSettings.setJson(*SETTING FILE NAME*);
    FOR MODS USE JsonSettings.modsJson(*SETTING FILE NAME*);
    NOTE TO SELF YOU DO NOT NEED TO IMPORT THIS YOU DUMBASS */

    //this is used for log counts
    public static var logs:Null<Int>; 

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
    public static var letterGrader:Null<Bool>;
    public static var antiMash:Null<Bool>;

    #if sys
    public static function setJson(setting:String)
    {
        if (FileSystem.exists(Paths.returnJson(setting)))
        {
            var tempSetting:String = File.getContent(Paths.returnJson(setting));
            if (tempSetting != null && tempSetting.length >= 3)
            {
                logs++;

                var shut:Dynamic = Json.parse(Paths.returnJson(setting));

                //////////////////////////NOTE//////////////////////////////////
                if (setting == "note")
                {
                    var noteSplashSkinTEMPLATE:String = Reflect.getProperty(shut, "noteSplashSkin");
                    var noteSkinTEMPLATE:String = Reflect.getProperty(shut, "noteSkin");

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
                }

                ///////////////////////////////UI///////////////////////////////////////

                else if (setting == "uiSettings")
                {
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
                }

                ///////////////////////////////GAMEPLAY//////////////////////////////////////

                else if (setting == "gameplaySetting")
                {
                    var letterGraderTEMPLATE:Bool = Reflect.getProperty(poop, "letterGrader");
                    var antiMashTEMPLATE:Bool = Reflect.getProperty(poop, "antiMash");
                    var dividerTEMPLATE:String = Reflect.getProperty(poop, "divider");
                    var ratingDividerTEMPLATE:String = Reflect.getProperty(poop, "ratingDivider");

                    letterGrader = letterGraderTEMPLATE;
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
    }
    #end

    //use this on your mods and add your options 
    #if MODS_ALLOWED
    #if sys
    public static function modsJson(modSetting:String)
    {
        if (FileSystem.exists(Paths.modsSettings(modSetting)))
        {
            var customMod:String = File.getContent(Paths.modsSettings(modSetting));
            if (customMod != null && customMod.length >= 2)
            {
                logs++;

                trace("wow no options installed");
            }
        }
    }
    #end
    #end
}
