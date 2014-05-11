package com.tpuquest.entity.helper;

import com.tpuquest.utils.PointXY;

class ChangeMap extends Helper
{
	public var nextMapPath:String;
	public var keepPlayer:Bool;
	public var instantly:Bool;
	
	public function new(point:PointXY, mapPath:String, currentPlayer:Bool, instantly:Bool, name:String="", show:Bool = false) 
	{
		super(point, name, show);
		this.nextMapPath = mapPath;
		this.keepPlayer = currentPlayer;
		this.instantly = instantly;
	}
	
	public override function update()
	{
		super.update();
	}
}