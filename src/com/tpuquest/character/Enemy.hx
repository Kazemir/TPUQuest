package com.tpuquest.character;
import com.tpuquest.screen.SettingsMenu;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.tpuquest.utils.PointXY;
import flash.geom.Point;

class Enemy extends Character
{
	public var life:Int;
	
	private var sprite:Spritemap;
	private var prevPoint:Point;
	
	private static inline var kMoveSpeed:Float = 5;
	private static inline var kJumpForce:Int = 22;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	public function new(point:PointXY)
	{
		super(point);
		
		hasTouchTheGround = true;
		
		sprite = new Spritemap("graphics/character.png", 32, 32);
		sprite.add("norm_idle", [8, 8, 8, 9], 3, true);
		sprite.add("norm_walk", [0, 1, 2, 3, 4, 5, 6, 7], 19, true);
		sprite.add("norm_jump", [10]);
		sprite.play("norm_idle");
		
		sprite.scale = 2.5;
		sprite.x = -20;
		
		setHitbox(40, 80);
		type = "enemy";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		life = 50;
		isDead = false;
	}
	
	private function setAnimations()
	{
		if (!_onGround)
		{
			sprite.play("norm_jump");
			
			if (velocity.x < 0) // left
			{
				sprite.flipped = true;
			}
			else if(velocity.x > 0) // right
			{
				sprite.flipped = false;	
			}
		}
		else if (velocity.x == 0)
		{
			sprite.play("norm_idle");
		}
		else
		{
			sprite.play("norm_walk");

			if (velocity.x < 0) // left
			{
				sprite.flipped = true;
			}
			else // right
			{
				sprite.flipped = false;	
			}
		}
	}
	
	public override function update()
	{
		acceleration.x = acceleration.y = 0;
 
		if (!_onGround)
			hasTouchTheGround = false;
		
		if ( !hasTouchTheGround && _onGround) 
		{
			hasTouchTheGround = true;
			var sound = new Sfx("audio/player_soundJumpStop.wav");
			sound.play(SettingsMenu.soudVolume / 10);
		}

		prevPoint = new Point(x, y);
		
		super.update();
		
		if(collide("solid", x, y) != null)
		{
			x = prevPoint.x;
			y = prevPoint.y;
		}
		
		if(life <= 0)
			isDead = true;
		if (life > 100)
			life = 100;
		
		setAnimations();
	}
}