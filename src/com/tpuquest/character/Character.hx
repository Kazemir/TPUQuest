package com.tpuquest.character;
import com.haxepunk.Sfx;
import com.tpuquest.utils.PointXY;
import com.tpuquest.world.Tile;
import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.tpuquest.screen.SettingsMenu;

class Character extends Entity
{
	public var velocity:Point;
	public var acceleration:Point;
	public var friction:Point;
	public var maxVelocity:Point;
	public var gravity:Point;
	
	public static var solid:String = "solid";
	
	public var characterName:String;
	public var behaviorOn:Bool;

	public function new(point:PointXY)
	{
		super(point.x, point.y);
		_onGround = false;

		velocity     = new Point();
		acceleration = new Point();
		friction     = new Point();
		maxVelocity  = new Point();
		gravity      = new Point();
		
		characterName = "";
		behaviorOn = true;
	}

	public var onGround(get_onGround, null): Bool;
	private function get_onGround():Bool { return _onGround; }

	override public function update()
	{
		if (behaviorOn)
		{
			// Apply acceleration and velocity
			velocity.x += acceleration.x;
			velocity.y += acceleration.y;
			applyVelocity();
			applyGravity();
			checkMaxVelocity();
		}
		super.update();
	}

	public function applyGravity()
	{
		//increase velocity based on gravity
		velocity.x += gravity.x;
		velocity.y += gravity.y;
	}

	private function checkMaxVelocity()
	{
		if (maxVelocity.x > 0 && Math.abs(velocity.x) > maxVelocity.x)
		{
			velocity.x = maxVelocity.x * HXP.sign(velocity.x);
		}

		if (maxVelocity.y > 0 && Math.abs(velocity.y) > maxVelocity.y)
		{
			velocity.y = maxVelocity.y * HXP.sign(velocity.y);
		}
	}

	private var walkSound:Sfx;
	
	public override function moveCollideY(e:Entity):Bool
	{
		if (velocity.y * HXP.sign(gravity.y) > 0)
		{
			_onGround = true;
		}
		velocity.y = 0;

		velocity.x *= friction.x;
		if (Math.abs(velocity.x) < 0.5) velocity.x = 0;
		
		if (type == "player" && _onGround && velocity.x != 0)
		{
			if (walkSound == null)
			{
				var t:Tile = cast(e, Tile);
				walkSound = new Sfx(t.soundPath);
				walkSound.play(SettingsMenu.soudVolume / 10, 1);
			}
			if (!walkSound.playing)
			{
				var t:Tile = cast(e, Tile);
				walkSound = new Sfx(t.soundPath);
				walkSound.play(SettingsMenu.soudVolume / 10, 1);
			}
		}
		
		return true;
	}

	public override function moveCollideX(e:Entity):Bool
	{
		velocity.x = 0;

		velocity.y *= friction.y;
		if (Math.abs(velocity.y) < 1) velocity.y = 0;
		
		return true;
	}

	private function applyVelocity()
	{
		var i:Int;

		_onGround = false;

		moveBy(velocity.x, velocity.y, solid, true);
	}

	private var _onGround:Bool;

}