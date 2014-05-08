package com.tpuquest.helper;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Draw;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;

class Helper extends Entity
{
	public var helperName:String;
	public var helperPoint:PointXY;
	
	public function new(point:PointXY, name:String = "", show:Bool = false) 
	{
		super(point.x, point.y);
		
		helperName = name;
		helperPoint = point;
		type = "helper";
		graphic = Image.createRect(40, 40, 0xffa500, 0.8);
		width = height = 40;
		setHitbox(40, 40);
		
		var t:DrawText = new DrawText(name, GameFont.Imperial, 8, 0, 0, 0xFFFFFF, false, 40, 40);
		addGraphic(t.label);
		
		visible = show;
	}
	
	public override function update()
	{
		super.update();
	}
}