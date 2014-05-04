package com.tpuquest.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Potion extends Item
{
	public var potionAmount:Int;
	
	public function new(point:PointXY, amount:Int) 
	{
		super(new PointXY(point.x + 10, point.y + 10));
		
		this.potionAmount = amount;
		
		var img = new Image("items/potion_red.png");
		graphic = img;
		
		type = "potion";
		setHitboxTo(img);
	}
	
	public override function update()
	{
		super.update();
	}
}