package com.tpuquest.character;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.tpuquest.utils.DrawText;

class Talker extends Character
{
	private var sprite:Spritemap;
	private var counter:Float = 0;
	public var underText:DrawText;
	private var scale:Float = 1;
	
	public function new(x:Float, y:Float, sc:Float, nm:String) 
	{
		super(x, y);
		scale = sc;
		// create a new spritemap (image, frameWidth, frameHeight)
		sprite = new Spritemap("graphics/player.png", 16, 16);
		// define animations by passing frames in an array
		sprite.add("idle", [0]);
		// we set a speed to the walk animation
		sprite.add("walk", [1, 2, 3, 2], 12);
		// tell the sprite to play the idle animation
		sprite.play("idle");
	 
		sprite.scale = 8;
		
		// apply the sprite to our graphic object so we can see the player
		graphic = sprite;
	 
		velocity = 0;
		counter = 0;
		
		underText = new DrawText(nm, GameFont.Imperial, 18, x+sprite.width*8, y-sprite.height*8-15, 0, true);
	}

	private function setAnimations()
	{
		if (velocity == 0)
		{
			// we are stopped, set animation to idle
			sprite.play("idle");
		}
		else
		{
			// we are moving, set animation to walk
			sprite.play("walk");

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
 
	public override function update()
	{
		velocity = 0;

		counter += HXP.elapsed;
		
		if (counter > 2*scale)
			velocity = 2 * 5*scale;
		if (counter > 4*scale)
			velocity = 0;
		if (counter > 6*scale)
			velocity = -2 * 5*scale;
		if (counter > 8*scale)
		{
			velocity = 0;	
			counter = 0;
		}
		
		moveBy(velocity, 0);
 
		setAnimations();
		
		underText.ChangePoint(x+sprite.width*4, y-10);
		super.update();
	}
}