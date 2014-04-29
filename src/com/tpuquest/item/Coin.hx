package com.tpuquest.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Coin extends Item
{
	public var coinAmount:Int;
	
	public function new(point:PointXY, amount:Int) 
	{
		super(point.x + 10, point.y + 10);
		
		this.coinAmount = amount;
		
		type = "coin";
		
		var img = new Image("items/coin.png");
		setHitboxTo(img);
		graphic = img;
	}
	
	public override function update()
	{
		super.update();
	}
}