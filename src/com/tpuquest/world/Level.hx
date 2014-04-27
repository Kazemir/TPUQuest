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

import haxe.xml.*;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

class Level
{
	public var items:Array<Dynamic>;
	public var characters:Array<Dynamic>;
	public var tiles:Array<Dynamic>;
	
	public var cameraPos:PointXY;
	
	/*public function ScreenToWorld(vector:PointXY):PointXY
	{
		var rvect:PointXY;
		rvect = PointXY.Add(cameraPos, vector);
		return rvect;
	}

	public function WorldToScreen(vector:PointXY):PointXY
	{
		var rvect:PointXY;
		rvect = PointXY.Subtract(vector, cameraPos);
		return rvect;
	}*/
	
	public function new() 
	{
		items = new Array<Dynamic>();
		characters = new Array<Dynamic>();
		tiles = new Array<Dynamic>();
		cameraPos = new PointXY(0, 0);
	}
	
	public static function LoadLevel( path:String ):Level
	{
		var lvl:Level = new Level();
		
		var lvlXML:Xml = Xml.parse(File.getContent( path )).firstElement();
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
								var tAmount = Std.parseInt(element.get("amount"));
								temp = new Coin(tX, tY, tAmount);
							case "potion":
								var tAmount = Std.parseInt(element.get("amount"));
								var tType = Std.parseInt(element.get("p_type"));
								temp = new Potion(tX, tY, tAmount, tType);
							case "weapon":
								var tDamage = Std.parseInt(element.get("damage"));
								var tType = Std.parseInt(element.get("w_type"));
								temp = new Weapon(tX, tY, tDamage, tType);
							default:
								temp = new Item(tX, tY);
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
								temp = new Talker(tX, tY, 1, "");
							case "trader":
								temp = new Trader(tX, tY, 1);
							case "enemy":
								temp = new Enemy(tX, tY, 1);
							default:
								temp = new Character(tX, tY);
						}
						
						lvl.characters.push( temp );
					}
				case "tiles":
					for (element in section.elements())
					{
						var temp:Tile;
						var tX = Std.parseInt(element.get("x"));
						var tY = Std.parseInt(element.get("y"));
						temp = new Tile(tX, tY);
						lvl.tiles.push( temp );
					}
			}
		}
			
		return lvl;
	}
	
	public function SaveLevel( path:String )
	{
		var lvlXML:Xml = Xml.createElement( "level" );
		
		var itemsXML:Xml = Xml.createElement( "items" );
		for (x in items)
		{
			var temp:Xml = Xml.createElement( "element" );
			temp.set("x", Std.string(x.itemPoint.x));
			temp.set("y", Std.string(x.itemPoint.y));
			switch(Type.getClassName(Type.getClass(x)))
			{
				case "com.tpuquest.item.Coin":
					temp.set("type", "coin");
					temp.set("amount", Std.string(x.coinAmount));
				case "com.tpuquest.item.Potion":
					temp.set("type", "potion");
					temp.set("amount", Std.string(x.potionAmount));
					temp.set("p_type", Std.string(x.potionType));
				case "com.tpuquest.item.Weapon":
					temp.set("type", "weapon");
					temp.set("damage", Std.string(x.weaponDamage));
					temp.set("w_type", Std.string(x.weaponType));
			}
			itemsXML.addChild(temp);
		}
		
		var charactersXML:Xml = Xml.createElement( "characters" );
		for (x in characters)
		{
			var temp:Xml = Xml.createElement( "element" );
			temp.set("x", Std.string(x.characterPoint.x));
			temp.set("y", Std.string(x.characterPoint.y));
			
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
			temp.set("x", Std.string(x.tilePoint.x));
			temp.set("y", Std.string(x.tilePoint.y));
			tilesXML.addChild(temp);
		}
		
		lvlXML.addChild(itemsXML);
		lvlXML.addChild(charactersXML);
		lvlXML.addChild(tilesXML);
		
		var fout:FileOutput = File.write( path, false );
		fout.writeString( lvlXML.toString() );
		fout.close();
	}
	
	public function getEntities():Array<Entity>
	{
		var entList:Array<Entity> = new Array<Entity>();
		
		for (x in items)
		{
			entList.push(x);
		}
		
		for (x in characters)
		{
			entList.push(x);
		}
		
		for (x in tiles)
		{
			entList.push(x);
		}

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