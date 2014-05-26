package com.tpuquest.dialog;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Stamp;
import com.haxepunk.HXP;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.MainMenu;
import com.tpuquest.screen.Screen;
import com.tpuquest.screen.SettingsMenu;
import com.tpuquest.utils.DrawText;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.tpuquest.utils.CLocals;

class GameMenu extends Dialog
{
	private var captionText:DrawText;
	private static var minW:Int = 240;
	
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
	private var settingsOn:Bool;
	
	private var currentScene:GameScreen;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		var sprite:Sprite = new Sprite();
        var g:Graphics = sprite.graphics;
		
		captionText = new DrawText("Пауза", GameFont.PixelCyr, 20, 150, 12, 0, true);
		
		var frameW:Int = minW;
		if (captionText.label.width + 10 > minW)
			frameW = captionText.label.width + 10;
			
		captionText.label.x = frameW / 2;
		
		var msgFrameH:Int = 65;
		
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_continue, GameFont.Molot, 18, frameW / 2, 40, activeColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_settings, GameFont.Molot, 18, frameW / 2, 60, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.gameMenu_Exit, GameFont.Molot, 18, frameW / 2, 80, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.settingsMenu_sound, GameFont.Molot, 18, 5, 35, passiveColor, false));
		textMenuElements.push(new DrawText(CLocals.text.settingsMenu_music, GameFont.Molot, 18, 5, 65, passiveColor, false));
		
		textMenuElements.push(new DrawText("//////----", GameFont.Molot, 18, frameW - frameW/2, 35, activeColor, false));
		textMenuElements.push(new DrawText("/////////-", GameFont.Molot, 18, frameW - frameW/2, 65, passiveColor, false));
		
		for (x in textMenuElements)
			x.label.scrollX = x.label.scrollY = 0;
			
		textMenuElements[3].label.visible = false;
		textMenuElements[4].label.visible = false;
		textMenuElements[5].label.visible = false;
		textMenuElements[6].label.visible = false;
		
		settingsOn = false;
		
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
		captionText.label.scrollX = captionText.label.scrollY = 0;
		
		for (i in 0...textMenuElements.length) 
		{
			addGraphic(textMenuElements[i].label);
		}
		changeMenu();
		
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
	
	public function changeMenu()
	{
		if (!settingsOn)
		{
			if (currentMenuElement < 0)
				currentMenuElement = 2;
			if (currentMenuElement > 2)
				currentMenuElement = 0;
		}
		else 
		{
			if (currentMenuElement < 5)
				currentMenuElement = 6;
			if (currentMenuElement > 6)
				currentMenuElement = 5;
		}
		
		for (i in 0...textMenuElements.length) 
		{
			if(i != currentMenuElement)
				textMenuElements[i].ChangeColor(passiveColor);
			else
				textMenuElements[i].ChangeColor(activeColor);
		}
	}
	
	private function updateMenu()
	{
		var temp:String = "";
		for (i in 0...SettingsMenu.soudVolume)
			temp += "/";
		for (i in SettingsMenu.soudVolume...10)
			temp += "-";
		textMenuElements[5].ChangeStr(temp, false);
		
		temp = "";
		for (i in 0...SettingsMenu.musicVolume)
			temp += "/";
		for (i in SettingsMenu.musicVolume...10)
			temp += "-";
		textMenuElements[6].ChangeStr(temp, false);
	}

	public function actionMenu(positive:Bool = true)
	{
		switch(currentMenuElement)
		{
			case 0:
				Screen.overrideControlByBox = false;
				this.scene.remove(this);
			case 1:
				settingsOn = true;
				textMenuElements[0].label.visible = false;
				textMenuElements[1].label.visible = false;
				textMenuElements[2].label.visible = false;
				
				textMenuElements[3].label.visible = true;
				textMenuElements[4].label.visible = true;
				textMenuElements[5].label.visible = true;
				textMenuElements[6].label.visible = true;
				
				currentMenuElement = 5;
				changeMenu();
				updateMenu();
			case 2:
				currentScene.music.stop();
				MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
				
				currentScene.lvl.SaveLevel(currentScene.cfgContinueMap);

				HXP.scene = new MainMenu();
			case 5:
				if(positive)
					SettingsMenu.soudVolume++;
				else
					SettingsMenu.soudVolume--;
				if (SettingsMenu.soudVolume < 0)
					SettingsMenu.soudVolume = 0;
				if (SettingsMenu.soudVolume > 10)
					SettingsMenu.soudVolume = 10;	
			case 6:
				if(positive)
					SettingsMenu.musicVolume++;
				else
					SettingsMenu.musicVolume--;
				if (SettingsMenu.musicVolume < 0)
					SettingsMenu.musicVolume = 0;
				if (SettingsMenu.musicVolume > 10)
					SettingsMenu.musicVolume = 10;
				currentScene.music.volume = SettingsMenu.musicVolume / 10;
		}
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			if (!settingsOn)
			{
				Screen.overrideControlByBox = false;
				this.scene.remove(this);
			}
			else
			{
				settingsOn = false;
				textMenuElements[0].label.visible = true;
				textMenuElements[1].label.visible = true;
				textMenuElements[2].label.visible = true;
				
				textMenuElements[3].label.visible = false;
				textMenuElements[4].label.visible = false;
				textMenuElements[5].label.visible = false;
				textMenuElements[6].label.visible = false;
		
				currentMenuElement = 0;
				changeMenu();
				cast(currentScene, Screen).SaveSettings();
			}
		}
		if (Input.pressed("up") || Screen.joyPressed("DPAD_UP") || Screen.touchPressed("up"))
		{
			currentMenuElement--;
			changeMenu();
		}
		if (Input.pressed("down") || Screen.joyPressed("DPAD_DOWN") || Screen.touchPressed("down"))
		{
			currentMenuElement++;
			changeMenu();
		}
		if ((Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A") || Screen.touchPressed("action")) && !settingsOn)
		{
			actionMenu();
		}
		if (Input.pressed("left") || Screen.joyPressed("DPAD_LEFT") || Screen.touchPressed("left"))
		{
			actionMenu(false);
			updateMenu();
		}
		if (Input.pressed("right") || Screen.joyPressed("DPAD_RIGHT") || Screen.touchPressed("right"))
		{
			actionMenu(true);
			updateMenu();
		}
		
		super.update();
	}
}