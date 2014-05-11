package com.tpuquest.entity.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Weapon extends Item
{
	public var weaponDamage:Int;
	//public var weaponType:Int;
	public var imgPath:String;
	
	public function new(point:PointXY, damage:Int, imgPath:String, itemName:String = "")
	{
		super(new PointXY(point.x + 10, point.y + 10), itemName);
		
		this.weaponDamage = damage;

		type = "weapon";
		
		var img = new Image(imgPath);
		img.x = -8;
		img.y = -8;
		setHitboxTo(img);
		graphic = img;
		this.imgPath = imgPath;
		itemPoint = point;
		
		
	}
	
	public override function update()
	{
		super.update();
	}
}