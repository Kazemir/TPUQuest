package com.tpuquest.dialog;
import com.haxepunk.Graphic;
import com.tpuquest.utils.DrawText;
import flash.display.Graphics;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

class MessageBox extends Dialog
{
	public var text:DrawText;
	public var g:Graphic;
	
	public function new(x:Float, y:Float, caption:String, messageBoxText:String) 
	{
		super(x, y);
		
		text = new DrawText("SAMPLE TEXT", GameFont.PixelCyr, 16, 0, 0, 0xFFFFFF, false);
		text.label.wordWrap = true;
		text.label.text = "SAMPLE TEXT SAMPLE TEXT SAMPLE TEXT SAMPLE TEXT SAMPLE TEXT ";
		//add(text.overlay);
		g = text.label;
		//g.x = 200;
		//g.y = 200;
		//Graphics.
		//com.haxepunk.utils.Draw.
		addGraphic(Image.createRect(200, 200, 200, 1));
		addGraphic(g);
	}
}