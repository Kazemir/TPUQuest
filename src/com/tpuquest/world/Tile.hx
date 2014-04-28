package com.tpuquest.world;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Tile extends Entity
{
	public var tilePoint:PointXY;
	public var collidability:Bool;
	private var img:Image;
	public var imgPath:String;
	public var tileName:String;
	
	public function new(point:PointXY, collidability:Bool, path:String, name:String = "") 
	{
		super(point.x, point.y);
		
		tilePoint = point;
		this.collidability = collidability;
		img = new Image(path);
		setHitbox(40, 40);
		collidable = true;
		layer = 10;
		imgPath = path;
		tileName = name;
		graphic = img;
	}
	
	/*public override function moveCollideX(e:Entity)
    {
	
	}*/
	
	public override function update()
	{
		super.update();
	}
}