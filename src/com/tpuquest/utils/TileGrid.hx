package com.tpuquest.utils;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import com.haxepunk.masks.SlopedGrid;

class TileGrid extends Entity
{
	public var tileMap:Tilemap;
	public var collideGrid:Grid; 
	//public var mapOrigin:PointXY;
	
	//private var tileset:String;
	
	public function new( x:Float, y:Float, layer:Int, columnsW:Int, rowsH:Int, tileset:String, tileWidth:Int, tileHeigh:Int, withMask:Bool = true ) 
	{
		tileMap = new Tilemap(tileset, columnsW*tileWidth, rowsH*tileHeigh, tileWidth, tileHeigh, 0, 0);
		//mapOrigin = new PointXY(0, 0);
		
		if (withMask)
		{
			collideGrid = new Grid(tileMap.width, tileMap.height, tileMap.tileWidth, tileMap.tileHeight, 0, 0);
			super(x, y, tileMap, collideGrid);
		}
		else
			super(x, y, tileMap);
			
		type = "solid";
		this.layer = layer;
	}
	
	public function addTile(x:Int, y:Int, index:Int, solid:Bool = true)
	{
		/*var gridX:Int = mapOrigin.x + x;
		var gridY:Int = mapOrigin.y + y;
		
		if (gridX < 0)
		{
			changeSize(tileMap.width - gridX, tileMap.height);
			tileMap.shiftTiles( - gridX, 0);
			collideGrid.
			mapOrigin.x = mapOrigin.x - gridX;
		}
		if (gridX > tileMap.width)
			;//tileMap.width = gridX;
			
		if (gridY < 0)
		{
			changeSize(tileMap.width, tileMap.height - gridY);
			tileMap.shiftTiles(0, - gridY);
			mapOrigin.x = mapOrigin.y - gridY;
		}
		if (gridY > tileMap.height)
			;//tileMap.height = gridY;
		
		tileMap.setTile(mapOrigin.x + x, mapOrigin.y + y, index);
		
		if(collideGrid != null)
			collideGrid.setTile(mapOrigin.x + x, mapOrigin.y + y, solid);
		*/		
		tileMap.setTile(x, y, index);
		
		if(collideGrid != null)
			collideGrid.setTile(x, y, solid);
	}
	
	public function getTile(x:Int, y:Int):Int
	{
		//return tileMap.getTile(mapOrigin.x + x, mapOrigin.y + y);
		return tileMap.getTile(x, y);
	}
	
	public function getTileCollidability(x:Int, y:Int):Bool
	{
		if(collideGrid != null)
			//return collideGrid.getTile(mapOrigin.x + x, mapOrigin.y + y);
			return collideGrid.getTile(x, y);
		else
			return false;
	}
	
	/*private function changeSize(width:Int, height:Int)
	{
		//tileMap.
	}*/
	
	public override function update()
	{
		super.update();
	}
}