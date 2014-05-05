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

import com.haxepunk.utils.Joystick;
//import com.haxepunk.utils.XBOX_GAMEPAD;
//import com.haxepunk.utils.JoyButtonState;

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
		
		super.begin();
	}
	
	public override function update()
	{
		super.update();
		
		prevHatX = Input.joystick(0).hat.x;
		prevHatY = Input.joystick(0).hat.y;
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
}