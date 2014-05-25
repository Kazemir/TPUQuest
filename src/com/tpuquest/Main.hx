package com.tpuquest;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.tpuquest.screen.*;
import com.tpuquest.unitTests.*;
import com.haxepunk.RenderMode;
import com.tpuquest.utils.CLocals;
import flash.events.KeyboardEvent;

#if android
import openfl.utils.SystemPath;
#end

import haxe.xml.*;

import sys.FileSystem;
import sys.io.File;

class Main extends Engine
{
	public static inline var screenWidth:Int = 800;
	public static inline var screenHeight:Int = 600;
	public static inline var frameRate:Int = 30;
	public static inline var clearColor:Int = 0x333333;

	public function new()
	{
		super(screenWidth, screenHeight, frameRate, false, RenderMode.HARDWARE);
	}

	override public function init()
	{
#if debug
		HXP.console.enable();
		HXP.console.log(["The game has started!"]);
#end
		HXP.screen.scale = 1;
		LoadConfig();
		
/*#if android
		HXP.stage.addEventListener (KeyboardEvent.KEY_UP, stage_onKeyUp);
#end*/
		
		HXP.scene = new SplashScreen();
	}

	public static function main() 
	{ 
		new Main();
	}
	
	override public function focusLost () {
		paused = true;
	}
	
	override public function focusGained () {
		paused = false;
	}
	
	/*private function stage_onKeyUp (event:KeyboardEvent):Void 
	{
#if android
		if (event.keyCode == 27) 
		{
			event.stopImmediatePropagation();
			nme.Lib.exit ();
		}
#end
	}*/
	
	private static function LoadConfig()
	{
		var config:Xml;
#if android
		if ( FileSystem.exists(SystemPath.applicationStorageDirectory + "/config.xml") )
		{
			config = Xml.parse(File.getContent( SystemPath.applicationStorageDirectory + "/config.xml" )).firstElement();
#else
		if ( FileSystem.exists("config.xml") )
		{
			config = Xml.parse(File.getContent( "config.xml" )).firstElement();
#end
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
#if android
			File.saveContent(SystemPath.applicationStorageDirectory + "/config.xml", config.toString());
#else
			File.saveContent("config.xml", config.toString());
#end
		}

		CLocals.set( SettingsMenu.language );
	}
}