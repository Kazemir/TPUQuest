package com.tpuquest.character;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.item.Coin;
import com.tpuquest.item.Potion;
import com.tpuquest.screen.SettingsMenu;
import com.tpuquest.utils.PointXY;
import flash.geom.Point;
import com.haxepunk.Sfx;

class Player extends Character
{
	public var money:Int;
	public var life:Int;
	
	private var sprite:Spritemap;
	private var prevPoint:Point;

	private static inline var kMoveSpeed:Float = 5;
	private static inline var kJumpForce:Int = 22;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	/*private var soundMoney:Sfx;
	private var soundPotion:Sfx;
	private var soundWalk:Sfx;
	private var soundJumpStart:Sfx;
	private var soundJumpEnd:Sfx;*/
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		hasTouchTheGround = true;
		
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
	 
		sprite.scale = 2.5;
		sprite.x = -20;
		
		setHitbox(40, 80);
		//setHitboxTo(sprite);
		type = "player";
		// apply the sprite to our graphic object so we can see the player
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		money = 0;
		life = 50;
		isDead = false;
		
		//soundMoney = new Sfx("audio/player_soundMoney.wav");
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
			// we are stopped, set animation to idle
			sprite.play("norm_idle");
		}
		else
		{
			// we are moving, set animation to walk
			sprite.play("norm_walk");

			// this will flip our sprite based on direction
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
		
		//if (hasTouchTheGround && Input.check("left"))
		if (Input.check("left"))
		{
			acceleration.x = -kMoveSpeed;
		}
		//if (hasTouchTheGround && Input.check("right"))
		if (Input.check("right"))
		{
			acceleration.x = kMoveSpeed;
		}
		if (Input.pressed("jump") && _onGround)
		{
			acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
			
			var sound = new Sfx("audio/player_soundJumpStart.wav");
			sound.play(SettingsMenu.soudVolume / 10);
		}

		prevPoint = new Point(x, y);
		
		super.update();
		
		if(collide("solid", x, y) != null)
		{
			x = prevPoint.x;
			y = prevPoint.y;
		}
		
		var ent:Entity = collide("coin", x, y);
		if(ent != null)
		{
			var cn:Coin = cast(ent, Coin);
			money += cn.coinAmount;
			scene.remove(cn);
			var sound = new Sfx("audio/player_soundMoney.wav");
			sound.play(SettingsMenu.soudVolume / 10);
		}
		
		ent = collide("potion", x, y);
		if(ent != null && life < 100)
		{
			var cn:Potion = cast(ent, Potion);
			life += cn.potionAmount;
			scene.remove(cn);
			var sound = new Sfx("audio/player_soundPotion.wav");
			sound.play(SettingsMenu.soudVolume / 10);
		}
		
		if(life <= 0)
			isDead = true;
		if (life > 100)
			life = 100;
		
		setAnimations();
		
		HXP.camera.x = x - 400 + 20;
		HXP.camera.y = y - 300 + 40;
	}
	
}