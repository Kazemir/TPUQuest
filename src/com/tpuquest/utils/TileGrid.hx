package com.tpuquest.utils;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.masks.Grid;
import com.haxepunk.masks.SlopedGrid;

class TileGrid extends Entity
{
	public var tileMap:Tilemap;
	public var collideGrid:Grid;
	
	public function new( x:Float, y:Float, sizeX:Int, sizeY:Int, tileset:String, layer:Int ) 
	{
		tileMap = new Tilemap(tileset, sizeX, sizeY, 40, 40, 0, 0);
		/*tileMap.setTile(0, 0, 1);
		tileMap.setTile(1, 1, 21);
		tileMap.setTile(0, 2, 5);
		tileMap.setTile(1, 5, 10);*/

		collideGrid = new Grid(sizeX, sizeY, tileMap.tileWidth, tileMap.tileHeight, 0, 0);
		/*collideGrid.setTile(0, 0);
		collideGrid.setTile(1, 1, false);
		collideGrid.setTile(0, 2);
		collideGrid.setTile(1, 5);*/
		
		super(x, y, tileMap, collideGrid);
		
		type = "solid";
		this.layer = layer;
	}
	
	public function addTile(x:Int, y:Int, index:Int, solid:Bool = true)
	{
		tileMap.setTile(x, y, index);
		collideGrid.setTile(x, y, solid);
	}
	
	public override function update()
	{
		super.update();
	}
}