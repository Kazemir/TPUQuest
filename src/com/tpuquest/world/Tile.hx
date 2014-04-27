package com.tpuquest.world;
import com.haxepunk.Entity;
import com.tpuquest.utils.PointXY;

class Tile extends Entity
{
	public var tilePoint:PointXY;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		tilePoint = new PointXY(x, y);
	}
}