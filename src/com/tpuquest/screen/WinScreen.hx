package com.tpuquest.screen;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.tpuquest.dialog.InputBox;
import com.tpuquest.utils.DrawText;
import com.haxepunk.utils.Input;

class WinScreen extends Screen
{
	private var base:Image;
	private var music:Sfx;
	private var score:Int;
	
	private var iB:InputBox;
	private var waitingForAnswer:Bool;
	
	private var itsTime:Bool; 
	
	public function new( money:Int, hp:Int ) 
	{
		super();
		
		score = money * 5 + hp;
		
		itsTime = true;
		waitingForAnswer = false;
	}
	
	public override function begin()
	{
		super.begin();
		
		music = new Sfx("music/Factor6_Gianna.ogg");
		music.play(SettingsMenu.musicVolume / 10);
		
		base = Image.createRect(HXP.width, HXP.height, 0, 1.0);
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = -5; 
	
		var img:Image = new Image("graphics/youWin.png");
		addGraphic(img);
	}
	
	public override function update()
	{
		if (!Screen.overrideControlByBox && waitingForAnswer)
		{
			if (iB.getInput() != "")
			{
				ScoresMenu.LoadScores();
				ScoresMenu.AddNewResult(iB.getInput(), score);
				ScoresMenu.SaveScores();
			}
			waitingForAnswer = false;
			
			music.stop();
			MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
			
			HXP.scene = new MainMenu();
		}
		
		if(base.alpha != 0)
			base.alpha -= 0.01;
		
		if (itsTime && base.alpha == 0)
		{
			iB = new InputBox(HXP.halfWidth, HXP.halfHeight+HXP.halfHeight/2, "Сохранение рекорда", "Вы набрали " + Std.string(score) + " очков. Введите ваше имя:");
			add(iB);
			waitingForAnswer = true;
			itsTime = false;
		}
		
		/*if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc")) && !Screen.overrideControlByBox)
		{
			music.stop();
			MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
			
			HXP.scene = new MainMenu();
		}*/
		super.update();
	}
}