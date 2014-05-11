package com.tpuquest.entity.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Potion extends Item
{
	public var potionAmount:Int;
	public var imgPath:String;
	
	public function new(point:PointXY, amount:Int, imgPath:String, itemName:String = "") 
	{
		super(new PointXY(point.x + 10, point.y + 10), itemName);
		
		this.potionAmount = amount;
		
		var img = new Image(imgPath);
		graphic = img;
		
		type = "potion";
		setHitboxTo(img);
		this.imgPath = imgPath;
		itemPoint = point;
	}
	
	public override function update()
	{
		super.update();
	}
}