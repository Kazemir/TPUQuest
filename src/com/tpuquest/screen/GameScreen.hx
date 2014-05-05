package com.tpuquest.screen;
import com.haxepunk.Sfx;
import com.tpuquest.character.Enemy;
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

	private var music:Sfx;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		lvl = Level.LoadLevel( "levels/fungus.xml" );
		addList( lvl.getEntities() );
		
		var base = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        base.color = lvl.bgcolor;
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = 101; 
		
		coinsText = new DrawText("000", GameFont.PixelCyr, 20, 700, 50, 0xFFFFFF, false);
		coinsText.label.scrollX = coinsText.label.scrollY = 0;
		addGraphic(coinsText.label, -5);
		
		hpText = new DrawText("100", GameFont.PixelCyr, 20, 700, 20, 0xFFFFFF, false);
		hpText.label.scrollX = hpText.label.scrollY = 0;
		addGraphic(hpText.label, -5);
		
		var coinImg:Image = new Image("items/coin.png");
		coinImg.scrollX = coinImg.scrollY = 0;
		
		var heartImg:Image = new Image("items/heart.png");
		heartImg.scrollX = heartImg.scrollY = 0;
		
		addGraphic(coinImg, -5, 670, 53);
		addGraphic(heartImg, -5, 670, 23);
		
		player = new Player(Level.WorldToScreen(new PointXY(0, -3)));
		add(player);
		
		add(new Coin(Level.WorldToScreen(new PointXY(8, -2)), 10));
		add(new Coin(Level.WorldToScreen(new PointXY(10, -2)), 5));
		add(new Coin(Level.WorldToScreen(new PointXY(12, -2)), 1));
		add(new Coin(Level.WorldToScreen(new PointXY(14, -2)), 3));
		
		add(new Potion(Level.WorldToScreen(new PointXY(6, 3)), 25));
		
		add(new Enemy(Level.WorldToScreen(new PointXY( -6, 4))));
		add(new Enemy(Level.WorldToScreen(new PointXY(11, -2))));
		
		var bg:Image = new Image("graphics/clouds2.png");
		bg.scrollX = bg.scrollY = 0.05;
		addGraphic(bg, 100, -100);
		
		/*var base2 = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        base2.color = lvl.bgcolor;
        addGraphic(base2, 101);*/
		
		music = new Sfx("music/MightandMagic_Book1__ShopTheme.ogg");
		music.play(SettingsMenu.musicVolume / 10, 0, true);
		
		super.begin();
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK")) && !Screen.overrideControlByBox)
		{
			music.stop();
			MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
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