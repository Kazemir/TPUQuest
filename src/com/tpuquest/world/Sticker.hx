package com.tpuquest.world;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Sticker extends Tile
{
	public var behindCreatures:Bool;
	
	public function new(point:PointXY, behindCreatures:Bool, path:String, name:String="") 
	{
		super(point, false, path, "", name);
		
		if (behindCreatures)
			layer = 1;
		else
			layer = -1;
			
		this.behindCreatures = behindCreatures;
	}
	
	public override function update()
	{
		super.update();
	}
}