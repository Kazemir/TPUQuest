package com.tpuquest.entity.item;

import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;
import haxe.Timer;

class Potion extends Item
{
	public var potionAmount:Int;
	public var imgPath:String;
	private var sign:Int;
	
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
		
		sign = -1;
		var t:Timer = new Timer(1000);
		t.run = function ()
		{
			sign = sign * ( -1);
		};
	}
	
	public override function update()
	{
		graphic.y += sign * 0.5;
		
		super.update();
	}
}