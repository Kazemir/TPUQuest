package com.tpuquest.screen;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.tpuquest.utils.DrawText;
import haxe.Utf8;
import flash.system.System;

import haxe.xml.*;
import sys.io.File;
import sys.FileSystem;

import com.haxepunk.utils.Joystick;
import com.haxepunk.utils.Touch;
import com.haxepunk.HXP;

//#if android
import openfl.Assets;
import openfl.utils.SystemPath;
//#end

class Screen extends Scene
{
	public static var overrideControlByBox:Bool;
	
	public function new() 
	{
		super();
		
		overrideControlByBox = false;
#if android
		var img:Image = new Image(Assets.getBitmapData("graphics/androidOverlay.png"));
		addGraphic(img, -999);
		img.scrollX = img.scrollY = 0;
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
	
	public function ifBoxUpdate()
	{
		
	}
	public function ifNotBoxUpdate()
	{
		
	}
	
	public override function update()
	{
		super.update();
		
		prevHatX = Input.joystick(0).hat.x;
		prevHatY = Input.joystick(0).hat.y;
		
		if (overrideControlByBox)
			ifBoxUpdate();
		else
			ifNotBoxUpdate();
	}
	
	private function ExitGame()
	{
		var config:Xml = Xml.createElement("settings");
#if android
		if ( FileSystem.exists(SystemPath.applicationStorageDirectory + "/config.xml") )
#else
		if ( FileSystem.exists("config.xml") )
#end
		{
			config.set("sound", Std.string(SettingsMenu.soudVolume));
			config.set("music", Std.string(SettingsMenu.musicVolume));
			config.set("language", SettingsMenu.language);
			
#if android
			File.saveContent(SystemPath.applicationStorageDirectory + "/config.xml", config.toString());
#else
			File.saveContent("config.xml", config.toString());
#end
		}
		
		System.exit(0);
	}
	
	public static function joyCheck(key:String):Bool
	{
		switch(key)
		{
			case "A":
				return Input.joystick(0).check(0);
			case "B":
				return Input.joystick(0).check(1);
			case "Y":
				return Input.joystick(0).check(3);
			case "X":
				return Input.joystick(0).check(2);
			case "LB":
				return Input.joystick(0).check(4);
			case "RB":
				return Input.joystick(0).check(5);
			case "DPAD_UP":
				if (Input.joystick(0).hat.y == -1)
					return true;
				else
					return false;
			case "DPAD_DOWN":
				if (Input.joystick(0).hat.y == 1)
					return true;
				else
					return false;
			case "DPAD_LEFT":
				if (Input.joystick(0).hat.x == -1)
					return true;
				else
					return false;
			case "DPAD_RIGHT":
				if (Input.joystick(0).hat.x == 1)
					return true;
				else
					return false;
			case "BACK":
				return Input.joystick(0).check(6);
			case "START":
				return Input.joystick(0).check(7);
			case "LS_BUTTON":
				return Input.joystick(0).check(8);
			case "RS_BUTTON":
				return Input.joystick(0).check(9);
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
				return Input.joystick(0).pressed(0);
			case "B":
				return Input.joystick(0).pressed(1);
			case "Y":
				return Input.joystick(0).pressed(3);
			case "X":
				return Input.joystick(0).pressed(2);
			case "LB":
				return Input.joystick(0).pressed(4);
			case "RB":
				return Input.joystick(0).pressed(5);
			case "DPAD_UP":
				if (Input.joystick(0).hat.y == -1 && prevHatY != -1)
					return true;
				else
					return false;
			case "DPAD_DOWN":
				if (Input.joystick(0).hat.y == 1 && prevHatY != 1)
					return true;
				else
					return false;
			case "DPAD_LEFT":
				if (Input.joystick(0).hat.x == -1  && prevHatX != -1)
					return true;
				else
					return false;
			case "DPAD_RIGHT":
				if (Input.joystick(0).hat.x == 1 && prevHatX != 1)
					return true;
				else
					return false;
			case "BACK":
				return Input.joystick(0).pressed(6);
			case "START":
				return Input.joystick(0).pressed(7);
			case "LS_BUTTON":
				return Input.joystick(0).pressed(8);
			case "RS_BUTTON":
				return Input.joystick(0).pressed(9);
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
				}
			}
		}
		return false;
	}
}