package com.tpuquest.item;
import com.tpuquest.utils.PointXY;
import flash.geom.Point;
import com.haxepunk.Entity;

class Item extends Entity
{
	public var itemPoint:PointXY;
	
	public function new(x:Int, y:Int) 
	{
		super(x, y);
		itemPoint = new PointXY(x, y);
	}
	
	public override function update()
	{
		super.update();
	}
}