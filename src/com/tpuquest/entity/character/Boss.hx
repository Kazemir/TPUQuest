package com.tpuquest.entity.character;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.utils.PointXY;
import flash.geom.Point;

class Boss extends Character
{
	public var life:Int;
		
	public function new(point:Point, spritePath:String, hp:Int = 100, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		this.life = hp;
	}
	
	public override function update()
	{
		if (behaviorOn)
		{
			super.update();
		}
	}
}