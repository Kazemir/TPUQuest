package com.tpuquest.utils;
import com.haxepunk.Engine;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.utils.Data;
import com.tpuquest.entity.character.Boss;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.EnemyPlayer;
import com.tpuquest.entity.character.Player;
import com.tpuquest.entity.character.Talker;
import com.tpuquest.entity.character.Trader;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
import com.tpuquest.entity.helper.KillTheHuman;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.SpawnPoint;
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
import openfl.geom.Point;
import haxe.Timer;

import haxe.xml.*;

#if !flash
import sys.FileSystem;
import sys.io.File;
#end

#if android
import openfl.utils.SystemPath;
#end

import openfl.Assets;

typedef TileElement = { x : Int, y : Int, id : Int, solid : Bool };

class TileGridLevel
{
	public var items:Array<Dynamic>;
	public var characters:Array<Dynamic>;
	public var helpers:Array<Dynamic>;
	
	public var tilesMap:TileGrid;
	public var stickersMapBehind:TileGrid;
	public var stickersMap:TileGrid;
	
	public var tiles:Array<TileElement>;
	public var stickers:Array<TileElement>;
	
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
	
	public function new( name:String = "New Level", columnsW:Int = 1, rowsH:Int = 1 ) 
	{
		items = new Array<Dynamic>();
		characters = new Array<Dynamic>();
		helpers = new Array<Dynamic>();
		
		tilesMap = new TileGrid( 9*40, 7*40, 10, columnsW, rowsH, "graphics/tileset2.png", 40, 40, true);
		stickersMapBehind = new TileGrid( 9*40, 7*40, 1, columnsW, rowsH, "graphics/stickerset.png", 40, 40, false);
		stickersMap = new TileGrid( 9*40, 7*40, -1, columnsW, rowsH, "graphics/stickerset.png", 40, 40, false);
		
		tiles = new Array<TileElement>();
		stickers = new Array<TileElement>();
		
		cameraPos = new PointXY(0, 0);
		bgcolor = 0x61c3ff;
		levelName = name;
		bgPicturePath = "";
	}
	
	public static function LoadLevel( path:String, fromAssets:Bool = true, behavior:Bool = true ):TileGridLevel
	{
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
		
		var lvl:TileGridLevel = new TileGridLevel(lvlXML.get("name"), Std.parseInt(lvlXML.get("columnsW")), Std.parseInt(lvlXML.get("rowsH")));
		lvl.bgcolor = Std.parseInt(lvlXML.get("bgcolor"));
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
							case "enemy_player":
								var tHP = Std.parseInt(element.get("hp"));
								var tM = Std.parseInt(element.get("money"));
								var tWD = Std.parseInt(element.get("weaponDamage"));
								temp = new EnemyPlayer(WorldToScreenFloat(new Point(tX, tY)), tS, tHP, tM, tWD, tN, behavior);
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
						var tX:Int = Std.parseInt(element.get("x"));
						var tY:Int = Std.parseInt(element.get("y"));
						var tID:Int = Std.parseInt(element.get("id"));
						var tS:Bool = element.get("solid") == "true";
						lvl.tiles.push( { x : tX, y : tY, id : tID, solid : tS } );
						
						lvl.tilesMap.addTile(tX, tY, tID, tS);
					}
				case "stickers":
					for (element in section.elements())
					{
						var tX:Int = Std.parseInt(element.get("x"));
						var tY:Int = Std.parseInt(element.get("y"));
						var tID:Int = Std.parseInt(element.get("id"));
						var tBH:Bool = element.get("behind") == "true";
						lvl.stickers.push( { x : tX, y : tY, id : tID, solid : tBH } );
						
						if(tBH)
							lvl.stickersMapBehind.addTile(tX, tY, tID, false);
						else
							lvl.stickersMap.addTile(tX, tY, tID, false);
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
								var tCP_b = element.get("currentPlayer") == "1";
								var tI_b = element.get("instantly") == "1";
								var tRAU_b:Bool = element.get("removeAfterUsing") == "1";
								temp = new ChangeMap(WorldToScreen(new PointXY(tX, tY)), tMP, tCP_b, tI_b, tRAU_b, tN, !behavior);
							case "spawn":
								temp = new SpawnPoint(WorldToScreen(new PointXY(tX, tY)), tN, !behavior);
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

		lvlXML.set("columnsW", Std.string(tilesMap.tileMap.columns));
		lvlXML.set("rowsH", Std.string(tilesMap.tileMap.rows));
			
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
				case "com.tpuquest.entity.character.EnemyPlayer":
					temp.set("type", "enemy_player");
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
			temp.set("x", Std.string(x.x));
			temp.set("y", Std.string(x.y));
			temp.set("id", Std.string(x.id));
			temp.set("solid", Std.string(x.solid));
			
			tilesXML.addChild(temp);
		}
		
		var stickersXML:Xml = Xml.createElement( "stickers" );
		for (x in stickers)
		{
			var temp:Xml = Xml.createElement( "element" );
			temp.set("x", Std.string(x.x));
			temp.set("y", Std.string(x.y));
			temp.set("id", Std.string(x.id));
			temp.set("behind", Std.string(x.solid));
			
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
					var tRAU:Int = 0;
					if (x.removeAfterUsing)
						tRAU = 1;
					temp.set("removeAfterUsing", Std.string(tRAU));
				case "com.tpuquest.entity.helper.SpawnPoint":
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

	public function getEntities():Array<Entity>
	{
		var entList:Array<Entity> = new Array<Entity>();
		
		for (x in items)
			entList.push(x);
		
		for (x in characters)
			entList.push(x);
			
		entList.push(tilesMap);
		entList.push(stickersMap);
		entList.push(stickersMapBehind);
			
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