package com.tpuquest.screen;
import com.tpuquest.utils.DrawText;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.tpuquest.utils.CLocals;

class AuthorsMenu extends Screen
{
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{	
		var img:Image = new Image("graphics/bg.jpg");
		addGraphic(img);
		
		addGraphic(DrawText.CreateTextEntity(CLocals.text.mainMenu_authors, GameFont.Molot, 32, 400, 220, 0x0, true));
		addGraphic(DrawText.CreateTextEntity(CLocals.text.authorsMenu_dasha, GameFont.Imperial, 24, 400, 320, 0x0, true));
		addGraphic(DrawText.CreateTextEntity(CLocals.text.authorsMenu_vova, GameFont.Imperial, 24, 400, 360, 0x0, true));
		addGraphic(DrawText.CreateTextEntity(CLocals.text.authorsMenu_misha, GameFont.Imperial, 24, 400, 400, 0x0, true));
		
		super.begin();
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		
		super.update();
	}
}