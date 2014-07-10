package com.tpuquest.utils;

import com.haxepunk.graphics.Text;

import flash.text.TextFormatAlign;

class GameFont2
{
	public static var Imperial:String = "font/Imperial.ttf";
	public static var Molot:String = "font/Molot.ttf";
	public static var Arial:String = "font/arial.ttf";
	public static var PixelCyr:String = "font/PixelCyr.ttf";
	public static var JoystixMonospace:String = "font/JoystixMonospace.ttf";
}

class DrawText2 extends Text
{
	public function new(str:String, x:Float, y:Float, font:GameFont2, size:Int, color:Int = 0xFFFFFF, align:TextFormatAlign = TextFormatAlign.CENTER, centerOrigin:Bool = true, width:Int = 0, height:Int = 0)
	{
		if(width != 0 || height != 0)
			super(str, x, y, width, height, { font:font, size:size, align:align, color:color, resizable:false, wordWrap:true } );
		else
			super(str, x, y, 0, 0, { font:font, size:size, color:color} );
		
		if(centerOrigin)
			centerOrigin();
	}
}