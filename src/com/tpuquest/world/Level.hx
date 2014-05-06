package com.tpuquest.world;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.tpuquest.character.Enemy;
import com.tpuquest.character.Talker;
import com.tpuquest.character.Trader;
import com.tpuquest.item.Coin;
import com.tpuquest.item.Item;
import com.tpuquest.character.Character;
import com.tpuquest.item.Potion;
import com.tpuquest.item.Weapon;
import com.tpuquest.utils.PointXY;
import com.tpuquest.world.Tile;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

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
	
	public var cameraPos:PointXY;
	
	public var bgcolor:Int;
	public var levelName:String;
	
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
	
	public function new( name:String = "New Level" ) 
	{
		items = new Array<Dynamic>();
		characters = new Array<Dynamic>();
		tiles = new Array<Dynamic>();
		stickers = new Array<Dynamic>();
		
		cameraPos = new PointXY(0, 0);
		bgcolor = 0x61c3ff;
		levelName = name;
	}
	
	public static function LoadLevel( path:String ):Level
	{
		var lvl:Level = new Level();
		
		var lvlXML:Xml = Xml.parse(File.getContent( path )).firstElement();
		lvl.bgcolor = Std.parseInt(lvlXML.get("bgcolor"));
		lvl.levelName = lvlXML.get("name");
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
						var tX = Std.parseInt(element.get("x"));
						var tY = Std.parseInt(element.get("y"));
						switch(element.get("type"))
						{
							case "talker":
								temp = new Talker(WorldToScreen(new PointXY(tX, tY)));
							case "trader":
								temp = new Trader(WorldToScreen(new PointXY(tX, tY)));
							case "enemy":
								temp = new Enemy(WorldToScreen(new PointXY(tX, tY)));
							default:
								temp = new Character(WorldToScreen(new PointXY(tX, tY)));
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
			}
		}
			
		return lvl;
	}
	
	public function SaveLevel( path:String )
	{
		var lvlXML:Xml = Xml.createElement( "level" );
		lvlXML.set("bgcolor", Std.string(bgcolor));
		lvlXML.set("name", levelName);

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
				case "com.tpuquest.item.Coin":
					temp.set("type", "coin");
					temp.set("coinAmount", Std.string(x.coinAmount));
					temp.set("path", x.imgPath);
				case "com.tpuquest.item.Potion":
					temp.set("type", "potion");
					temp.set("potionAmount", Std.string(x.potionAmount));
					temp.set("path", x.imgPath);
				case "com.tpuquest.item.Weapon":
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
			var tX = x.characterPoint.x;
			var tY = x.characterPoint.y;
			
			tX = Std.int((tX / 40) - 9);
			tY = Std.int((tY / 40) - 7);
			temp.set("x", Std.string(tX));
			temp.set("y", Std.string(tY));
			
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.character.Talker":
					temp.set("type", "talker");
				case "com.tpuquest.character.Trader":
					temp.set("type", "trader");
				case "com.tpuquest.character.Enemy":
					temp.set("type", "enemy");
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
		
		lvlXML.addChild(itemsXML);
		lvlXML.addChild(charactersXML);
		lvlXML.addChild(tilesXML);
		lvlXML.addChild(stickersXML);
		
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