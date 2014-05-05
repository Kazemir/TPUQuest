package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.tpuquest.utils.DrawText;
import com.tpuquest.screen.Screen;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import flash.text.TextField;
import flash.text.TextFieldType;

class InputBox extends Dialog
{
	public var captionText:DrawText;
	public var messageText:DrawText;
	public var inputText:DrawText;
	public var inputStr:String;
	
	private static var minW:Int = 300;
	
	public function new(x:Float, y:Float, caption:String, message:String) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText(caption, GameFont.PixelCyr, 20, 150, 12, 0, true);
		
		var frameW:Int = minW;
		if (captionText.label.width + 10 > minW)
			frameW = captionText.label.width + 10;
			
		captionText.label.x = frameW / 2;
		
		messageText = new DrawText(message, GameFont.PixelCyr, 14, 5, 28, 0, false, frameW - 10, 0);
		
		var msgFrameH:Int = messageText.label.textHeight;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, 28 + msgFrameH + 4 + 25, 10);
		g.endFill();
		g.beginFill(0x80d3eb);
		g.drawRoundRect(1, 1, frameW - 2, 28 + msgFrameH + 2 + 25, 10);
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
		
		g.beginFill(0);
		g.drawRoundRect(2, 28 + msgFrameH + 3, frameW - 4, 24, 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(3, 28 + msgFrameH + 4, frameW - 6, 22, 10);
		g.endFill();
		
		inputText = new DrawText("", GameFont.PixelCyr, 14, frameW / 2, 28 + msgFrameH + 14, 0, true, frameW - 10, 20);
		
		var img:BitmapData = new BitmapData(frameW, 28 + msgFrameH + 4 + 25, true, 0xd1d1d1);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(captionText.label);
		addGraphic(messageText.label);
		addGraphic(inputText.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		messageText.label.scrollX = messageText.label.scrollY = 0;
		inputText.label.scrollX = inputText.label.scrollY = 0;
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 + msgFrameH / 2;
		
		layer = -50;
		inputStr = "-1";
		
		Input.keyString = "";
		
		Screen.overrideControlByBox = true;
	}
	
	public function getInput():String
	{
		return inputStr;
	}
	
	public override function update()
	{
		super.update();
		
		if (Input.pressed("action") || Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("A") || Screen.joyPressed("B"))
		{
			Screen.overrideControlByBox = false;
			inputStr = inputText.label.richText;
			this.scene.remove(this);
		}
		
		inputText.label.richText = Input.keyString;
		
		if (Input.pressed(Key.NUMPAD_DECIMAL))
			inputText.label.richText += ".";
		
	}
}