package com.tpuquest.dialog;

import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.utils.Input;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;

import com.tpuquest.utils.DrawText;
import com.tpuquest.screen.Screen;
import com.tpuquest.screen.MainMenu;
import com.tpuquest.utils.CLocals;

class YesNoBox extends Dialog
{
	private var captionText:DrawText;
	private var messageText:DrawText;
	private var yesNoText:DrawText;
	
	private static var minW:Int = 300;
	private static var scale:Float = 1.0;
	
	public function new(x:Float=0, y:Float=0, caption:String, message:String) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText(caption, GameFont.PixelCyr, Std.int(20*scale), Std.int(150*scale), Std.int(12*scale), 0, true);
		
		var frameW:Int = Std.int(minW * scale);
		if (captionText.label.width + Std.int(10*scale) > Std.int(minW*scale))
			frameW = captionText.label.width + Std.int(10*scale);
			
		captionText.label.x = frameW / 2;
		
		messageText = new DrawText(message, GameFont.PixelCyr, Std.int(14*scale), Std.int(5*scale), Std.int(28*scale), 0, false, frameW - Std.int(10*scale), 0);
		
		var msgFrameH:Int = messageText.label.textHeight;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, Std.int(28*scale) + msgFrameH + Std.int(4*scale) + Std.int(25*scale), 10);
		g.endFill();
		g.beginFill(0x80d3eb);
		g.drawRoundRect(Std.int(1*scale), Std.int(1*scale), Std.int(frameW - 2*scale), Std.int(28*scale + msgFrameH + 2*scale + 25*scale), 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(Std.int(2*scale), Std.int(2*scale), Std.int(frameW - 4*scale), Std.int(24*scale), 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(Std.int(3*scale), Std.int(3*scale), Std.int(frameW - 6*scale), Std.int(22*scale), 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(Std.int(2*scale), Std.int(27*scale), Std.int(frameW - 4*scale), Std.int(msgFrameH + 3*scale), 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(Std.int(3*scale), Std.int(28*scale), Std.int(frameW - 6*scale), Std.int(msgFrameH + 1*scale), 10);
		g.endFill();
		
		g.beginFill(0);
		g.drawRoundRect(Std.int(2*scale), Std.int(28*scale + msgFrameH + 3*scale), Std.int(frameW - 4*scale), Std.int(24*scale), 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(Std.int(3*scale), Std.int(28*scale + msgFrameH + 4*scale), Std.int(frameW - 6*scale), Std.int(22*scale), 10);
		g.endFill();
		
		yesNoText = new DrawText(CLocals.text.yesNoForBox, GameFont.PixelCyr, Std.int(14*scale), frameW / 2, Std.int(28*scale + msgFrameH + 14*scale), 0, true);
		
		var img:BitmapData = new BitmapData(frameW, Std.int(28*scale + msgFrameH + 4*scale + 25*scale), true, 0xd1d1d1);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(captionText.label);
		addGraphic(messageText.label);
		addGraphic(yesNoText.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		messageText.label.scrollX = messageText.label.scrollY = 0;
		yesNoText.label.scrollX = yesNoText.label.scrollY = 0;
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 * scale + msgFrameH / 2;
		
		layer = -50;
		
		Screen.overrideControlByBox = true;
	}
	
	public override function update()
	{
		super.update();
		
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			Screen.overrideControlByBox = false;
			this.scene.remove(this);
		}
		if (Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A") || Screen.touchPressed("action"))
		{
			MainMenu.menuMusic.stop();
			Screen.ExitGame();
		}
	}
}