package com.tpuquest.screen;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.tpuquest.utils.DrawText;
import haxe.Utf8;
import flash.system.System;

import haxe.xml.*;
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

class Screen extends Scene
{
	public static var overrideControlByBox:Bool;
	
	public function new() 
	{
		super();
		
		overrideControlByBox = false;
	}
	
	public override function begin()
	{
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("jump", [Key.SPACE]);
		Input.define("esc", [Key.ESCAPE]);
		Input.define("action", [Key.ENTER, Key.X]);
		
		//addGraphic(DrawText.CreateTextEntity("TPUQuest. Alpha v0.0.3", GameFont.Molot, 12, 5, 5, 0x0, false));
		super.begin();
	}
	
	public override function update()
	{
		super.update();
	}
	
	private function ExitGame()
	{
		var config:Xml = Xml.createElement("settings");
		if ( FileSystem.exists("config.xml") )
		{
			config.set("sound", Std.string(SettingsMenu.soudVolume));
			config.set("music", Std.string(SettingsMenu.musicVolume));
			config.set("language", SettingsMenu.language);
			
			var fout:FileOutput = File.write( "config.xml", false );
			fout.writeString( config.toString() );
			fout.close();
		}
		
		System.exit(0);
	}
}