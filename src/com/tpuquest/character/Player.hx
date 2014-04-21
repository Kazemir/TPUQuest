package com.tpuquest.character;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import flash.geom.Point;

class Player extends Character
{
	private var sprite:Spritemap;
 
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		// create a new spritemap (image, frameWidth, frameHeight)
		sprite = new Spritemap("graphics/character.png", 32, 32);
		// define animations by passing frames in an array
		sprite.add("norm_idle", [8, 8, 8, 9], 3, true);
		sprite.add("norm_walk", [0, 1, 2, 3, 4, 5, 6, 7], 19, true);
		sprite.add("norm_jump", [10]);

		sprite.add("grav_idle", [19, 19, 19, 20], 2, true);
		sprite.add("grav_walk", [11, 12, 13, 14, 15, 16, 17, 18], 19, true);
		sprite.add("grav_jump", [21]);

		// tell the sprite to play the idle animation
		sprite.play("norm_idle");
	 
		sprite.scale = 6;
		
		// apply the sprite to our graphic object so we can see the player
		graphic = sprite;
	 
		velocity = 0;
	}

	private function setAnimations()
	{
		if (velocity == 0)
		{
			// we are stopped, set animation to idle
			sprite.play("norm_idle");
		}
		else
		{
			// we are moving, set animation to walk
			sprite.play("norm_walk");

			// this will flip our sprite based on direction
			if (velocity < 0) // left
			{
				sprite.flipped = true;
			}
			else // right
			{
				sprite.flipped = false;	
			}
		}
	}
 
/*	private function doJump()
	{
		if (!onGround) return;

		acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
	}*/
	
	public override function update()
	{
		velocity = 0;
 
		if (Input.check("left"))
		{
			velocity = -2*5;
		}
		if (Input.check("right"))
		{
			velocity = 2*5;
		}
/*		if (Input.pressed("jump"))
		{
			doJump();
		}*/
		
		if (x - 50 > HXP.camera.x + 500)
			HXP.camera.x += 2 * 5;
			
		if (x - 50 < HXP.camera.x)
			HXP.camera.x-=2*5;

		moveBy(velocity, 0);
 
		setAnimations();
		super.update();
	}
	
}