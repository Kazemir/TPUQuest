package com.tpuquest.screen;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Data;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import com.tpuquest.dialog.TradeBox;
import com.tpuquest.utils.DrawText;
import flash.geom.Point;
import flash.system.System;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.utils.Key;
import com.tpuquest.utils.CLocals;
import openfl.Assets;

#if android
import openfl.utils.SystemPath;
#end

#if !flash
import sys.io.File;
import sys.FileSystem;
#end

class MainMenu extends Screen
{
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private static var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
	public static var menuMusic:Sfx;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		var img:Image = new Image("graphics/bg.jpg");
		addGraphic(img);
		
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_newGame, GameFont.Molot, 32, HXP.halfWidth, 240, activeColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_continue, GameFont.Molot, 32, HXP.halfWidth, 280, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_settings, GameFont.Molot, 32, HXP.halfWidth, 320, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_score, GameFont.Molot, 32, HXP.halfWidth, 360, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_authors, GameFont.Molot, 32, HXP.halfWidth, 400, passiveColor, true));
#if windows
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_exit, GameFont.Molot, 32, HXP.halfWidth, 440, passiveColor, true));
#end
		
		for (i in 0...textMenuElements.length) 
		{
			addGraphic(textMenuElements[i].label);
		}
		
		changeMenu();
		
		super.begin();
	}
	
	public function changeMenu()
	{
		if (currentMenuElement < 0)
			currentMenuElement = textMenuElements.length - 1;
		if (currentMenuElement > textMenuElements.length - 1)
			currentMenuElement = 0;
		
		for (i in 0...textMenuElements.length) 
		{
			if(i != currentMenuElement)
				textMenuElements[i].ChangeColor(passiveColor);
			else
				textMenuElements[i].ChangeColor(activeColor);
		}
	}
	
	public function actionMenu()
	{
		switch(currentMenuElement)
		{
			case 0:
				menuMusic.stop();
				HXP.scene = new GameScreen(false);
			case 1:
#if android
				if (FileSystem.exists(SystemPath.applicationStorageDirectory + "levels/continuePlay_map.xml"))
#elseif flash
				Data.load("tpuquuest_levels");
				if (Data.read("levels/continuePlay_map.xml") != null)
#else
				if (FileSystem.exists("levels/continuePlay_map.xml"))
#end
				{
					menuMusic.stop();
					HXP.scene = new GameScreen(true);
				}
			case 2:
				HXP.scene = new SettingsMenu();
			case 3:
				HXP.scene = new ScoresMenu();
			case 4:
				HXP.scene = new AuthorsMenu();
			case 5:
				menuMusic.stop();
				ExitGame();
		}
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
#if !android
			menuMusic.stop();
#end
			ExitGame();
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
		if (Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A") || Screen.touchPressed("action"))
		{
			actionMenu();
		}
		if (Input.pressed(Key.L) || Screen.joyPressed("LS_BUTTON"))
		{
			menuMusic.stop();
			HXP.scene = new LevelEditor();
		}
		
		super.update();
	}
}