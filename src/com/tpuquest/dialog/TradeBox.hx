package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.SettingsMenu;
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
	
	private var frameImg:Stamp;
	
	private var currentScene:GameScreen;
	private var frameW:Int;
	
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
		
		frameW = minW;
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
		
		var sprite2:Sprite = new Sprite();
        var g2:Graphics = sprite2.graphics;
		
		g2.beginFill(0);
		g2.drawRoundRect(0, 0, 34, 54, 10);
		g2.endFill();
		g2.beginFill(0xd1d1d1);
		g2.drawRoundRect(1, 1, 32, 52, 10);
		g2.endFill();
		
		var img2:BitmapData = new BitmapData(34, 54, true, 0xd1d1d1);
		img2.draw(sprite2);
		frameImg = new Stamp(img2);
		addGraphic(frameImg);
		frameImg.scrollX = frameImg.scrollY = 0;
		
		frameImg.x = (frameW - 110 - 26) / 2;
		frameImg.y = 36;
		
		for (id in 0...traderList.length)
		{
			traderList[id].graphic.x = (frameW - 104) / 2 + 52 * (id % 3) - traderList[id].halfWidth;
			traderList[id].graphic.y = 28 + 2 + 23 + (Math.ceil((id + 1) / 3) - 1) * 65 - traderList[id].halfHeight;
			traderList[id].graphic.scrollX = traderList[id].graphic.scrollY = 0;

			addGraphic(traderList[id].graphic);
			
			var tex:DrawText = new DrawText(Std.string(price[id]), GameFont.PixelCyr, 14, (frameW - 104) / 2 + 52 * (id % 3) + 2, 28 + 2 + 50 + (Math.ceil((id + 1) / 3) - 1) * 65, 0, true);
			tex.label.scrollX = tex.label.scrollY = 0;
			addGraphic(tex.label);
		}
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 + tradeFrameH / 2;
		
		layer = -50;
		Screen.overrideControlByBox = true;
	}
	
	public override function added()
	{
		if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
			currentScene = cast(scene, GameScreen);
	}
	
	private function updateFrame()
	{
		frameImg.x = (frameW - 110 - 26) / 2 + currentGood * 52;
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
			if (currentScene.player.money >= priceList[currentGood])
			{
				switch(Type.getClassName(Type.getClass(traderList[currentGood])))
				{
					case "com.tpuquest.entity.item.Potion":
						currentScene.player.life += cast(traderList[currentGood], Potion).potionAmount;
						if (currentScene.player.life > 100)
							currentScene.player.life = 100;
							
						var sound = new Sfx("audio/player_soundPotion.wav");
						sound.play(SettingsMenu.soudVolume / 10);
					case "com.tpuquest.entity.item.Weapon":
						currentScene.player.weaponized = true;
						currentScene.player.weaponDamage = cast(traderList[currentGood], Weapon).weaponDamage;
						
						var sound = new Sfx("audio/player_soundSword.wav");
						sound.play(SettingsMenu.soudVolume / 10);
				}
				currentScene.player.money -= priceList[currentGood];
			}
		}
		if (Input.pressed("right") || Screen.joyCheck("DPAD_RIGHT"))
		{
			currentGood++;
			
			if (currentGood > goodsCount - 1)
				currentGood = 0;
				
			updateFrame();
		}
		if (Input.pressed("left") || Screen.joyCheck("DPAD_LEFT"))
		{
			currentGood--;
			
			if (currentGood < 0)
				currentGood = goodsCount - 1;
				
			updateFrame();
		}
	}
}