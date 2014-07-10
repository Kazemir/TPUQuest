package com.tpuquest.entity.item;

import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;
import haxe.Timer;

class Weapon extends Item
{
	public var weaponDamage:Int;
	public var imgPath:String;
	private var sign:Int;
	
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