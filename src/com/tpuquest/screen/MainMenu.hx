package com.tpuquest.screen;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Input;
import com.tpuquest.utils.DrawText;
import flash.system.System;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.utils.Key;
import com.tpuquest.utils.CLocals;

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
		
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_newGame, GameFont.Molot, 32, 400, 240, activeColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_continue, GameFont.Molot, 32, 400, 280, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_settings, GameFont.Molot, 32, 400, 320, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_score, GameFont.Molot, 32, 400, 360, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_authors, GameFont.Molot, 32, 400, 400, passiveColor, true));
		textMenuElements.push(new DrawText(CLocals.text.mainMenu_exit, GameFont.Molot, 32, 400, 440, passiveColor, true));
		
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
			currentMenuElement = 5;
		if (currentMenuElement > 5)
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
				HXP.scene = new GameScreen();
			case 1:
				menuMusic.stop();
				//HXP.scene = new MainScene();
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
		if (Input.pressed("esc"))
		{
			menuMusic.stop();
			ExitGame();
		}
		if (Input.pressed("up"))
		{
			currentMenuElement--;
			changeMenu();
		}
		if (Input.pressed("down"))
		{
			currentMenuElement++;
			changeMenu();
		}
		if (Input.pressed("action"))
		{
			actionMenu();
		}
		if (Input.pressed(Key.L))
		{
			menuMusic.stop();
			HXP.scene = new LevelEditor();
		}
		
		super.update();
	}
}