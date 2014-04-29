package com.tpuquest.screen;
import com.tpuquest.character.Player;
import com.tpuquest.character.Talker;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.item.Coin;
import com.tpuquest.item.Potion;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.world.Level;
import com.haxepunk.graphics.Image;

class GameScreen extends Screen
{
	private var lvl:Level;
	
	private var coinsText:DrawText;
	private var hpText:DrawText;
	private var player:Player;
	
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
		
		coinsText = new DrawText("000", GameFont.PixelCyr, 20, 700, 50, 0xFFFFFF, false);
		coinsText.label.scrollX = coinsText.label.scrollY = 0;
		addGraphic(coinsText.label);
		
		hpText = new DrawText("100", GameFont.PixelCyr, 20, 700, 20, 0xFFFFFF, false);
		hpText.label.scrollX = hpText.label.scrollY = 0;
		addGraphic(hpText.label);
		
		var coinImg:Image = new Image("items/coin.png");
		coinImg.scrollX = coinImg.scrollY = 0;
		var heartImg:Image = new Image("items/heart.png");
		heartImg.scrollX = heartImg.scrollY = 0;
		
		addGraphic(coinImg, 0, 670, 53);
		addGraphic(heartImg, 0, 670, 23);
		
		/*var test:Talker = new Talker(20, 50, 1, "Vince");
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
		addGraphic(test.underText.label);*/
		
		player = new Player(9 * 40, ( -3 + 7) * 40);
		add(player);
		
		add(new Coin(Level.WorldToScreen(new PointXY(8, -2)), 10));
		add(new Coin(Level.WorldToScreen(new PointXY(10, -2)), 5));
		add(new Coin(Level.WorldToScreen(new PointXY(12, -2)), 1));
		add(new Coin(Level.WorldToScreen(new PointXY(14, -2)), 3));
		
		add(new Potion(Level.WorldToScreen(new PointXY(6, 3)), 25));
		
		super.begin();
	}
	
	public override function update()
	{
		if (Input.pressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		
		var t:String = Std.string(player.money);
		for ( j  in 0...-t.length + 3)
		{
			t = "0" + t;
		}
		coinsText.ChangeStr(t, false);
		
		t = Std.string(player.life);
		for ( j  in 0...-t.length + 3)
		{
			t = "0" + t;
		}
		hpText.ChangeStr(t, false);
		
		super.update();
	}
	
}