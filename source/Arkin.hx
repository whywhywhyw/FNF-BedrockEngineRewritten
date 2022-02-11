package;

#if !switch
import flixel.FlxG;
#end

class Arkin
{
   public static var cloud:Array<String> = ["", "", ""];
   #if MODS_ALLOWED
   public static var cloudMod:Array<String> = ["", ""];
   #end
}
