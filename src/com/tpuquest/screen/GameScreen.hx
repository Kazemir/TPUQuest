package com.tpuquest.screen;
import com.tpuquest.character.Player;
import com.tpuquest.character.Talker;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;

class GameScreen extends Screen
{

	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		var test:Talker = new Talker(20, 50, 1, "Vince");
		add(test);
		addGraphic(test.underText.label);
		
		test = new Talker(20, 100, 1.1, "Howard");
		add(test);
		addGraphic(test.underText.label);
		
		test = new Talker(20, 150, 0.75, "Naboo");
		add(test);
		addGraphic(test.underText.label);
		
		test = new Talker(20, 200, 1.25, "Bollo");
		add(test);
		addGraphic(test.underText.label);
		
		add(new Player(20, 300));
		
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