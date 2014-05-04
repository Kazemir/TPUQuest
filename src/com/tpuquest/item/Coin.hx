package com.tpuquest.item;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;

class Coin extends Item
{
	public var coinAmount:Int;
	
	public function new(point:PointXY, amount:Int) 
	{
		super(new PointXY(point.x + 10, point.y + 10));
		
		this.coinAmount = amount;

		var img = new Image("items/coin.png");
		graphic = img;
		
		setHitboxTo(img);
		type = "coin";
	}
	
	public override function update()
	{
		super.update();
	}
}