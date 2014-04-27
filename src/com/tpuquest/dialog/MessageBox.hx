package com.tpuquest.dialog;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Text;
import com.tpuquest.utils.DrawText;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

class MessageBox extends Dialog
{
	public var captionText:DrawText;
	public var messageText:DrawText;
	public var g:Graphic;
	
	public function new(x:Float, y:Float, caption:String, message:String) 
	{
		super(x, y);
		
		captionText = new DrawText("Заголовок", GameFont.PixelCyr, 20, 0, 0, 0xFFFFFF, false);
		captionText.label.align = flash.text.TextFormatAlign.CENTER;
		captionText.label.resizable = false;

		messageText = new DrawText("Я помню как она стала моей. В теплый летний и без того радостный день, на голову свалилось еще большее счастье. Пусть со сломанным двигателем и подвеской, пусть без документов и со скрипящими колесами.", GameFont.PixelCyr, 16, 0, 50, 0xFFFFFF, false, 100, 150);
		messageText.label.wordWrap = true;
		messageText.label.align = flash.text.TextFormatAlign.CENTER;
		messageText.label.resizable = false;

		addGraphic(Image.createRect(200, 200, 200, 1));
		addGraphic(captionText.label);
		addGraphic(messageText.label);
		
		 //var sprite:Sprite = new Sprite;
          // var g:Graphics = sprite.graphics;
			//g.
		captionText.ChangeStr(Std.string(messageText.label.width), false);
	}
}