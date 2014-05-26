package com.tpuquest.screen;
import com.tpuquest.utils.DrawText;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.tpuquest.utils.CLocals;
import com.haxepunk.graphics.Text;

class SettingsMenu extends Screen
{
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
	public static var soudVolume:Int = 6;
	public static var musicVolume:Int = 9;
	public static var language:String = "ru";
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		var img:Image = new Image("graphics/bg.jpg");
		addGraphic(img);

		addGraphic(DrawText.CreateTextEntity(CLocals.text.mainMenu_settings, GameFont.Molot, 32, 400, 220, 0x0, true));
		addGraphic(DrawText.CreateTextEntity(CLocals.text.settingsMenu_sound, GameFont.Molot, 32, 150, 280, 0x0, false));
		addGraphic(DrawText.CreateTextEntity(CLocals.text.settingsMenu_music, GameFont.Molot, 32, 150, 320, 0x0, false));
		addGraphic(DrawText.CreateTextEntity(CLocals.text.settingsMenu_language, GameFont.Molot, 32, 150, 360, 0x0, false));
		
		textMenuElements.push(new DrawText("//////----", GameFont.Molot, 32, 475, 280, activeColor, false));
		textMenuElements.push(new DrawText("/////////-", GameFont.Molot, 32, 475, 320, passiveColor, false));
		textMenuElements.push(new DrawText("Русский", GameFont.Molot, 32, 475, 360, passiveColor, false));
		
		for (i in 0...textMenuElements.length) 
		{
			addGraphic(textMenuElements[i].label);
		}
		
		updateMenu();
		
		super.begin();
	}
	
	public function changeMenu()
	{
		if (currentMenuElement < 0)
			currentMenuElement = 2;
		if (currentMenuElement > 2)
			currentMenuElement = 0;
		
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
		for (i in 0...soudVolume)
			temp += "/";
		for (i in soudVolume...10)
			temp += "-";
		textMenuElements[0].ChangeStr(temp, false);
		
		temp = "";
		for (i in 0...musicVolume)
			temp += "/";
		for (i in musicVolume...10)
			temp += "-";
		textMenuElements[1].ChangeStr(temp, false);
		
		switch( language )
		{
			case "ru":
				textMenuElements[2].ChangeStr("Русский", false);
			case "en":
				textMenuElements[2].ChangeStr("English", false);			
			case "de":
				textMenuElements[2].ChangeStr("Deutsch", false);			
			case "ua":
				textMenuElements[2].ChangeStr("Українська", false);
			case "by":
				textMenuElements[2].ChangeStr("Беларуская", false);
			case "ga":
				textMenuElements[2].ChangeStr("Gagauzça", false);
			case "fr":
				textMenuElements[2].ChangeStr("Le français", false);
			case "es":
				textMenuElements[2].ChangeStr("Español", false);
			case "it":
				textMenuElements[2].ChangeStr("Lingua italiana", false);
			case "cz":
				textMenuElements[2].ChangeStr("Český", false);
		}
		CLocals.set( language );
	}
	
	private var currentLng:Int = 0;
	
	public function actionMenu(positive:Bool)
	{
		switch(currentMenuElement)
		{
			case 0:
				if(positive)
					soudVolume++;
				else
					soudVolume--;
				if (soudVolume < 0)
					soudVolume = 0;
				if (soudVolume > 10)
					soudVolume = 10;	
			case 1:
				if(positive)
					musicVolume++;
				else
					musicVolume--;
				if (musicVolume < 0)
					musicVolume = 0;
				if (musicVolume > 10)
					musicVolume = 10;
			case 2:
				var a : Array<String> = ["ru", "en", "de", "ua", "by", "ga", "fr", "es", "it", "cz"];
				currentLng = a.indexOf(SettingsMenu.language, 0);

				if(positive)
					currentLng++;
				else
					currentLng--;
					
				if (currentLng < 0)
					currentLng = a.length - 1;
				if (currentLng > a.length - 1)
					currentLng = 0;	
					
				SettingsMenu.language = a[currentLng];
		}
		MainMenu.menuMusic.volume = SettingsMenu.musicVolume / 10;
		updateMenu();
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			SaveSettings();
			HXP.scene = new MainMenu();
		}
		if (Input.pressed("up") || Screen.joyPressed("DPAD_UP") || Screen.touchPressed("up"))
		{
			currentMenuElement--;
		}
		if (Input.pressed("down") || Screen.joyPressed("DPAD_DOWN") || Screen.touchPressed("down"))
		{
			currentMenuElement++;
		}
		if (Input.pressed("left") || Screen.joyPressed("DPAD_LEFT") || Screen.touchPressed("left"))
		{
			actionMenu(false);
		}
		if (Input.pressed("right") || Screen.joyPressed("DPAD_RIGHT") || Screen.touchPressed("right"))
		{
			actionMenu(true);
		}
		changeMenu();
		
		super.update();
	}
}