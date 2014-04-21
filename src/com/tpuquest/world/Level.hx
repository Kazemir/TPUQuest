package com.tpuquest.world;
import com.tpuquest.item.Item;
import com.tpuquest.character.Character;
import com.tpuquest.utils.PointXY;
import com.tpuquest.world.Tile;

class Level
{
	public var items:List<Item> = new List<Item>();
	public var characters:List<Character> = new List<Character>();
	public var tiles:List<Tile> = new List<Tile>();
	public var cameraPos:PointXY;
	
	public function ScreenToWorld(vector:PointXY):PointXY
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
	}
	
	public function new() 
	{
		
	}
}