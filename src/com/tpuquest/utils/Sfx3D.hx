package com.tpuquest.utils;

import com.haxepunk.Sfx;
import com.haxepunk.Sfx.AudioCompleteCallback;
import openfl.geom.Point;

class Sfx3D extends Sfx
{
	public var positionSnd:Point;
	public var positionListener:Point;
	public var radiusMax:Float;
	public var radiusMin:Float;
	
	public function new(source:Dynamic, posListener:Point, posSnd:Point, radiusMax:Float = 400, radiusMin:Float = 40, type:String = "")
	{
		super(source);
		
		this.positionSnd = posSnd;
		this.positionListener = posListener;
		this.type = type;
		this.radiusMax = radiusMax;
		this.radiusMin = radiusMin;
		
		update(posListener, posSnd);
	}
	
	public function update(posListener:Point, posSnd:Point = null)
	{
		if (posSnd != null)
			this.positionSnd = posSnd;
		this.positionListener = posListener;
		
		var R:Float = Math.sqrt(Math.pow(positionSnd.x - positionListener.x, 2) + Math.pow(positionSnd.y - positionListener.y, 2));
		pan = (R - (positionSnd.x - positionListener.x)) / R;
		
		if (R <= radiusMin)
			volume = 1.0 * Sfx.getVolume(type);
		else if (R >= radiusMax)
			volume = 0.0;
		else
			volume = (((radiusMax - radiusMin) - (R - radiusMin)) / (radiusMax - radiusMin)) * Sfx.getVolume(type);
	}
	
	public function play3D(loop:Bool = false) 
	{
		play(this.volume, this.pan, loop);
	}
}