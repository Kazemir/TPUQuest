package com.tpuquest.screen;
import com.haxepunk.Sfx;
import com.tpuquest.character.Enemy;
import com.tpuquest.character.Player;
import com.tpuquest.character.Talker;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.helper.Helper;
import com.tpuquest.item.Coin;
import com.tpuquest.item.Potion;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.world.Level;
import com.haxepunk.graphics.Image;
import sys.io.File;

class GameScreen extends Screen
{
	private var lvl:Level;
	
	private var coinsText:DrawText;
	private var hpText:DrawText;
	private var player:Player;

	private var music:Sfx;
	
	private var cfgStartMap:String;
	private var cfgContinueMap:String;
	private var cfgStartHP:Int;
	private var cfgStartMoney:Int;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		LoadCFG();
		LoadMap(cfgStartMap, true);
		
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
		
		//add(new Helper(Level.WorldToScreen(new PointXY( -6, -3)), "ChangeMap", true));
		

		
		var bg:Image = new Image("graphics/clouds2.png");
		bg.scrollX = bg.scrollY = 0.05;
		addGraphic(bg, 100, -100);
		
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
	
	private function LoadCFG()
	{
		var config:Xml = Xml.parse(File.getContent( "cfg/mainCFG.xml" )).firstElement();
		
		for (x in config.elements())
		{
			if (x.nodeName == "newgame")
			{
				cfgStartMap = x.get("mapPath");
				cfgStartHP = Std.parseInt(x.get("startHP"));
				cfgStartMoney = Std.parseInt(x.get("startMoney"));
			}
			if (x.nodeName == "continue")
			{
				cfgContinueMap = x.get("mapPath");
			}
		}
	}
	
	public function LoadMap( mapPath:String, newPlayer:Bool = false )
	{
		lvl = Level.LoadLevel( mapPath );
		addList( lvl.getEntities() );
		
		for (x in lvl.characters)
		{
			if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.character.Player")
				player = x;
		}
		
		if (newPlayer)
		{
			player.life = cfgStartHP;
			player.money = cfgStartMoney;
		}
	}
	
	public function NextMap( mapPath:String , newPlayer:Bool = false, instantly:Bool )
	{
		
	}
	
}