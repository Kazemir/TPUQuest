package com.tpuquest.screen;

import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.SlopedGrid;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Data;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;

import com.tpuquest.dialog.DialogBox;
import com.tpuquest.dialog.GameMenu;
import com.tpuquest.dialog.TradeBox;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.Player;
import com.tpuquest.entity.character.Talker;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Item;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.utils.CLocals;
import com.tpuquest.utils.TileGrid;
import com.tpuquest.utils.TileGridLevel;

import flash.geom.Point;

import openfl.Assets;

#if android
import openfl.utils.SystemPath;
#end

#if !flash
import sys.io.File;
import sys.FileSystem;
#end

class GameScreen extends Screen
{
	public var lvl:TileGridLevel;
	
	private var coinsText:DrawText;
	private var hpText:DrawText;
	public var player:Player;

	public var music:Sfx;
	
	private var cfgStartMap:String;
	public var cfgContinueMap:String;
	private var cfgStartHP:Int;
	private var cfgStartMoney:Int;
	
	private var background:Image;
	private var notInstantlyMapLoadingEngage:Bool;
	private var notInstantlyMapLoadingBackground:Image;
	private var mapPathFromHelper:String;
	private var newPlayerFromHelper:Bool;
	private var notInstantlyMapLoadingUp:Bool;
	
	private var backgroundImage:Image;
	private var itsContinue:Bool;
	
	private var weaponImg:Image;
	
	private var gameMenu:GameMenu;
	
	public function new(itsContinue:Bool) 
	{
		super();
		
		this.itsContinue = itsContinue;
	}
	
	public override function begin()
	{
		background = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
		notInstantlyMapLoadingBackground = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 0);

		notInstantlyMapLoadingUp = true;
		newPlayerFromHelper = false;
		mapPathFromHelper = "";
		notInstantlyMapLoadingEngage = false;

		LoadCFG();
		
		if(itsContinue)
			LoadMap(cfgContinueMap, false, false);
		else
		{
#if android
			if(!FileSystem.exists(SystemPath.applicationStorageDirectory + "levels/continue/"))
					FileSystem.createDirectory(SystemPath.applicationStorageDirectory + "levels/continue/");
			
			for (x in FileSystem.readDirectory(SystemPath.applicationStorageDirectory + "levels/continue/"))
				FileSystem.deleteFile(SystemPath.applicationStorageDirectory + "levels/continue/" + x);
#elseif flash
			Data.load("empty");
			Data.save("tpuquuest_levels", true);
#else
			if(!FileSystem.exists("levels/continue/"))
					FileSystem.createDirectory("levels/continue/");
			
			for (x in FileSystem.readDirectory("levels/continue/"))
					FileSystem.deleteFile("levels/continue/" + x);
#end
			LoadMap(cfgStartMap, true, true);
		}
		
		background.scrollX = background.scrollY = 0;
        addGraphic(background).layer = 101;
		
		notInstantlyMapLoadingBackground.scrollX = notInstantlyMapLoadingBackground.scrollY = 0;
        notInstantlyMapLoadingBackground.color = 0;
		notInstantlyMapLoadingBackground.alpha = 0;
		notInstantlyMapLoadingBackground.visible = false;
		addGraphic(notInstantlyMapLoadingBackground, -101);
		
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
		
		weaponImg = new Image("graphics/items/sword.png");
		weaponImg.scrollX = weaponImg.scrollY = 0;
		weaponImg.visible = false;
		
		addGraphic(coinImg, -5, 670, 53);
		addGraphic(heartImg, -5, 670, 23);
		addGraphic(weaponImg, -5, 685, 90);
#if flash
		music = new Sfx("music/MightandMagic_Book1__ShopTheme.mp3");
#else
		music = new Sfx("music/MightandMagic_Book1__ShopTheme.ogg");
#end
		music.play(SettingsMenu.musicVolume / 10, 0, true);
		
		super.begin();
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.touchPressed("esc")) && !Screen.overrideControlByBox && !notInstantlyMapLoadingEngage)
		{
			gameMenu = new GameMenu(HXP.halfWidth, HXP.halfHeight);
			add(gameMenu);
			
			for (x in lvl.characters)
				x.behaviorOn = false;
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
		
		if (player.weaponized)
			weaponImg.visible = true;
		else
			weaponImg.visible = false;
		
		if (notInstantlyMapLoadingEngage)
		{
			notInstantlyMapLoadingBackground.visible = true;
			if (notInstantlyMapLoadingUp)
			{
				notInstantlyMapLoadingBackground.alpha += 0.05;
				if (notInstantlyMapLoadingBackground.alpha == 1)
				{
					removeList( lvl.getEntities() );
					lvl.SaveLevel("levels/continue/" + lvl.levelName + ".xml");
#if android
					if (FileSystem.exists(SystemPath.applicationStorageDirectory + "levels/continue/" + mapPathFromHelper.split("/")[mapPathFromHelper.split("/").length - 1]))
#elseif flash
					Data.load("tpuquuest_levels");
					if (Data.read("levels/continue/" + mapPathFromHelper.split("/")[mapPathFromHelper.split("/").length - 1]) != null)
#else
					if (FileSystem.exists("levels/continue/" + mapPathFromHelper.split("/")[mapPathFromHelper.split("/").length - 1]))
#end
						LoadMap("levels/continue/" + mapPathFromHelper.split("/")[mapPathFromHelper.split("/").length - 1], false, false);
					else
						LoadMap(mapPathFromHelper, false, true);
					notInstantlyMapLoadingUp = false;
				}
			}
			else
			{
				notInstantlyMapLoadingBackground.alpha -= 0.05;
				if (notInstantlyMapLoadingBackground.alpha == 0)
				{
					notInstantlyMapLoadingEngage = false;
					notInstantlyMapLoadingBackground.visible = false;
				}
			}
		}
		else
			super.update();
	}
	
	private function LoadCFG()
	{
		var config:Xml = Xml.parse(Assets.getText( "cfg/mainCFG.xml" )).firstElement();
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
	
	public function LoadMap( mapPath:String, newPlayer:Bool = false, fromAssets:Bool = true)
	{

		lvl = TileGridLevel.LoadLevel( mapPath, fromAssets );
		
		var isExsist = false;

		for (x in lvl.characters)
		{
			if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.Player")
			{
				var player2:Player = x;
				if (player != null)
				{
					player2.weaponized = player.weaponized;
					player2.weaponDamage = player.weaponDamage;
					player2.life = player.life;
					player2.money = player.money;
				}
				player = player2;

				isExsist = true;
			}
		}
		if (!isExsist)
			player = new Player(new Point(0, 0), "graphics/characters/character.png", 100, 0, 0, "Me", true);
		
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

		if (backgroundImage != null)
			backgroundImage.visible = false;

		if (lvl.bgPicturePath != null)
		{
			backgroundImage = new Image(lvl.bgPicturePath);
			backgroundImage.scrollX = backgroundImage.scrollY = 0.05;
			backgroundImage.visible = true;
			addGraphic(backgroundImage, 100, -100);
			if(lvl.bgPicturePath == "graphics/MonsterKnifeBG.jpg")
				backgroundImage.y = -100;
		}
		
		if (lvl.levelName == "lav")
		{
			var enemyLAV:Sfx = new Sfx("audio/enemyLAV.wav");
			enemyLAV.play(SettingsMenu.soudVolume / 10);
		}

	}
	
	public function NextMap( mapPath:String , currentPlayer:Bool = true, instantly:Bool )
	{
		if (instantly)
		{
			removeList( lvl.getEntities() );
			lvl.SaveLevel("levels/continue/" + lvl.levelName + ".xml");
#if android
			if (FileSystem.exists(SystemPath.applicationStorageDirectory + "levels/continue/" + mapPath.split("/")[mapPath.split("/").length - 1]))
#elseif flash
			Data.load("tpuquuest_levels");
			if (Data.read("levels/continue/" + mapPath.split("/")[mapPath.split("/").length - 1]) != null)
#else
			if (FileSystem.exists("levels/continue/" + mapPath.split("/")[mapPath.split("/").length - 1]))
#end
				LoadMap("levels/continue/" + mapPath.split("/")[mapPath.split("/").length - 1], !currentPlayer, false );
			else
				LoadMap(mapPath, !currentPlayer, true);
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