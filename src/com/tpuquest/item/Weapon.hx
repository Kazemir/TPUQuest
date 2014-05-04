package com.tpuquest.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Weapon extends Item
{
	public var weaponDamage:Int;
	public var weaponType:Int;
	
	public function new(point:PointXY, damage:Int, type:Int) 
	{
		super(new PointXY(point.x + 10, point.y + 10));
		
		this.weaponDamage = damage;
		this.weaponType = type;
		
		this.type = "weapon";
		
		var img = new Image("items/sword.png");
		setHitboxTo(img);
		graphic = img;
	}
	
	public override function update()
	{
		super.update();
	}
}