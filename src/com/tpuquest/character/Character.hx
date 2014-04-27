package com.tpuquest.character;
import flash.geom.Point;
import com.haxepunk.Entity;

class Character extends Entity
{
	public var nameCh:String;
	public var characterPoint:Point;
	public var hpCh:Int;
	
	private var velocity:Float;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		characterPoint = new Point(x, y);
	}

	public override function update()
	{
		super.update();
	}
}