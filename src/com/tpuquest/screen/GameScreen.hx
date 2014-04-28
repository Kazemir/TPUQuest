package com.tpuquest.screen;
import com.tpuquest.character.Player;
import com.tpuquest.character.Talker;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.world.Level;

class GameScreen extends Screen
{
	private var lvl:Level;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		lvl = Level.LoadLevel( "levels/new.xml" );
		addList( lvl.getEntities() );
		
		var base = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        base.color = lvl.bgcolor;
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = 100; 
		
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