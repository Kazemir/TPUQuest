package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.utils.Input;
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
	
	private static var minW:Int = 300;
	private var goodsCount:Int;
	private var currentGood:Int;
	
	public function new(x:Float, y:Float, caption:String, goods:Array<Item>) 
	{
		super(x, y);
		
		traderList = goods;
		goodsCount = goods.length;
		currentGood = 0;
		
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
		
		if ( Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B"))
		{
			Screen.overrideControlByBox = false;
			this.scene.remove(this);
		}
		if (Input.pressed("action") || Screen.joyPressed("A"))
		{
			
		}
		if (Input.pressed("left") || Screen.joyCheck("DPAD_LEFT"))
		{
			currentGood++;
			if (currentGood > goodsCount - 1)
				currentGood = 0;
		}
		if (Input.pressed("right") || Screen.joyCheck("DPAD_RIGHT"))
		{
			currentGood--;
			if (currentGood < 0)
				currentGood = goodsCount - 1;
		}
	}
}