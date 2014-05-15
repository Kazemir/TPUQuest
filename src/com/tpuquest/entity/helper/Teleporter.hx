package com.tpuquest.entity.helper;

import com.tpuquest.utils.PointXY;

class Teleporter extends Helper
{
	public var pointTo:PointXY;
	
	public function new(point:PointXY, pointTo:PointXY, name:String="", show:Bool = false) 
	{
		super(point, name, show);
		this.pointTo = pointTo;
	}
	
	public override function update()
	{
		super.update();
	}
}