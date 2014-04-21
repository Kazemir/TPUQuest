package com.tpuquest.screen;
import com.tpuquest.utils.DrawText;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.tpuquest.utils.CLocals;

class ScoresMenu extends Screen
{
	private var textPlayersElements:Array<DrawText> = new Array<DrawText>();
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		var img:Image = new Image("graphics/bg.jpg");
		addGraphic(img);
		
		addGraphic(DrawText.CreateTextEntity(CLocals.text.mainMenu_score, GameFont.Molot, 32, 400, 220, 0x0, true));
		
		for (i in 0...10) 
		{
			textPlayersElements.push(new DrawText("PLAYER", GameFont.Molot, 24, 220, 260 + i * 20, 0x000000, false));
			addGraphic(textPlayersElements[i].label);
		}
		for (i in 10...20) 
		{
			textPlayersElements.push(new DrawText("0000025", GameFont.Molot, 24, 480, 260 + (i-10)*20, 0x000000, false));
			addGraphic(textPlayersElements[i].label);
		}
		
		super.begin();
	}
	
	public override function update()
	{
		if (Input.pressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		
		super.update();
	}
}