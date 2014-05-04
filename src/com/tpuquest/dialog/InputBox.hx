package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.tpuquest.utils.DrawText;
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
		
		addGraphic(captionText.label);
		addGraphic(messageText.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		messageText.label.scrollX = messageText.label.scrollY = 0;
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 + msgFrameH / 2;
		
		layer = -50;
		inputStr = "";
		
		var a:TextField = new TextField();
		a.type = TextFieldType.INPUT;
		a.multiline = false;
		a.wordWrap = false;
		//a.cursor = "ibeam";
		a.x = 200;
		a.y = 200;
		
		//addGraphic(a);
	}
	
	public function getInput():String
	{
		return inputStr;
	}
	
	public override function update()
	{
		super.update();
		
		if (Input.pressed("action") || Input.pressed("esc"))
		{
			this.scene.remove(this);
		}
		
		//if(Input.cl
	}
}