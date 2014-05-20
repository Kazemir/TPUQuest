package com.tpuquest.entity.character;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.Spawn;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.LevelEditor;
import com.tpuquest.screen.Screen;
import com.tpuquest.screen.SettingsMenu;
import com.tpuquest.screen.WinScreen;
import com.tpuquest.utils.PointXY;
import flash.geom.Point;
import com.haxepunk.Sfx;

import com.haxepunk.graphics.Emitter;

class Boss extends Character
{
	public var life:Int;
		
	private var sprite:Spritemap;
	
	public static inline var kMoveSpeed:Float = 2;
	public static inline var kJumpForce:Int = 22;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	public function new(point:Point, spritePath:String, hp:Int = 100, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		
		sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
		sprite.add("idle", [5, 5, 5, 5, 5, 15], 3, true);
		sprite.add("walk", [6, 17, 7, 16], 5, true);
		sprite.play("idle");
		
		sprite.scale = 5.0;
		//sprite.x = -75;
		
		setHitbox(150, 150);
		type = "boss";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		this.life = hp;
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
	
	private var prevPoint:Point = new Point(0, 0);
	
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
					
				var sound = new Sfx("audio/enemy_death.wav");
				sound.play(SettingsMenu.soudVolume / 10);
				
				if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
				{
					var aaa:GameScreen = cast(scene, GameScreen);
					aaa.remove(this);
					aaa.lvl.characters.remove(this);
					
					aaa.music.stop();
					HXP.scene = new WinScreen(aaa.player.money, aaa.player.life);
				}
			}
			
			if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
			{
				var pl:Player = cast(scene, GameScreen).player;
				if (pl.distanceFrom(this, false) < 7*40)
				{
					if (pl.x < this.x)
						velocity.x = -kMoveSpeed;
					else
						velocity.x = kMoveSpeed;
					
					if (x == prevPoint.x && y == prevPoint.y)
					{
						velocity.y = -HXP.sign(gravity.y) * kJumpForce;
					}
				}
			}
			
			setAnimations();
			
			prevPoint = new Point(x, y);
		}
	}
}