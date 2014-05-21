package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.Screen;
import com.tpuquest.screen.SettingsMenu;
import com.tpuquest.utils.DrawText;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import sys.io.File;

class DialogBox extends Dialog
{
	private var captionText:DrawText;
	private var messageText:DrawText;
	private var questions:DrawText;
	
	private var listOfAnswers:Array<String>;
	private var listOfQuestions:Array<String>;
	
	private static var minW:Int = 300;
	
	private var dialogsCount:Int;
	private var currentDialog:Int;
	
	private var currentScene:GameScreen;
	
	public function new(x:Float, y:Float, caption:String, currentAnswer:Int = -1) 
	{
		super(x, y);
		
		listOfAnswers = new Array<String>();
		listOfQuestions = new Array<String>();
		
		var message:String;
		var startMSG:String = "";
		var dialogs:Xml = Xml.parse(File.getContent( "cfg/dialog_talker.xml" )).firstElement();
		for (x in dialogs.elements())
		{
			if (Std.parseInt(x.get("type")) == -1)
			{
				if (x.get("answer_" + SettingsMenu.language) == null)
					startMSG = x.get("answer_ru");
				else
					startMSG = x.get("answer_" + SettingsMenu.language);
			}
			else
			{
				if (x.get("answer_" + SettingsMenu.language) == null || x.get("question_" + SettingsMenu.language) == null)
				{
					listOfAnswers.push(x.get("answer_ru"));
					listOfQuestions.push(x.get("question_ru"));
				}
				else
				{
					listOfAnswers.push(x.get("answer_" + SettingsMenu.language));
					listOfQuestions.push(x.get("question_" + SettingsMenu.language));
				}
			}
		}
		dialogsCount = listOfQuestions.length;
		
		if (currentAnswer == -1)
			message = startMSG;
		else
			message = listOfAnswers[currentAnswer];
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText(caption, GameFont.PixelCyr, 20, 150, 12, 0, true);
		
		var frameW:Int = minW;
		if (captionText.label.width + 10 > minW)
			frameW = captionText.label.width + 10;
			
		captionText.label.x = frameW / 2;
		
		messageText = new DrawText(listOfAnswers[0], GameFont.PixelCyr, 14, 5, 28, 0, false, frameW - 10, 0);
		
		var msgFrameH:Int = messageText.label.textHeight;
		messageText.label.richText = message;
		
		questions = new DrawText(updateDialogs(), GameFont.PixelCyr, 14, 5, 28 + msgFrameH, 0, false, frameW - 10, 0, false); 
		
		var questFrameH:Int = questions.label.textHeight;
		
		g.beginFill(0);
		g.drawRoundRect(0, 0, frameW, 28 + msgFrameH + 4 + questFrameH + 2, 10);
		g.endFill();
		g.beginFill(0x80d3eb);
		g.drawRoundRect(1, 1, frameW - 2, 28 + msgFrameH + 2 + questFrameH + 2, 10);
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
		g.drawRoundRect(2, 28 + msgFrameH + 3, frameW - 4, questFrameH + 1, 10);
		g.endFill();
		g.beginFill(0xd1d1d1);
		g.drawRoundRect(3, 28 + msgFrameH + 4, frameW - 6, questFrameH - 1, 10);
		g.endFill();
		
		var img:BitmapData = new BitmapData(frameW, 28 + msgFrameH + 4 + questFrameH + 2, true, 0xd1d1d1);
		img.draw(sprite);
		
		graphic = new Stamp(img);
		graphic.scrollX = graphic.scrollY = 0;
		
		addGraphic(captionText.label);
		addGraphic(messageText.label);
		addGraphic(questions.label);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		messageText.label.scrollX = messageText.label.scrollY = 0;
		questions.label.scrollX = questions.label.scrollY = 0;
		
		graphic.x -= frameW / 2;
		graphic.y -= 16 + msgFrameH / 2;
		
		layer = -50;
		Screen.overrideControlByBox = true;
	}
	
	public override function added()
	{
		if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
			currentScene = cast(scene, GameScreen);
	}
	
	/*private function setupGraphic(captionText:String, currentAnswer:Int = -1)
	{
		
	}*/
	
	private function updateDialogs():String
	{
		var temp:String = "";
		for (x in 0...listOfQuestions.length)
		{
			if(currentDialog == x)
				temp += ">  " + listOfQuestions[x] + "\n";
			else
				temp += "   " + listOfQuestions[x] + "\n";
		}
		return temp;
	}
	
	public override function update()
	{
		super.update();
		
		if ( Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			Screen.overrideControlByBox = false;
			this.scene.remove(this);
		}
		if (Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A") || Screen.touchPressed("action"))
		{
			//this = new DialogBox(x, y, captionText.label.richText, currentDialog);
			messageText.label.richText = listOfAnswers[currentDialog];
		}
		if (Input.pressed("down") || Screen.joyPressed("DPAD_DOWN") || Screen.touchPressed("down"))
		{
			currentDialog++;
			
			if (currentDialog > dialogsCount - 1)
				currentDialog = 0;
				
			questions.label.richText = updateDialogs();
		}	
		if (Input.pressed("up") || Screen.joyPressed("DPAD_UP") || Screen.touchPressed("up"))
		{
			currentDialog--;
			
			if (currentDialog < 0)
				currentDialog = dialogsCount - 1;
				
			questions.label.richText = updateDialogs();
		}
	}
}