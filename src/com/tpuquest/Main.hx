package com.tpuquest;

import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Data;
import com.haxepunk.RenderMode;

import com.tpuquest.screen.*;
import com.tpuquest.utils.CLocals;

#if android
import openfl.utils.SystemPath;
#end

import haxe.xml.*;

#if !flash
import sys.FileSystem;
import sys.io.File;
#end

import pgr.dconsole.DC;

class Main extends Engine
{
	public static inline var screenWidth:Int = 800;
	public static inline var screenHeight:Int = 600;
	public static inline var frameRate:Int = 30;
	public static inline var clearColor:Int = 0x333333;

	public function new()
	{
#if !flash
		super(screenWidth, screenHeight, frameRate, false, RenderMode.HARDWARE);
#else
		super(screenWidth, screenHeight, frameRate, false, RenderMode.BUFFER);
#end
	}

	override public function init()
	{
#if debug
		HXP.console.enable();
		HXP.console.log(["The game has started!"]);
#end
		HXP.screen.scale = 1;
		LoadConfig();
		
		DC.init();
		DC.setConsoleKey(192);
		DC.setMonitorKey(192, true);
		DC.log("This text will be logged.");
		
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
	
	private static function LoadConfig()
	{
		var config:Xml;
#if android
		if ( FileSystem.exists(SystemPath.applicationStorageDirectory + "/config.xml") )
		{
			config = Xml.parse(File.getContent( SystemPath.applicationStorageDirectory + "/config.xml" )).firstElement();
#elseif flash
		Data.load("tpuquuest_data");
		if (Data.read("settings") != null)
		{
			config = Xml.parse(Data.read("settings")).firstElement();
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
#elseif flash
			Data.write("settings", config.toString());
			Data.save("tpuquuest_data", true);
#else
			File.saveContent("config.xml", config.toString());
#end
		}
		CLocals.set( SettingsMenu.language );
	}
}