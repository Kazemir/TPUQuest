package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.tpuquest.utils.DrawText;
import com.tpuquest.screen.Screen;
import com.tpuquest.entity.item.Item;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;

class TradeBox extends Dialog
{
	public var captionText:DrawText;
	public var traderList:Array<Item>;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText(caption, GameFont.PixelCyr, 20, 150, 12, 0, true);
		
		var frameW:Int = minW;
		if (captionText.label.width + 10 > minW)
			frameW = captionText.label.width + 10;
			
		captionText.label.x = frameW / 2;
		
		layer = -50;
		Screen.overrideControlByBox = true;
	}
	
	public override function update()
	{
		super.update();
		
		if (Input.pressed("action") || Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("A") || Screen.joyPressed("B"))
		{
			Screen.overrideControlByBox = false;
			this.scene.remove(this);
		}
	}
}