package com.tpuquest.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Coin extends Item
{
	public var coinAmount:Int;
	public var imgPath:String;
	
	public function new(point:PointXY, amount:Int, imgPath:String, itemName:String = "") 
	{
		super(new PointXY(point.x + 10, point.y + 10), itemName);
		
		this.coinAmount = amount;

		var img = new Image(imgPath);
		graphic = img;
		
		setHitboxTo(img);
		type = "coin";
		this.imgPath = imgPath;
		itemPoint = point;
	}
	
	public override function update()
	{
		super.update();
	}
}