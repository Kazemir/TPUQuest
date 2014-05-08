package com.tpuquest.helper;
import com.haxepunk.Entity;
import com.tpuquest.utils.PointXY;

class Helper extends Entity
{
	public var helperName:String;
	public var helperPoint:PointXY;
	
	public function new(point:PointXY, name:String = "") 
	{
		super(point.x, point.y);
		
		helperName = name;
		helperPoint = point;
		type = "helper";
	}
	
	public override function update()
	{
		super.update();
	}
}