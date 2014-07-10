package com.tpuquest.entity.item;

import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.tpuquest.utils.PointXY;
import haxe.Timer;

class Coin extends Item
{
	public var coinAmount:Int;
	public var imgPath:String;
	private var sign:Int;
	//private var emitter:Emitter;
	private var img:Image;
	
	public function new(point:PointXY, amount:Int, imgPath:String, itemName:String = "") 
	{
		super(new PointXY(point.x + 10, point.y + 10), itemName);
		
		this.coinAmount = amount;

		img = new Image(imgPath);
		
		/*emitter = new Emitter("graphics/particle.png", 10, 10);
		emitter.newType("shine", [1]);
		emitter.setMotion("shine", 360, 15, 0.1, 360, 2, 0.05);
		emitter.setAlpha("shine", 1, 0);
		emitter.setGravity("shine", -2, 0.5);
		addGraphic(emitter);*/
		addGraphic(img);
		//graphic = img;
		
		setHitboxTo(img);
		type = "coin";
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
		
		//emitter.emit("shine", img.width / 2, img.height / 2);
		
		super.update();
	}
}