package com.tpuquest.utils;

class PointXY
{
	public var x:Int;
	public var y:Int;
	
	public function new(x:Int, y:Int) 
	{
		this.x = x;
		this.y = y;
	}
	
	public static function Add(p1:PointXY, p2:PointXY):PointXY
	{
		var temp:PointXY = new PointXY(0, 0);
		temp.x = p1.x + p2.x;
		temp.y = p1.y + p2.y;
		return temp;
	}
	
	public static function Subtract(p1:PointXY, p2:PointXY):PointXY
	{
		var temp:PointXY = new PointXY(0, 0);
		temp.x = p1.x - p2.x;
		temp.y = p1.y - p2.y;
		return temp;
	}
}