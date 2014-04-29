package com.tpuquest.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Potion extends Item
{
	public var potionAmount:Int;
	
	public function new(point:PointXY, amount:Int) 
	{
		super(point.x + 10, point.y + 10);
		
		this.potionAmount = amount;
		
		type = "potion";
		
		var img = new Image("items/potion_red.png");
		setHitboxTo(img);
		graphic = img;
	}
	
	public override function update()
	{
		super.update();
	}
}