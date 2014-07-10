package com.tpuquest.screen;

import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Data;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;
import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Touch;
import com.haxepunk.HXP;
import com.haxepunk.Scene;

import flash.system.System;

#if !flash
import sys.io.File;
import sys.FileSystem;
#end

#if android
import openfl.Assets;
import openfl.utils.SystemPath;
#end

class Screen extends Scene
{
	public static var overrideControlByBox:Bool;
	
	public function new() 
	{
		super();
		
		overrideControlByBox = false;
#if android
		var androidOverlay:Image = new Image("graphics/androidOverlay.png");
		addGraphic(androidOverlay, -999);
		androidOverlay.scrollX = androidOverlay.scrollY = 0;
#end
	}
	
	public override function begin()
	{
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("jump", [Key.SPACE]);
		Input.define("esc", [Key.ESCAPE, Key.BACKSPACE]);
		Input.define("action", [Key.ENTER, Key.X]);
		
		super.begin();
	}
	
	public override function update()
	{
		super.update();
		
		prevHatX = Input.joystick(0).hat.x;
		prevHatY = Input.joystick(0).hat.y;
	}
	
	public static function SaveSettings()
	{
		var config:Xml = Xml.createElement("settings");

		config.set("sound", Std.string(SettingsMenu.soudVolume));
		config.set("music", Std.string(SettingsMenu.musicVolume));
		config.set("language", SettingsMenu.language);
			
#if android
		File.saveContent(SystemPath.applicationStorageDirectory + "/config.xml", config.toString());
#elseif flash
		Data.load("tpuquuest_data");
		Data.write("settings", config.toString());
		Data.save("tpuquuest_data", true);
#else
		File.saveContent("config.xml", config.toString());
#end
	}
	
	public static function ExitGame()
	{
		SaveSettings();
		System.exit(0);
	}
	
	public static function joyCheck(key:String):Bool
	{
		switch(key)
		{
			case "A":
				return Input.joystick(0).check(XBOX_GAMEPAD.A_BUTTON);
			case "B":
				return Input.joystick(0).check(XBOX_GAMEPAD.B_BUTTON);
			case "Y":
				return Input.joystick(0).check(XBOX_GAMEPAD.Y_BUTTON);
			case "X":
				return Input.joystick(0).check(XBOX_GAMEPAD.X_BUTTON);
			case "LB":
				return Input.joystick(0).check(XBOX_GAMEPAD.LB_BUTTON);
			case "RB":
				return Input.joystick(0).check(XBOX_GAMEPAD.RB_BUTTON);
			case "DPAD_UP":
				return Input.joystick(0).check(XBOX_GAMEPAD.DPAD_UP);
			case "DPAD_DOWN":
				return Input.joystick(0).check(XBOX_GAMEPAD.DPAD_DOWN);
			case "DPAD_LEFT":
				return Input.joystick(0).check(XBOX_GAMEPAD.DPAD_LEFT);
			case "DPAD_RIGHT":
				return Input.joystick(0).check(XBOX_GAMEPAD.DPAD_RIGHT);
			case "BACK":
				return Input.joystick(0).check(XBOX_GAMEPAD.BACK_BUTTON);
			case "START":
				return Input.joystick(0).check(XBOX_GAMEPAD.START_BUTTON);
			case "LS_BUTTON":
				return Input.joystick(0).check(XBOX_GAMEPAD.LEFT_ANALOGUE_BUTTON);
			case "RS_BUTTON":
				return Input.joystick(0).check(XBOX_GAMEPAD.RIGHT_ANALOGUE_BUTTON);
		}
		return false;
	}
	
	private static var prevHatX:Float = 0;
	private static var prevHatY:Float = 0;
	
	public static function joyPressed(key:String):Bool
	{
		switch(key)
		{
			case "A":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON);
			case "B":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.B_BUTTON);
			case "Y":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.Y_BUTTON);
			case "X":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.X_BUTTON);
			case "LB":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON);
			case "RB":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON);
			case "DPAD_UP":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_UP);
			case "DPAD_DOWN":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_DOWN);
			case "DPAD_LEFT":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_LEFT);
			case "DPAD_RIGHT":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.DPAD_RIGHT);
			case "BACK":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.BACK_BUTTON);
			case "START":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.START_BUTTON);
			case "LS_BUTTON":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.LEFT_ANALOGUE_BUTTON);
			case "RS_BUTTON":
				return Input.joystick(0).pressed(XBOX_GAMEPAD.RIGHT_ANALOGUE_BUTTON);
		}
		return false;
	}
	
	public static function touchPressed(area:String):Bool
	{
		var tapSize:Float = 129.0;
		for (x in Input.touches)
		{
			if (x.pressed)
			{
				switch(area)
				{
					case "esc":
						if (x.x <= tapSize && x.y <= tapSize && x.x >= 0 && x.y >= 0)
							return true;
					case "action":
						if (x.x <= HXP.screen.width && x.y <= HXP.screen.height && x.x > HXP.screen.width - tapSize && x.y > HXP.screen.height - tapSize)
							return true;
					case "left":
						if (x.x <= tapSize && x.y <= HXP.screen.height && x.x > 0 && x.y > HXP.screen.height - tapSize)
							return true;
					case "right":
						if (x.x <= tapSize * 3 && x.y <= HXP.screen.height && x.x > tapSize * 2 && x.y > HXP.screen.height - tapSize)
							return true;
					case "up":
						if (x.x <= tapSize * 2 && x.y <= HXP.screen.height - tapSize && x.x > tapSize && x.y > HXP.screen.height - tapSize * 2)
							return true;
					case "down":
						if (x.x <= tapSize * 2 && x.y <= HXP.screen.height && x.x > tapSize && x.y > HXP.screen.height - tapSize)
							return true;
					case "jump":
						if (x.x <= HXP.screen.width && x.y <= HXP.screen.height - tapSize && x.x > HXP.screen.width - tapSize && x.y > HXP.screen.height - tapSize * 2)
							return true;
				}
			}
		}
		return false;
	}
	
	public static function touchCheck(area:String):Bool
	{
		var tapSize:Float = 129.0;
		for (x in Input.touches)
		{
			if (x.time > 0)
			{
				switch(area)
				{
					case "esc":
						if (x.x <= tapSize && x.y <= tapSize && x.x >= 0 && x.y >= 0)
							return true;
					case "action":
						if (x.x <= HXP.screen.width && x.y <= HXP.screen.height && x.x > HXP.screen.width - tapSize && x.y > HXP.screen.height - tapSize)
							return true;
					case "left":
						if (x.x <= tapSize && x.y <= HXP.screen.height && x.x > 0 && x.y > HXP.screen.height - tapSize)
							return true;
					case "right":
						if (x.x <= tapSize * 3 && x.y <= HXP.screen.height && x.x > tapSize * 2 && x.y > HXP.screen.height - tapSize)
							return true;
					case "up":
						if (x.x <= tapSize * 2 && x.y <= HXP.screen.height - tapSize && x.x > tapSize && x.y > HXP.screen.height - tapSize * 2)
							return true;
					case "down":
						if (x.x <= tapSize * 2 && x.y <= HXP.screen.height && x.x > tapSize && x.y > HXP.screen.height - tapSize)
							return true;
					case "jump":
						if (x.x <= HXP.screen.width && x.y <= HXP.screen.height - tapSize && x.x > HXP.screen.width - tapSize && x.y > HXP.screen.height - tapSize * 2)
							return true;
				}
			}
		}
		return false;
	}
}