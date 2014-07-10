package com.tpuquest.utils;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.utils.Data;
import com.tpuquest.entity.character.Boss;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.Player;
import com.tpuquest.entity.character.Talker;
import com.tpuquest.entity.character.Trader;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
import com.tpuquest.entity.helper.KillTheHuman;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.Spawn;
import com.tpuquest.entity.helper.Teleporter;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Item;
import com.tpuquest.entity.character.Character;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.utils.PointXY;
import com.tpuquest.entity.Tile;
import com.tpuquest.entity.Sticker;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.geom.Point;

import haxe.xml.*;

#if !flash
import sys.FileSystem;
import sys.io.File;
#end

#if android
import openfl.utils.SystemPath;
#end

import openfl.Assets;

class Level
{
	public var items:Array<Dynamic>;
	public var characters:Array<Dynamic>;
	public var tiles:Array<Dynamic>;
	public var stickers:Array<Dynamic>;
	public var helpers:Array<Dynamic>;
	
	public var cameraPos:PointXY;
	
	public var bgcolor:Int;
	public var levelName:String;
	public var bgPicturePath:String;
	
	public static function ScreenToWorld(vector:PointXY):PointXY
	{
		var rvec:PointXY = new PointXY(Std.int(vector.x / 40) - 9, Std.int(vector.y / 40) - 9 );
		return rvec;
	}
	public static function WorldToScreen(vector:PointXY):PointXY
	{
		var rvec:PointXY = new PointXY((vector.x + 9) * 40, (vector.y + 7) * 40);
		return rvec;
	}
	
	public static function ScreenToWorldFloat(vector:Point):Point
	{
		var rvec:Point = new Point(vector.x / 40 - 9, vector.y / 40 - 9 );
		return rvec;
	}
	public static function WorldToScreenFloat(vector:Point):Point
	{
		var rvec:Point = new Point((vector.x + 9) * 40, (vector.y + 7) * 40);
		return rvec;
	}
	
	public function new( name:String = "New Level" ) 
	{
		items = new Array<Dynamic>();
		characters = new Array<Dynamic>();
		tiles = new Array<Dynamic>();
		stickers = new Array<Dynamic>();
		helpers = new Array<Dynamic>();
		
		cameraPos = new PointXY(0, 0);
		bgcolor = 0x61c3ff;
		levelName = name;
		bgPicturePath = "";
	}
	
	public static function LoadLevel( path:String, fromAssets:Bool = true, behavior:Bool = true ):Level
	{
		var lvl:Level = new Level();
		var lvlXML:Xml;

		if (fromAssets)
		{
			lvlXML = Xml.parse(Assets.getText( path )).firstElement();
		}
		else
		{
#if android
		lvlXML = Xml.parse(File.getContent( SystemPath.applicationStorageDirectory + path )).firstElement();
#elseif flash
		Data.load("tpuquuest_levels");
		lvlXML = Xml.parse(Data.read(path)).firstElement();
#else
		lvlXML = Xml.parse(File.getContent( path )).firstElement();
#end
		}
		
		lvl.bgcolor = Std.parseInt(lvlXML.get("bgcolor"));
		lvl.levelName = lvlXML.get("name");
		lvl.bgPicturePath = lvlXML.get("bgpicture");
		for (section in lvlXML.elements())
		{
			switch( section.nodeName )
			{
				case "items":
					for (element in section.elements())
					{
						var temp:Item;
						var tX = Std.parseInt(element.get("x"));
						var tY = Std.parseInt(element.get("y"));
						switch(element.get("type"))
						{
							case "coin":
								var tAmount = Std.parseInt(element.get("coinAmount"));
								temp = new Coin(WorldToScreen(new PointXY(tX, tY)), tAmount, element.get("path"));
							case "potion":
								var tAmount = Std.parseInt(element.get("potionAmount"));
								temp = new Potion(WorldToScreen(new PointXY(tX, tY)), tAmount, element.get("path"));
							case "weapon":
								var tDamage = Std.parseInt(element.get("weaponDamage"));
								temp = new Weapon(WorldToScreen(new PointXY(tX, tY)), tDamage, element.get("path"));
							default:
								temp = new Item(WorldToScreen(new PointXY(tX, tY)));
						}
						lvl.items.push( temp );
					}
				case "characters":
					for (element in section.elements())
					{
						var temp:Character;
						var tX = Std.parseFloat(element.get("x"));
						var tY = Std.parseFloat(element.get("y"));
						var tS = element.get("spritePath");
						var tN = element.get("name");
						switch(element.get("type"))
						{
							case "talker":
								temp = new Talker(WorldToScreenFloat(new Point(tX, tY)), tS, tN, behavior);
							case "trader":
								temp = new Trader(WorldToScreenFloat(new Point(tX, tY)), tS, tN, behavior);
							case "enemy":
								var tHP = Std.parseInt(element.get("hp"));
								var tET = Std.parseInt(element.get("enemyType"));
								temp = new Enemy(WorldToScreenFloat(new Point(tX, tY)), tS, tHP, tET, tN, behavior);
							case "player":
								var tHP = Std.parseInt(element.get("hp"));
								var tM = Std.parseInt(element.get("money"));
								var tWD = Std.parseInt(element.get("weaponDamage"));
								temp = new Player(WorldToScreenFloat(new Point(tX, tY)), tS, tHP, tM, tWD, tN, behavior);
							case "boss":
								var tHP = Std.parseInt(element.get("hp"));
								temp = new Boss(WorldToScreenFloat(new Point(tX, tY)), tS, tHP, tN, behavior);
							default:
								temp = new Character(WorldToScreenFloat(new Point(tX, tY)), tS, tN, behavior);
						}
						
						lvl.characters.push( temp );
					}
				case "tiles":
					for (element in section.elements())
					{
						var tX = Std.parseInt(element.get("x"));
						var tY = Std.parseInt(element.get("y"));
						var tC = Std.parseInt(element.get("collidability"));
						var tCb:Bool = false;
						if (tC == 1)
							tCb = true;
						var tP = element.get("path");
						var tS = element.get("soundPath");
						var temp:Tile = new Tile(WorldToScreen(new PointXY(tX, tY)), tCb, tP, tS);
						lvl.tiles.push( temp );
					}
				case "stickers":
					for (element in section.elements())
					{
						var tX = Std.parseInt(element.get("x"));
						var tY = Std.parseInt(element.get("y"));
						var tB = Std.parseInt(element.get("behindCreatures"));
						var tBb:Bool = false;
						if (tB == 1)
							tBb = true;
						var tP = element.get("path");
						var temp:Sticker = new Sticker(WorldToScreen(new PointXY(tX, tY)), tBb, tP);
						lvl.stickers.push( temp );
					}
				case "helpers":
					for (element in section.elements())
					{
						var tX = Std.parseInt(element.get("x"));
						var tY = Std.parseInt(element.get("y"));
						var tN = element.get("name");
						var temp:Helper = new Helper(WorldToScreen(new PointXY(tX, tY)), tN, !behavior);
						switch(element.get("type"))
						{
							case "message":
								temp = new ShowMessage(WorldToScreen(new PointXY(tX, tY)), tN, !behavior);
							case "nextlevel":
								var tMP = element.get("mapPath");
								var tCP = Std.parseInt(element.get("currentPlayer"));
								var tCP_b = false;
								if (tCP == 1)
									tCP_b = true;
								var tI = Std.parseInt(element.get("instantly"));
								var tI_b = false;
								if (tI == 1)
									tI_b = true;
								temp = new ChangeMap(WorldToScreen(new PointXY(tX, tY)), tMP, tCP_b, tI_b, tN, !behavior);
							case "spawn":
								temp = new Spawn(WorldToScreen(new PointXY(tX, tY)), tN, !behavior);
							case "teleporter":
								var tXto = Std.parseInt(element.get("xTo"));
								var tYto = Std.parseInt(element.get("yTo"));
								temp = new Teleporter(WorldToScreen(new PointXY(tX, tY)), WorldToScreen(new PointXY(tXto, tYto)), tN, !behavior);
							case "killer":
								temp = new KillTheHuman(WorldToScreen(new PointXY(tX, tY)), tN, !behavior);
						}
						
						lvl.helpers.push( temp );
					}
			}
		}
			
		return lvl;
	}

	public function SaveLevel( path:String )
	{
		var lvlXML:Xml = Xml.createElement( "level" );
		lvlXML.set("bgcolor", Std.string(bgcolor));
		lvlXML.set("name", levelName);
		if(bgPicturePath != null && bgPicturePath != "")
			lvlXML.set("bgpicture", bgPicturePath);

		var itemsXML:Xml = Xml.createElement( "items" );
		for (x in items)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX = x.itemPoint.x;
			var tY = x.itemPoint.y;
			
			tX = Std.int((tX / 40) - 9);
			tY = Std.int((tY / 40) - 7);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.entity.item.Coin":
					temp.set("type", "coin");
					temp.set("coinAmount", Std.string(x.coinAmount));
					temp.set("path", x.imgPath);
				case "com.tpuquest.entity.item.Potion":
					temp.set("type", "potion");
					temp.set("potionAmount", Std.string(x.potionAmount));
					temp.set("path", x.imgPath);
				case "com.tpuquest.entity.item.Weapon":
					temp.set("type", "weapon");
					temp.set("weaponDamage", Std.string(x.weaponDamage));
					temp.set("path", x.imgPath);
			}
			itemsXML.addChild(temp);
		}
		
		var charactersXML:Xml = Xml.createElement( "characters" );
		for (x in characters)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX:Float = x.x;
			var tY:Float = x.y;
			
			tX = (tX / 40) - 9;
			tY = (tY / 40) - 7;
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("name", x.characterName);
			temp.set("spritePath", x.spritePath);
			
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.entity.character.Talker":
					temp.set("type", "talker");
				case "com.tpuquest.entity.character.Trader":
					temp.set("type", "trader");
				case "com.tpuquest.entity.character.Enemy":
					temp.set("type", "enemy");		
					temp.set("hp", x.life);
					temp.set("enemyType", x.enemyType);
				case "com.tpuquest.entity.character.Boss":
					temp.set("type", "boss");	
					temp.set("hp", x.life);
				case "com.tpuquest.entity.character.Player":
					temp.set("type", "player");
					temp.set("hp", x.life);
					temp.set("money", x.money);
					temp.set("weaponDamage", x.weaponDamage);
			}
			charactersXML.addChild(temp);
		}
		
		var tilesXML:Xml = Xml.createElement( "tiles" );
		for (x in tiles)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX = x.tilePoint.x;
			var tY = x.tilePoint.y;
			
			tX = Std.int((tX / 40) - 9);
			tY = Std.int((tY / 40) - 7);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("path", x.imgPath);
			temp.set("soundPath", x.soundPath);
			var t = 0;
			if (x.collidability == true)
				t = 1;
			temp.set("collidability", Std.string(t));
			tilesXML.addChild(temp);
		}
		
		var stickersXML:Xml = Xml.createElement( "stickers" );
		for (x in stickers)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX = x.tilePoint.x;
			var tY = x.tilePoint.y;
			
			tX = Std.int((tX / 40) - 9);
			tY = Std.int((tY / 40) - 7);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("path", x.imgPath);
			var t = 0;
			if (x.behindCreatures == true)
				t = 1;
			temp.set("behindCreatures", Std.string(t));
			stickersXML.addChild(temp);
		}
		
		var helpersXML:Xml = Xml.createElement( "helpers" );
		for (x in helpers)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX = x.helperPoint.x;
			var tY = x.helperPoint.y;
			
			tX = Std.int((tX / 40) - 9);
			tY = Std.int((tY / 40) - 7);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("name", x.helperName);
			
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.entity.helper.ShowMessage":
					temp.set("type", "message");
				case "com.tpuquest.entity.helper.ChangeMap":
					temp.set("type", "nextlevel");
					temp.set("mapPath", x.nextMapPath);
					var tKP:Int = 0;
					if (x.keepPlayer)
						tKP = 1;
					temp.set("currentPlayer", Std.string(tKP));
					var tI:Int = 0;
					if (x.instantly)
						tI = 1;
					temp.set("instantly", Std.string(tI));
				case "com.tpuquest.entity.helper.Spawn":
					temp.set("type", "spawn");		
				case "com.tpuquest.entity.helper.Teleporter":
					temp.set("type", "teleporter");
					temp.set("xTo", Std.string(Std.int((x.pointTo.x / 40) - 9)));
					temp.set("yTo", Std.string(Std.int((x.pointTo.y / 40) - 7)));
				case "com.tpuquest.entity.helper.KillTheHuman":
					temp.set("type", "killer");
					
			}
			helpersXML.addChild(temp);
		}
		
		lvlXML.addChild(itemsXML);
		lvlXML.addChild(charactersXML);
		lvlXML.addChild(tilesXML);
		lvlXML.addChild(stickersXML);
		lvlXML.addChild(helpersXML);
		
#if android
		File.saveContent(SystemPath.applicationStorageDirectory + path, lvlXML.toString());
#elseif flash
		Data.load("tpuquuest_levels");
		Data.write(path, lvlXML.toString());
		Data.save("tpuquuest_levels");
#else
		File.saveContent(path, lvlXML.toString());
#end
	}
	
	public function SaveOldInNewFormat( path:String, columnsW:Int, rowsH:Int  )
	{
		var lvlXML:Xml = Xml.createElement( "level" );
		lvlXML.set("bgcolor", Std.string(bgcolor));
		lvlXML.set("name", levelName);
		if(bgPicturePath != null && bgPicturePath != "")
			lvlXML.set("bgpicture", bgPicturePath);
		
		lvlXML.set("columnsW", Std.string(columnsW));
		lvlXML.set("rowsH", Std.string(rowsH));
		
		var itemsXML:Xml = Xml.createElement( "items" );
		for (x in items)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX = x.itemPoint.x;
			var tY = x.itemPoint.y;
			
			tX = Std.int((tX / 40) - 9) + Std.int(columnsW / 2);
			tY = Std.int((tY / 40) - 7) + Std.int(rowsH / 2);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.entity.item.Coin":
					temp.set("type", "coin");
					temp.set("coinAmount", Std.string(x.coinAmount));
					temp.set("path", x.imgPath);
				case "com.tpuquest.entity.item.Potion":
					temp.set("type", "potion");
					temp.set("potionAmount", Std.string(x.potionAmount));
					temp.set("path", x.imgPath);
				case "com.tpuquest.entity.item.Weapon":
					temp.set("type", "weapon");
					temp.set("weaponDamage", Std.string(x.weaponDamage));
					temp.set("path", x.imgPath);
			}
			itemsXML.addChild(temp);
		}
		
		var charactersXML:Xml = Xml.createElement( "characters" );
		for (x in characters)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX:Float = x.x;
			var tY:Float = x.y;
			
			tX = (tX / 40) - 9 + Std.int(columnsW / 2);
			tY = (tY / 40) - 7 + Std.int(rowsH / 2);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("name", x.characterName);
			temp.set("spritePath", x.spritePath);
			
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.entity.character.Talker":
					temp.set("type", "talker");
				case "com.tpuquest.entity.character.Trader":
					temp.set("type", "trader");
				case "com.tpuquest.entity.character.Enemy":
					temp.set("type", "enemy");		
					temp.set("hp", x.life);
					temp.set("enemyType", x.enemyType);
				case "com.tpuquest.entity.character.Boss":
					temp.set("type", "boss");	
					temp.set("hp", x.life);
				case "com.tpuquest.entity.character.Player":
					temp.set("type", "player");
					temp.set("hp", x.life);
					temp.set("money", x.money);
					temp.set("weaponDamage", x.weaponDamage);
			}
			//trace(x.x, x.y, "->", tX, tY, Std.int(columnsW / 2), Std.int(rowsH / 2));
			charactersXML.addChild(temp);
		}
		
		var tilesXML:Xml = Xml.createElement( "tiles" );
		//var tilesMap:TileGrid = new TileGrid(0, 0, 0, columnsW, rowsH, "graphics/tileset.png", 40, 40, true);
		for (x in tiles)
		{
			var id:Int = -1;
			switch(x.imgPath)
			{
				case "graphics/tiles/brick.png":
					id = 0;
				case "graphics/tiles/brickWall.png":
					id = 1;
				case "graphics/tiles/brickWall2.png":
					id = 2;
				case "graphics/tiles/brickWall3.png":
					id = 3;
				case "graphics/tiles/brickWallDoorDown.png":
					id = 4;
				case "graphics/tiles/brickWallDoorUp.png":
					id = 5;
				case "graphics/tiles/brickWallLeft3.png":
					id = 6;
				case "graphics/tiles/brickWallLeftDown1.png":
					id = 7;
				case "graphics/tiles/brickWallLeftUp1.png":
					id = 8;
				case "graphics/tiles/brickWallMiddleDown1.png":
					id = 9;
				case "graphics/tiles/brickWallMiddleUp1.png":
					id = 10;
				case "graphics/tiles/brickWallRightDown1.png":
					id = 11;
				case "graphics/tiles/brickWallRightUp1.png":
					id = 12;
				case "graphics/tiles/brickWallUp.png":
					id = 13;
				case "graphics/tiles/grass.png":
					id = 14;
				case "graphics/tiles/grass_ground.png":
					id = 15;
				case "graphics/tiles/ground.png":
					id = 16;
				case "graphics/tiles/marble.png":
					id = 17;
				case "graphics/tiles/marble2.png":
					id = 18;
				case "graphics/tiles/marble3.png":
					id = 19;
				case "graphics/tiles/marble4.png":
					id = 20;
				case "graphics/tiles/planksLeft.png":
					id = 21;
				case "graphics/tiles/planksMiddle.png":
					id = 22;
				case "graphics/tiles/planksRight.png":
					id = 23;
				case "graphics/tiles/wall_ground.png":
					id = 24;
				case "graphics/tiles/wood.png":
					id = 25;
				case "graphics/tiles/wood2.png":
					id = 26;
				case "graphics/tiles/wood3.png":
					id = 27;
				case "graphics/tiles/wood4.png":
					id = 28;
				case "graphics/tiles/wood5.png":
					id = 29;
				case "graphics/tiles/woodenWallLeftDown.png":
					id = 30;
				case "graphics/tiles/woodenWallLeftMiddle.png":
					id = 31;
				case "graphics/tiles/woodenWallLeftUp.png":
					id = 32;
				case "graphics/tiles/woodenWallMiddle.png":
					id = 33;
				case "graphics/tiles/woodenWallMiddleDown.png":
					id = 34;
				case "graphics/tiles/woodenWallMiddleUp.png":
					id = 35;
			}
			
			var tX = x.tilePoint.x;
			var tY = x.tilePoint.y;
			
			tX = Std.int((tX / 40) - 9) + Std.int(columnsW / 2);
			tY = Std.int((tY / 40) - 7) + Std.int(rowsH / 2);
			//trace(x.tilePoint.x, x.tilePoint.y, "->", tX, tY, Std.int(columnsW / 2), Std.int(rowsH / 2));
			//tilesMap.addTile(tX, tY, id, x.collidability);
			
			var temp:Xml = Xml.createElement( "element" );
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("id", Std.string(id));
			temp.set("solid", Std.string(x.collidability));
			
			tilesXML.addChild(temp);
		}
		//tilesXML.set("tilesData", tilesMap.tileMap.saveToString());
		//tilesXML.set("maskData", tilesMap.collideGrid.saveToString(",", "\n", "1", "0"));
		
		var stickersXML:Xml = Xml.createElement( "stickers" );
		//var stickersMapBehind:TileGrid = new TileGrid(0, 0, 1, columnsW, rowsH, "graphics/stickerset.png", 40, 40, false);
		//var stickersMap:TileGrid = new TileGrid(0, 0, -1, columnsW, rowsH, "graphics/stickerset.png", 40, 40, false);
		for (x in stickers)
		{
			var id:Int = -1;
			switch(x.imgPath)
			{
				case "graphics/stickers/banner.png":
					id = 0;
				case "graphics/stickers/banner2.png":
					id = 1;
				case "graphics/stickers/bones.png":
					id = 2;
				case "graphics/stickers/crystal.png":
					id = 3;
				case "graphics/stickers/doorDown.png":
					id = 4;
				case "graphics/stickers/doorUp.png":
					id = 5;
				case "graphics/stickers/fenceLeft.png":
					id = 6;
				case "graphics/stickers/fenceMiddle.png":
					id = 7;
				case "graphics/stickers/fenceRight.png":
					id = 8;
				case "graphics/stickers/fish.png":
					id = 9;
				case "graphics/stickers/fish2.png":
					id = 10;
				case "graphics/stickers/flower.png":
					id = 11;
				case "graphics/stickers/flower2.png":
					id = 12;
				case "graphics/stickers/flower3.png":
					id = 13;
				case "graphics/stickers/flower4.png":
					id = 14;
				case "graphics/stickers/flower5.png":
					id = 15;
				case "graphics/stickers/grass.png":
					id = 16;
				case "graphics/stickers/grass2.png":
					id = 17;
				case "graphics/stickers/grass3.png":
					id = 18;
				case "graphics/stickers/grass4.png":
					id = 19;
				case "graphics/stickers/grass5.png":
					id = 20;
				case "graphics/stickers/grass6.png":
					id = 21;
				case "graphics/stickers/grassyRock.png":
					id = 22;
				case "graphics/stickers/grassyRock2.png":
					id = 23;
				case "graphics/stickers/grave.png":
					id = 24;
				case "graphics/stickers/grave2.png":
					id = 25;
				case "graphics/stickers/light.png":
					id = 26;
				case "graphics/stickers/mushrooms.png":
					id = 27;
				case "graphics/stickers/mushrooms2.png":
					id = 28;
				case "graphics/stickers/onion.png":
					id = 29;
				case "graphics/stickers/picture.png":
					id = 30;
				case "graphics/stickers/picture2.png":
					id = 31;
				case "graphics/stickers/plant.png":
					id = 32;
				case "graphics/stickers/rock.png":
					id = 33;
				case "graphics/stickers/rock2.png":
					id = 34;
				case "graphics/stickers/shield.png":
					id = 35;
				case "graphics/stickers/window.png":
					id = 36;
				case "graphics/stickers/window2.png":
					id = 37;
				case "graphics/stickers/window3.png":
					id = 38;
				case "graphics/stickers/window4.png":
					id = 39;
				case "graphics/stickers/window5.png":
					id = 40;
				case "graphics/stickers/windowFlowers.png":
					id = 41;
			}
			
			var tX = x.tilePoint.x;
			var tY = x.tilePoint.y;
			
			tX = Std.int((tX / 40) - 9) + Std.int(columnsW / 2);
			tY = Std.int((tY / 40) - 7) + Std.int(rowsH / 2);
			
			//if(x.behindCreatures)
			//	stickersMapBehind.addTile(tX, tY, id, false);
			//else
			//	stickersMap.addTile(tX, tY, id, false);
			
			var temp:Xml = Xml.createElement( "element" );
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("id", Std.string(id));
			temp.set("behind", Std.string(x.behindCreatures));
			
			stickersXML.addChild(temp);
		}
		//stickersXML.set("tilesDataBehind", stickersMapBehind.tileMap.saveToString());
		//stickersXML.set("tilesData", stickersMap.tileMap.saveToString());
		
		var helpersXML:Xml = Xml.createElement( "helpers" );
		for (x in helpers)
		{
			var temp:Xml = Xml.createElement( "element" );
			var tX = x.helperPoint.x;
			var tY = x.helperPoint.y;
			
			tX = Std.int((tX / 40) - 9) + Std.int(columnsW / 2);
			tY = Std.int((tY / 40) - 7) + Std.int(rowsH / 2);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			temp.set("name", x.helperName);
			
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.entity.helper.ShowMessage":
					temp.set("type", "message");
				case "com.tpuquest.entity.helper.ChangeMap":
					temp.set("type", "nextlevel");
					temp.set("mapPath", x.nextMapPath);
					var tKP:Int = 0;
					if (x.keepPlayer)
						tKP = 1;
					temp.set("currentPlayer", Std.string(tKP));
					var tI:Int = 0;
					if (x.instantly)
						tI = 1;
					temp.set("instantly", Std.string(tI));
				case "com.tpuquest.entity.helper.Spawn":
					temp.set("type", "spawn");		
				case "com.tpuquest.entity.helper.Teleporter":
					temp.set("type", "teleporter");
					temp.set("xTo", Std.string(Std.int((x.pointTo.x / 40) - 9)) + Std.int(columnsW / 2));
					temp.set("yTo", Std.string(Std.int((x.pointTo.y / 40) - 7)) + Std.int(rowsH / 2));
				case "com.tpuquest.entity.helper.KillTheHuman":
					temp.set("type", "killer");
					
			}
			helpersXML.addChild(temp);
		}
		
		lvlXML.addChild(itemsXML);
		lvlXML.addChild(charactersXML);
		lvlXML.addChild(tilesXML);
		lvlXML.addChild(stickersXML);
		lvlXML.addChild(helpersXML);

#if android
		File.saveContent(SystemPath.applicationStorageDirectory + path, lvlXML.toString());
#elseif flash
		Data.load("tpuquuest_levels");
		Data.write(path, lvlXML.toString());
		Data.save("tpuquuest_levels");
#else
		File.saveContent(path, lvlXML.toString());
#end
	}

	public static function ConverterInNewFormat()
	{
		var convert:Level;
		
		convert = Level.LoadLevel("levels/tower.xml", true, false);
		convert.SaveOldInNewFormat("levels/tower.xml", 40, 40);
		
		convert = Level.LoadLevel("levels/home.xml", true, false);
		convert.SaveOldInNewFormat("levels/home.xml", 40, 40);
		
		convert = Level.LoadLevel("levels/fungus.xml", true, false);
		convert.SaveOldInNewFormat("levels/fungus.xml", 200, 100);
		
		convert = Level.LoadLevel("levels/lav.xml", true, false);
		convert.SaveOldInNewFormat("levels/lav.xml", 80, 40);
	}
	
	public function getEntities():Array<Entity>
	{
		var entList:Array<Entity> = new Array<Entity>();
		
		for (x in items)
			entList.push(x);
		
		for (x in characters)
			entList.push(x);
			
		for (x in tiles)
			entList.push(x);
			
		for (x in stickers)
			entList.push(x);
			
		for (x in helpers)
			entList.push(x);
			
		try
		{
			return entList;
		}
		catch (msg:String)
		{
			trace(msg);
			return null;
		}
	}
}