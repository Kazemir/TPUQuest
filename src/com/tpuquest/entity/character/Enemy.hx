package com.tpuquest.entity.character;
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
	public var enemyType:Int; //0 - кусака, 1 - набигака
	
	private var sprite:Spritemap;
	
	public static inline var kMoveSpeed:Float = 5;
	public static inline var kJumpForce:Int = 22;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	public function new(point:Point, spritePath:String, hp:Int = 50, enemyType:Int = 0, name:String = "", behavior:Bool = true)
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		this.enemyType = enemyType;
		
		sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
		switch(enemyType)
		{
			case 0:
				sprite.add("idle", [3, 4], 2, true);
				sprite.play("idle");
				sprite.scale = 2.5;
				sprite.x = -20;
				setHitbox(40, 80);
			case 1:
				sprite.add("idle", [0, 0, 0, 0, 0, 10], 3, true);
				sprite.add("walk", [1, 12, 2, 11], 19, true);
				sprite.play("idle");
				sprite.scale = 2.5;
				sprite.x = -20;
				setHitbox(40, 80);
		}
		
		type = "enemy";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		life = hp;
		isDead = false;
	}
	
	private function setAnimations()
	{
		if (!_onGround)
		{
			sprite.play("walk");
			
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
			sprite.play("idle");
		}
		else
		{
			sprite.play("walk");

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
		if (behaviorOn)
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
			
			super.update();
			
			if (life <= 0)
			{
				life = 0;
				isDead = true;
			}
			if (life > 100)
				life = 100;
			
			if(enemyType == 1)
				setAnimations();
		}
	}
}