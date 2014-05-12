package com.tpuquest.screen;
import com.haxepunk.Sfx;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.Player;
import com.tpuquest.entity.character.Talker;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.utils.Level;
import com.haxepunk.graphics.Image;
import flash.geom.Point;
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
	
	private var background:Image = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
	private var notInstantlyMapLoadingEngage:Bool = false;
	private var notInstantlyMapLoadingBackground:Image = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
	private var mapPathFromHelper:String = "";
	private var newPlayerFromHelper:Bool = false;
	private var notInstantlyMapLoadingUp:Bool = true;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		LoadCFG();
		LoadMap(cfgStartMap, true);
		
		background.scrollX = background.scrollY = 0;
        addGraphic(background).layer = 101;
		
		notInstantlyMapLoadingBackground.scrollX = notInstantlyMapLoadingBackground.scrollY = 0;
        notInstantlyMapLoadingBackground.color = 0;
		notInstantlyMapLoadingBackground.alpha = 0;
		addGraphic(notInstantlyMapLoadingBackground).layer = -101; 
		
		coinsText = new DrawText("000", GameFont.PixelCyr, 20, 700, 50, 0xFFFFFF, false);
		coinsText.label.scrollX = coinsText.label.scrollY = 0;
		addGraphic(coinsText.label, -5);
		
		hpText = new DrawText("100", GameFont.PixelCyr, 20, 700, 20, 0xFFFFFF, false);
		hpText.label.scrollX = hpText.label.scrollY = 0;
		addGraphic(hpText.label, -5);
		
		var coinImg:Image = new Image("graphics/items/coin.png");
		coinImg.scrollX = coinImg.scrollY = 0;
		
		var heartImg:Image = new Image("graphics/items/heart.png");
		heartImg.scrollX = heartImg.scrollY = 0;
		
		addGraphic(coinImg, -5, 670, 53);
		addGraphic(heartImg, -5, 670, 23);
		
		var bg:Image = new Image("graphics/clouds2.png");
		bg.scrollX = bg.scrollY = 0.05;
		addGraphic(bg, 100, -100);
		
		music = new Sfx("music/MightandMagic_Book1__ShopTheme.ogg");
		music.play(SettingsMenu.musicVolume / 10, 0, true);
		
		super.begin();
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK")) && !Screen.overrideControlByBox && !notInstantlyMapLoadingEngage)
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
		
		if (notInstantlyMapLoadingEngage)
		{
			if (notInstantlyMapLoadingUp)
			{
				notInstantlyMapLoadingBackground.alpha += 0.05;
				if (notInstantlyMapLoadingBackground.alpha == 1)
				{
					player = null;
					removeList( lvl.getEntities() );
					LoadMap(mapPathFromHelper, !newPlayerFromHelper);
					notInstantlyMapLoadingUp = false;
				}
			}
			else
			{
				notInstantlyMapLoadingBackground.alpha -= 0.05;
				if (notInstantlyMapLoadingBackground.alpha == 0)
					notInstantlyMapLoadingEngage = false;
			}
		}
		else
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
		
		var isExsist = false;
		for (x in lvl.characters)
		{
			if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.character.Player")
			{
				player = x;
				isExsist = true;
			}
		}
		if (!isExsist)
			player = new Player(new Point(0, 0), "graphics/characters/character.png", 100, 0, "Me", true);
		
		if (newPlayer)
		{
			player.life = cfgStartHP;
			player.money = cfgStartMoney;
		}
		
		HXP.camera.x = player.x - 400 + 20;
		HXP.camera.y = player.y - 300 + 40;
				
		addList( lvl.getEntities() );
		
		background = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        background.color = lvl.bgcolor;
		background.scrollX = background.scrollY = 0;
        addGraphic(background).layer = 101;
	}
	
	public function NextMap( mapPath:String , currentPlayer:Bool = true, instantly:Bool )
	{
		if (instantly)
		{
			removeList( lvl.getEntities() );
			LoadMap(mapPath, !currentPlayer);
		}
		else
		{
			notInstantlyMapLoadingEngage = true;
			mapPathFromHelper = mapPath;
			newPlayerFromHelper = currentPlayer;
			notInstantlyMapLoadingUp = true;
		}
	}
}