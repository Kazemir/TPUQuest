package com.tpuquest.screen;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.DrawText;
import com.haxepunk.utils.Input;

class LoseScreen extends Screen
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
		
		var sound:Sfx = new Sfx("audio/gameOver.wav");
		sound.play(SettingsMenu.soudVolume / 10);
		
		base = Image.createRect(HXP.width, HXP.height, 0, 0.99);
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = -5; 
	
		var img:Image = new Image("graphics/gameOver.png");
		addGraphic(img);
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
			
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		super.update();
	}
}