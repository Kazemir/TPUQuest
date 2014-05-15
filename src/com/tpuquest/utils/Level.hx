package com.tpuquest.utils;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.tpuquest.entity.character.Boss;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.Player;
import com.tpuquest.entity.character.Talker;
import com.tpuquest.entity.character.Trader;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
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
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

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
	
	public static function LoadLevel( path:String, behavior:Bool = true ):Level
	{
		var lvl:Level = new Level();
		
		var lvlXML:Xml = Xml.parse(File.getContent( path )).firstElement();
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
			}
			helpersXML.addChild(temp);
		}
		
		lvlXML.addChild(itemsXML);
		lvlXML.addChild(charactersXML);
		lvlXML.addChild(tilesXML);
		lvlXML.addChild(stickersXML);
		lvlXML.addChild(helpersXML);
		
		var fout:FileOutput = File.write( path, false );
		fout.writeString( lvlXML.toString() );
		fout.close();
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