package com.tpuquest.screen;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.DrawText;
import com.haxepunk.utils.Input;

class SplashScreen extends Screen
{
	private var base:Image;
	private var isDown:Bool;
	
	public function new() 
	{
		super();
		
		isDown = true;
	}
	
	public override function begin()
	{
		super.begin();
#if flash
		MainMenu.menuMusic = new Sfx("music/KineticLaw_HardcoreMode.mp3");
#else
		MainMenu.menuMusic = new Sfx("music/KineticLaw_HardcoreMode.ogg");
#end
		MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
		
		base = Image.createRect(HXP.width, HXP.height, 0, 0.99);
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = -5; 
		
		//var base2 = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        //base2.scrollX = base2.scrollY = 0;
        //addGraphic(base2).layer = 10; 
		
		var img:Image = new Image("graphics/controls.jpg");
		addGraphic(img).layer = 10;
		/*
		addGraphic(DrawText.CreateTextEntity("Курсовой проект по дисциплине", GameFont.PixelCyr, 36, HXP.width / 2, HXP.height / 2 - 25 - 50, 0, true));
		addGraphic(DrawText.CreateTextEntity("«Технология разработки программного обеспечения»", GameFont.PixelCyr, 26, HXP.width / 2, HXP.height / 2 + 25 - 50, 0, true));
	
		addGraphic(DrawText.CreateTextEntity("ИСПОЛНИТЕЛИ", GameFont.PixelCyr, 28, HXP.width / 2 - HXP.width / 4, HXP.height / 2 + 100, 0, true));
		addGraphic(DrawText.CreateTextEntity("Горбунова Д.А.", GameFont.PixelCyr, 20, HXP.width / 2 - HXP.width / 4, HXP.height / 2 + 140, 0, true));
		addGraphic(DrawText.CreateTextEntity("Кержин В.Ю.", GameFont.PixelCyr, 20, HXP.width / 2 - HXP.width / 4, HXP.height / 2 + 160, 0, true));
		addGraphic(DrawText.CreateTextEntity("Четвериков М.А.", GameFont.PixelCyr, 20, HXP.width / 2 - HXP.width / 4, HXP.height / 2 + 180, 0, true));
		
		addGraphic(DrawText.CreateTextEntity("РУКОВОДИТЕЛЬ", GameFont.PixelCyr, 28, HXP.width / 2 + HXP.width / 4, HXP.height / 2 + 100, 0, true));
		addGraphic(DrawText.CreateTextEntity("Заикин И.А.", GameFont.PixelCyr, 20, HXP.width / 2 + HXP.width / 4, HXP.height / 2 + 140, 0, true));
	
		var img:Image = new Image("graphics/gerbtpu.jpg"); 
		img.centerOrigin();
		img.scale = 0.35;
		addGraphic(img, 10, HXP.width / 2, 100);*/
	}
	
	public override function update()
	{
		if(base.alpha != 0 && isDown)
			base.alpha -= 0.01;
		else if (isDown && base.alpha == 0)
			isDown = false;
		else if(!isDown)
			base.alpha += 0.01;
		
		if (base.alpha == 1)
			HXP.scene = new MainMenu();
			
		if (Input.pressed("esc") || Input.pressed("action") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.joyPressed("A") || Screen.joyPressed("START") || Screen.touchPressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		super.update();
	}
}