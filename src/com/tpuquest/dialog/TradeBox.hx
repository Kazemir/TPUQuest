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
	public var priceList:Array<Int>;
	
	private static var minW:Int = 174;
	private var goodsCount:Int;
	private var currentGood:Int;
	
	public function new(x:Float, y:Float, caption:String, goods:Array<Item>, price:Array<Int>) 
	{
		super(x, y);
		
		traderList = goods;
		goodsCount = goods.length;
		currentGood = 0;
		priceList = price;
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText(caption, GameFont.PixelCyr, 20, 150, 12, 0, true);
		
		var frameW:Int = minW;
		if (captionText.label.width + 10 > minW)
			frameW = captionText.label.width + 10;
			
		captionText.label.x = frameW / 2;
		
		var tradeFrameH:Int = Math.ceil(goodsCount / 3) * 65 + 4;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, 28 + tradeFrameH + 4, 10);
		g.endFill();
		g.beginFill(0x80d3eb);
		g.drawRoundRect(1, 1, frameW - 2, 28 + tradeFrameH + 2, 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 2, frameW - 4, 24, 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(3, 3, frameW - 6, 22, 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(2, 27, frameW - 4, tradeFrameH + 3, 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(3, 28, frameW - 6, tradeFrameH + 1, 10);
		g.endFill();
		
		var img:BitmapData = new BitmapData(frameW, 28 + tradeFrameH + 4, true, 0xd1d1d1);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(captionText.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		
		for (id in 0...traderList.length)
		{
			traderList[id].graphic.x = (frameW - 104) / 2 + 52 * (id % 3) - traderList[id].halfWidth;
			traderList[id].graphic.y = 28 + 2 + 23 + (Math.ceil((id + 1) / 3) - 1) * 65 - traderList[id].halfHeight;
			traderList[id].graphic.scrollX = traderList[id].graphic.scrollY = 0;

			addGraphic(traderList[id].graphic);
			
			var tex:DrawText = new DrawText(Std.string(price[id]), GameFont.PixelCyr, 14, (frameW - 104) / 2 + 52 * (id % 3) +2, 28 + 2 + 50 + (Math.ceil((id + 1) / 3) - 1) * 65, 0, true);
			tex.label.scrollX = tex.label.scrollY = 0;
			addGraphic(tex.label);
		}
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 + tradeFrameH / 2;
		
		layer = -50;
		Screen.overrideControlByBox = true;
	}
	
	private function updateFrame()
	{
		
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
				
			updateFrame();
		}
		if (Input.pressed("right") || Screen.joyCheck("DPAD_RIGHT"))
		{
			currentGood--;
			
			if (currentGood < 0)
				currentGood = goodsCount - 1;
				
			updateFrame();
		}
	}
}