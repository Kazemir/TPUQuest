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

import openfl.geom.Point;

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

import pgr.dconsole.DC;

typedef Spawn = { x:Float, y:Float, client: Int };

class MultiplayerGameScreen extends GameScreen
{
	private var isServer:Bool;
	private var sServer:Socket;
	private var sClient:Socket;
	public var isConnected:Bool;
	private var enemyPlayer:EnemyPlayer;
	private var netCommand:String;
	
	private var cfgHost:String;
	private var cfgPort:Int;
	
	public function new( server:Bool, port:Int = 65142, host:String = "80.83.192.224" )
	{
		super(false);
		
		isMultiplayer = true;
		
		this.isServer = server;
		this.cfgHost = host;
		this.cfgPort = port;
	}
	
	public override function begin()
	{
		isConnected = false;
		
		background = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
		
		LoadMap("levels/net2.xml", false, true);
		
		DC.clearMonitor();
		DC.monitorField(player, "x", "player.x");
		DC.monitorField(player, "y", "player.y");
		DC.monitorField(enemyPlayer, "x", "enemyPlayer.x");
		DC.monitorField(enemyPlayer, "y", "enemyPlayer.y");
		
		for (x in lvl.characters)
			x.behaviorOn = false;
		
		try
		{
			if (isServer)
			{
				trace("Starting server...");
				sServer = new Socket();
				//sServer.bind(new Host(Host.localhost()), cfgPort);
				sServer.bind(new Host(cfgHost), cfgPort);
				sServer.listen(1);
				sServer.setFastSend(true);
				
				trace("Server started successfully: " + sServer.host().host.toString() + ":" + Std.string(sServer.host().port));
			}
			else
			{
				trace("Starting client...");
				sClient = new Socket();
				sClient.setFastSend(true);
				
				trace("Client started successfully! Waiting for connection...");
			}
			Thread.create( function () 
			{
				try
				{
					if (isServer)
					{
						sClient = sServer.accept();
						trace("Client connected from " + sClient.host().host.toString() + ":" + Std.string(sClient.host().port) + "!");
					}
					else
					{
						sClient.connect(new Host(cfgHost), cfgPort);
						trace("Client connected to " + sClient.peer().host.toString() + ":" + Std.string(sClient.peer().port) + "!");
					}
					isConnected = true;
					
					for (x in lvl.characters)
						x.behaviorOn = true;
					
					var tim:Timer = new Timer(10);
					tim.run = function ()
					{
						try
						{
							if (!isConnected)
							{
								tim.stop();
								return;
							}
							var tX:String = Std.string(player.x);
							var tY:String = Std.string(player.y);
							var lenX:String = Std.string(tX.length);
							var lenY:String = Std.string(tY.length);
							sClient.write("2" + lenX + "|" + tX + lenY +"|" + tY + "\n");
							//trace("2" + lenX + "|" + tX + lenY +"|" + tY);
						}
						catch (msg:String)
						{
							trace(msg);
						}
					};
					
					Thread.create( function ()
					{
						var msg:String = "";
						while (isConnected)
						{
							try
							{
								sClient.waitForRead();
								if (isConnected)
								{
									msg = sClient.input.readLine();// readString(5);
									if (msg.charAt(5) == "e" && msg.charAt(0) == "1")
									{
										isConnected == false;
										CloseScreen();
										HXP.scene = new MainMenu();
									}
								}
								else
									continue;
							}
							catch (msg:String)
							{
								trace(msg);
								CloseScreen();
							}
							//trace("Input command: " + msg + ", len: " + Std.string(msg.length));
							if (msg.charAt(0) == "1")
							{
								enemyPlayer.netCommand = msg.substring(1, msg.length - 1);
								enemyPlayer.netFlag = true;
							}
							else if (msg.charAt(0) == "2")
							{
								//trace(msg);
								var firstB:Int = msg.indexOf("|", 1);
								var lenX:Int = Std.parseInt(msg.substring(1, firstB));
								var tX:Float = Std.parseFloat(msg.substr(firstB + 1, lenX));
								msg = msg.substring(firstB + 1 + lenX, msg.length);
								var secondB:Int = msg.indexOf("|", 0);
								var lenY:Int = Std.parseInt(msg.substring(0, secondB));
								var tY:Float = Std.parseFloat(msg.substr(secondB + 1, lenY));
								//trace("firstB, lenX, tX, msg, secondB, lenY, tY");
								//trace(firstB, lenX, tX, msg, secondB, lenY, tY);
								enemyPlayer.x = tX;
								enemyPlayer.y = tY;
							}
						}
					});
				}
				catch (msg:String)
				{
					trace(msg);
					CloseScreen();
				}
			});
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
	}
	
	public function CloseScreen()
	{
		music.stop();
		
		if (isConnected)
		{
			sClient.write("1----e");
		}
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
		}
		catch (msg:String)
		{
			trace(msg);
		}
		
		DC.clearMonitor();
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
			t = "0" + t;
		
		coinsText.ChangeStr(t, false);
		
		t = Std.string(player.life);
		for ( j  in 0...-t.length + 3)
			t = "0" + t;
		
		hpText.ChangeStr(t, false);
		
		if (player.weaponized)
			weaponImg.visible = true;
		else
			weaponImg.visible = false;
		
		if (isConnected && !Screen.overrideControlByBox)
		{
			//lrjae
			//left right jump action end
			netCommand = "1";
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
			
			try
			{
				if (netCommand != "1-----")
				{
					sClient.write(netCommand + "\n");
					//trace("Output command: " + netCommand);
				}
			}
			catch (msg:String)
			{
				trace(msg);
			}
		}
		
		super.update();
	}
	
	public override function LoadMap( mapPath:String, newPlayer:Bool = false, fromAssets:Bool = true)
	{
		lvl = TileGridLevel.LoadLevel( mapPath, fromAssets );
		
		if (isServer)
		{
			var points:Array<Spawn> = new Array<Spawn>();
			var a:Int = 0;
			for (x in lvl.helpers)
			{
				if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.helper.SpawnPoint")
				{
					points.push( { x:x.x, y:x.y, client: a } );
					a++;
				}
			}
			
			player = new Player(new Point(points[0].x, points[0].y), "", 100, 0, 10, "Server");
			enemyPlayer = new EnemyPlayer(new Point(points[2].x, points[2].y), "", 100, 0, 10, "Enemy");
			
			lvl.characters.push(player);
			lvl.characters.push(enemyPlayer);
		}
		else
		{
			var points:Array<Spawn> = new Array<Spawn>();
			var a:Int = 0;
			for (x in lvl.helpers)
			{
				if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.helper.SpawnPoint")
				{
					points.push( { x:x.x, y:x.y, client: a } );
					a++;
				}
			}
			
			player = new Player(new Point(points[2].x, points[2].y), "", 100, 0, 10, "Server");
			enemyPlayer = new EnemyPlayer(new Point(points[0].x, points[0].y), "", 100, 0, 10, "Enemy");
			
			lvl.characters.push(player);
			lvl.characters.push(enemyPlayer);
		}
		
		addList( lvl.getEntities() );
		
		HXP.camera.x = player.x - HXP.halfWidth + 20;
		HXP.camera.y = player.y - HXP.halfHeight + 40;
		
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