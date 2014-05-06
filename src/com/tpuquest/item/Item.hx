package com.tpuquest.item;
import com.tpuquest.utils.PointXY;
import flash.geom.Point;
import com.haxepunk.Entity;

class Item extends Entity
{
	public var itemPoint:PointXY;
	public var itemName:String;
	
	public function new(point:PointXY) 
	{
		super(point.x, point.y);
		itemPoint = point;
		itemName = "";
	}
	
	public override function update()
	{
		super.update();
	}
}