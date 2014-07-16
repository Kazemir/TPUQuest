package com.tpuquest.screen;

import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.SlopedGrid;
import com.haxepunk.Sfx;
import com.haxepunk.utils.Data;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import haxe.io.Error;

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

import com.tpuquest.entity.character.EnemyPlayer;
import cpp.net.ThreadServer.ThreadServer;
import cpp.vm.Thread;
import haxe.Timer;
import sys.net.Host;
import sys.net.Socket;
import sys.net.UdpSocket;

#if android
import openfl.utils.SystemPath;
#end

#if !flash
import sys.io.File;
import sys.FileSystem;
#end

class MultiplayerGameScreen extends Screen
{
	public var lvl:TileGridLevel;
	
	private var coinsText:DrawText;
	private var hpText:DrawText;
	public var player:Player;

	public var music:Sfx;
	
	private var background:Image;
	private var backgroundImage:Image;
	private var weaponImg:Image;
	
	private var gameMenu:GameMenu;
	
	private var isServer:Bool;
	private var sServer:Socket;
	private var sClient:Socket;
	private var isConnected:Bool;
	private var enemyPlayer:EnemyPlayer;
	private var netCommand:String;
	
	private var cfgServerHost:String;
	private var cfgServerPort:Int;
	private var cfgClientHost:String;
	private var cfgClientPort:Int;
	
	public function new( server:Bool ) 
	{
		super();
		
		this.isServer = server;
	}
	
	public override function begin()
	{
		isConnected = false;
		
		background = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
		
		LoadCFG();
		LoadMap("levels/net.xml", true);
		
		for (x in lvl.characters)
			x.behaviorOn = false;
		
		try
		{
			if (isServer)
			{
				trace("Starting server...");
				sServer = new Socket();
				sServer.bind(new Host(cfgServerHost), cfgServerPort);
				sServer.listen(1);
				sServer.setFastSend(true);
				//sServer.setTimeout(0);
				trace("Server started successfully: " + Std.string(sServer.host().host.toString()) + ":" + Std.string(sServer.host().port));
				
				Thread.create( function () 
				{
					try
					{
						sClient = sServer.accept();
						trace(Std.string(sClient.host().host.toString()) + ":" + Std.string(sClient.host().port) + ". Client connected...");
						isConnected = true;
						
						for (x in lvl.characters)
							x.behaviorOn = true;
						
						Thread.create( function ()
						{
							try
							{
								while (isConnected)
								{
									trace("beep");
									enemyPlayer.netCommand = sClient.input.readString(5);
									trace("Input command: " + enemyPlayer.netCommand);
									enemyPlayer.netFlag = true;
									trace("beep");
									
								}
							}
							catch (msg:String)
							{
								trace(msg);
							}
						});
					}
					catch (msg:String)
					{
						trace(msg);
					}
				});
			}
			else
			{
				trace("Starting client...");
				sClient = new Socket();
				sClient.setFastSend(true);
				//sClient.setTimeout(0);
				//trace("Client started successfully: " + Std.string(sClient.host().host.toString()) + ":" + Std.string(sClient.host().port));
				
				Thread.create( function () 
				{
					try
					{
						sClient.connect(new Host(cfgClientHost), cfgClientPort);
						trace("Client connected...");
						isConnected = true;
						
						for (x in lvl.characters)
							x.behaviorOn = true;
						
						Thread.create( function ()
						{
							try
							{
								while (isConnected)
								{
									trace("beep");
									
									enemyPlayer.netCommand = sClient.input.readString(5);
									trace("Input command: " + enemyPlayer.netCommand);
									enemyPlayer.netFlag = true;
									trace("beep");
									
								}
							}
							catch (msg:String)
							{
								trace(msg);
							}
						});
					}
					catch (msg:String)
					{
						trace(msg);
					}
				});
			}
		}
		catch (err:String)
		{
			trace(err);
			CloseScreen();
		}
		
		background.scrollX = background.scrollY = 0;
        addGraphic(background).layer = 101;
		
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
	
	private function LoadCFG()
	{
		var config:Xml = Xml.parse(Assets.getText( "cfg/netCFG.xml" )).firstElement();
		for (x in config.elements())
		{
			if (x.nodeName == "server")
			{
				cfgServerHost = x.get("host");
				cfgServerPort = Std.parseInt(x.get("port"));
			}
			if (x.nodeName == "client")
			{
				cfgClientHost = x.get("host");
				cfgClientPort = Std.parseInt(x.get("port"));
			}
		}
	}
	
	public function CloseScreen()
	{
		music.stop();
									trace("beep");
		
		isConnected = false;
		try
		{
			if (sServer != null)
			{
				sServer.close();
				trace("Server closed.");
			}
			if (sClient != null)
			{
				sClient.close();
				trace("Client closed.");
			}
									trace("beep");
			
		}
		catch (msg:String)
		{
			trace(msg);
									trace("beep");
			
		}
									trace("beep");
		
	}
	
	public override function update()
	{
		if ((Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.touchPressed("esc")) && !Screen.overrideControlByBox)
		{
			gameMenu = new GameMenu(HXP.halfWidth, HXP.halfHeight);
			add(gameMenu);
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
		
		if (isConnected)
		{
			//lrjae
			//left right jump action end
			netCommand = "";
			if (Input.check("left"))
				netCommand += "l";
			else
				netCommand += "-";
			if (Input.check("right"))
				netCommand += "r";
			else
				netCommand += "-";
			if (Input.check("jump"))
				netCommand += "j";
			else
				netCommand += "-";
			if (Input.check("action"))
				netCommand += "a";
			else
				netCommand += "-";
			if (!isConnected)
				netCommand += "e";
			else
				netCommand += "-";
									trace("beep");
			
			try
			{
				if (isServer && netCommand != "-----")
				{
									trace("beep");
					
					sClient.output.writeString(netCommand);
					trace("Output command: " + netCommand);
									trace("beep");
					
				}
				if (!isServer && netCommand != "-----")
				{
									trace("beep");
					
					sClient.output.writeString(netCommand);
					trace(netCommand);
									trace("beep");
					
				}
			}
			catch (msg:String)
			{
				trace(msg);
									trace("beep");
				
			}
		}
		
		super.update();
	}
	
	public function LoadMap( mapPath:String, fromAssets:Bool = true)
	{

		lvl = TileGridLevel.LoadLevel( mapPath, fromAssets );

		if (isServer)
		{
			for (x in lvl.characters)
			{
				if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.Player")
				{
					player = x;
				}
				if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.EnemyPlayer")
				{
					enemyPlayer = x;
				}
			}
		}
		else
		{
			for (x in lvl.characters)
			{
				if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.EnemyPlayer")
				{
					player = new Player(new Point(x.x, x.y), x.spritePath, x.life, x.money, x.weaponDamage);
					lvl.characters.push(player);
					lvl.characters.remove(x);
				}
			}
			for (x in lvl.characters)
			{
				if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.Player")
				{
					cast(x, Player).behaviorOn = false;
					enemyPlayer = new EnemyPlayer(new Point(x.x, x.y), x.spritePath, x.life, x.money, x.weaponDamage);
					lvl.characters.push(enemyPlayer);
					lvl.characters.remove(x);
				}
			}
		}
		
		addList( lvl.getEntities() );
		
		HXP.camera.x = player.x - 400 + 20;
		HXP.camera.y = player.y - 300 + 40;

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
}