package com.tpuquest.utils;
import com.haxepunk.graphics.Text;
import com.haxepunk.Entity;
import flash.text.TextFormatAlign;

enum GameFont {
        Imperial;
        Molot;
		Arial;
		PixelCyr;
		JoystixMonospace;
    }

class DrawText
{
	public var label:Text;
	public var center:Bool;
	
	public function new(str:String, font:GameFont, size:Int, x:Float, y:Float, color:Int = 0xFFFFFF, centred:Bool = true, width:Int = -1, height:Int = -1, centredAligm:Bool = true)
	{
		if (size <= 0 || color < 0 || color > 0xFFFFFF)
			throw "Error! Incorrect parameters!";
			
		var fnt;
		switch(font)
		{
			case Imperial:
				fnt = "font/Imperial.ttf";
			case Molot:
				fnt = "font/Molot.ttf";
			case Arial:
				fnt = "font/arial.ttf";
			case PixelCyr:
				fnt = "font/PixelCyr.ttf";
			case JoystixMonospace:
				fnt = "font/JoystixMonospace.ttf";
		}
		
		if(width == -1 || height == -1)
			label = new Text(str, x, y);
		else
		{
#if !flash
			if(centredAligm)
				label = new Text(str, x, y, width, height, { wordWrap:true, align:"center", size:size, font:fnt, resizable:false });
			else
				label = new Text(str, x, y, width, height, { wordWrap:true, align:"left", size:size, font:fnt, resizable:false });
#else
			if(centredAligm)
				label = new Text(str, x, y, width, height, { wordWrap:true, align:TextFormatAlign.CENTER, size:size, font:fnt, resizable:false });
			else
				label = new Text(str, x, y, width, height, { wordWrap:true, align:TextFormatAlign.LEFT, size:size, font:fnt, resizable:false });
#end
		}

		label.color = color;
		label.font = fnt;
		label.size = size;
		label.richText = str;
		
		center = centred;
		if(centred)
			label.centerOrigin();
	}
	
	public function ChangeStr(str:String, centred:Bool = true)
	{
		label.richText = str;
		if(centred)
			label.centerOrigin();
		center = centred;
	}
	
	public function ChangeColor(color:Int)
	{
		label.color = color;
		var temp:String = label.richText;
		label.richText = temp + " ";
		label.richText = temp;
	}
	
	public function ChangePoint(x:Float, y:Float)
	{
		label.x = x;
		label.y = y;
	}
	
	public function update(str:String, x:Float, y:Float, color:Int, centred:Bool = true)
	{
		label.color = color;
		label.richText = str;
		label.x = x;
		label.y = y;
		if(centred)
			label.centerOrigin();
		center = centred;
	}
	
	public static function CreateTextEntity(str:String, font:GameFont, size:Int, x:Float, y:Float, color:Int = 0xFFFFFF, centred:Bool = true):Text
	{
		var fnt;
		switch(font)
		{
			case Imperial:
				fnt = "font/Imperial.ttf";
			case Molot:
				fnt = "font/Molot.ttf";
			case Arial:
				fnt = "font/arial.ttf";
			case PixelCyr:
				fnt = "font/PixelCyr.ttf";
			case JoystixMonospace:
				fnt = "font/JoystixMonospace.ttf";
		}
		var fastText:Text = new Text(str, x, y);
		fastText.color = color;
		fastText.font = fnt;
		fastText.size = size;
		fastText.richText = str;
		
		if(centred)
			fastText.centerOrigin();
		
		return fastText;
	}
}