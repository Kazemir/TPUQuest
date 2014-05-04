package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.utils.Draw;
import com.tpuquest.utils.DrawText;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;

class Dialog extends Entity
{
	private static var minW:Int = 300;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		var capText:DrawText = new DrawText("ЗаголовокЗаголовокЗаголовокЗаголовок", GameFont.PixelCyr, 20, 150, 12, 0, true);
		
		var frameW:Int = minW;
		if (capText.label.width + 10 > minW)
			frameW = capText.label.width + 10;
			
		capText.label.x = frameW / 2;
		
		var msgText:DrawText = new DrawText("Я помню как\n она стала моей. В теплый летний и без того радостный день, на голову свалилось еще большее счастье.", GameFont.PixelCyr, 14, 5, 28, 0, false, frameW - 10, 0);
		
		var msgFrameH:Int = msgText.label.textHeight;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, 28 + msgFrameH + 4, 10);
		g.endFill();
		g.beginFill(0x80d3eb);
		g.drawRoundRect(1, 1, frameW - 2, 28 + msgFrameH + 2, 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 2, frameW - 4, 24, 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(3, 3, frameW - 6, 22, 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 27, frameW - 4, msgFrameH + 3, 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(3, 28, frameW - 6, msgFrameH + 1, 10);
		g.endFill();
		
		var img:BitmapData = new BitmapData(frameW, 28 + msgFrameH + 4, true, 0xd1d1d1);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(capText.label);
		addGraphic(msgText.label);
		capText.label.scrollX = capText.label.scrollY = 0;
		msgText.label.scrollX = msgText.label.scrollY = 0;
	}
	
	public override function update()
	{
		super.update();
	}
}