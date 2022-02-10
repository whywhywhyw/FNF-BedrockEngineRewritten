package;

import haxe.Timer;
import openfl.Lib;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;

class DisplayCounters extends TextField
{
	//standard FPS_Mem stuff
	private var times:Array<Float>;
	private var memPeak:Float = 0;

	// display info
	public static var displayFps = true;
	public static var displayMemory = true;
	public static var displayState = true;
	public static var displayPeak = true;

	private var display:Bool = false;

	public function new(inX:Float = 10.0, inY:Float = 10.0, color:Int = 0x000000, counters:Bool = false)
	{
		super();

		display = counters;

		this.x = x;
		this.y = y;

		selectable = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 16, color);
		times = [];
		addEventListener(Event.ENTER_FRAME, onEnter);
		width = Main.gameWidth;
		height = Main.gameHeight;
	}

	private function onEnter(_)
	{
		var now = Timer.stamp();
		times.push(now);
		while (times[0] < now - 1)
			times.shift();
		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (mem > memPeak)
			memPeak = mem;

		if (visible)
		{
			text = "";
			
			if(ClientPrefs.showFPS)
				text += "FPS: " + times.length + "\n";

			if(ClientPrefs.memCounter)
				text += "Memory: " + mem + " mb" + "\n";

			if(ClientPrefs.memPeak)
                text += "Memory Peak: " + memPeak + " mb" + "\n";

			if(ClientPrefs.showState)
                text += "State: " + Main.curStateS;
		}
	}

public static function updateDisplayInfo()
	{
		displayFps = ClientPrefs.showFPS;
		displayState = ClientPrefs.showState;
		displayMemory = ClientPrefs.memCounter;
		displayPeak = ClientPrefs.memPeak;
	}
}