package com.tpuquest;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.tpuquest.screen.*;
import com.tpuquest.unitTests.*;
import com.haxepunk.RenderMode;
import com.tpuquest.utils.CLocals;

import haxe.xml.*;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

class Main extends Engine
{
	public static inline var screenWidth:Int = 800;
	public static inline var screenHeight:Int = 600;
	public static inline var frameRate:Int = 30;
	public static inline var clearColor:Int = 0x333333;

	public function new()
	{
		super(screenWidth, screenHeight, frameRate, false, RenderMode.BUFFER);
	}

	override public function init()
	{
#if debug
		HXP.console.enable();
		//HXP.console.log({"The game has started!"});
#end
		HXP.screen.scale = 1;
		LoadConfig();
		HXP.scene = new MainMenu();
	}

	public static function main() 
	{ 
		new Main();
	}
	
	private static function LoadConfig()
	{
		var config:Xml;
		if ( FileSystem.exists("config.xml") )
		{
			config = Xml.parse(File.getContent( "config.xml" )).firstElement();
			SettingsMenu.soudVolume = Std.parseInt(config.get("sound"));
			SettingsMenu.musicVolume = Std.parseInt(config.get("music"));
			SettingsMenu.language = config.get("language");
		}
		else
		{
			config = Xml.createElement("settings");
			
			config.set("sound", Std.string(SettingsMenu.soudVolume));
			config.set("music", Std.string(SettingsMenu.musicVolume));
			config.set("language", SettingsMenu.language);
			
			var fout:FileOutput = File.write( "config.xml", false );
			fout.writeString( config.toString() );
			fout.close();
		}

		CLocals.set( SettingsMenu.language );
	}
}