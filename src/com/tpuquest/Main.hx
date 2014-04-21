package com.tpuquest;
import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.tpuquest.screen.*;
import com.tpuquest.unitTests.*;
import com.haxepunk.RenderMode;
import com.tpuquest.utils.CLocals;

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
#end
		HXP.screen.scale = 1;
		CLocals.set( "ru" );
		HXP.scene = new MainMenu();
	}

	public static function main() 
	{ 
		new Main();
	}
}