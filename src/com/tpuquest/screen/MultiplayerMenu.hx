package com.tpuquest.screen;

import com.tpuquest.utils.DrawText;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.tpuquest.utils.CLocals;
import com.haxepunk.graphics.Text;

class MultiplayerMenu extends Screen
{
	private var textMenuElements:Array<DrawText> = new Array<DrawText>();
	private var currentMenuElement:Int = 0;
	
	private var passiveColor = 0x000000;
	private var activeColor = 0xFF0000;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		var img:Image = new Image("graphics/bg.jpg");
		img.scaleX = HXP.width / img.width;
		img.scaleY = HXP.height / img.height;
		addGraphic(img);
		
		addGraphic(DrawText.CreateTextEntity("Сетевая игра", GameFont.Molot, 32, HXP.halfWidth, 220, 0x0, true));
		
		textMenuElements.push(new DrawText("Запустить сервер", GameFont.Molot, 32, HXP.halfWidth, 320, passiveColor, true));
		textMenuElements.push(new DrawText("Присоеденится к игре", GameFont.Molot, 32, HXP.halfWidth, 360, passiveColor, true));
		
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
				MainMenu.menuMusic.stop();
				HXP.scene = new MultiplayerGameScreen(true, 65142);
			case 1:
				MainMenu.menuMusic.stop();
				HXP.scene = new MultiplayerGameScreen(false);// , 65142, "localhost");// "80.83.192.224");
		}
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc")) && !Screen.overrideControlByBox)
		{
			HXP.scene = new MainMenu();
		}
		if ((Input.pressed("up") || Screen.joyPressed("DPAD_UP") || Screen.touchPressed("up")) && !Screen.overrideControlByBox)
		{
			currentMenuElement--;
			changeMenu();
		}
		if ((Input.pressed("down") || Screen.joyPressed("DPAD_DOWN") || Screen.touchPressed("down")) && !Screen.overrideControlByBox)
		{
			currentMenuElement++;
			changeMenu();
		}
		if ((Input.pressed("action") || Screen.joyPressed("START") || Screen.joyPressed("A") || Screen.touchPressed("action")) && !Screen.overrideControlByBox)
		{
			actionMenu();
		}
		
		super.update();
	}
}