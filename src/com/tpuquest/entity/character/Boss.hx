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
import haxe.Timer;

import com.haxepunk.graphics.Emitter;

class Boss extends Character
{
	public var life:Int;
		
	private var sprite:Spritemap;
	private var emitter:Emitter;
	
	public static inline var kMoveSpeed:Float = 3;
	public static inline var kJumpForce:Int = 22;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	private var godMode:Bool;
	
	public function new(point:Point, spritePath:String, hp:Int = 100, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		
		sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
		sprite.add("idle", [5, 5, 5, 5, 5, 15], 3, true);
		sprite.add("walk", [6, 17, 7, 16], 5, true);
		sprite.play("idle");
		
		sprite.scale = 5.0;
		
		setHitbox(150, 150);
		type = "boss";
		graphic = sprite;

		emitter = new Emitter("graphics/particle.png", 10, 10);
		
		emitter.newType("landingL", [2]);
		emitter.setMotion("landingL", 150, 80, 0.1, 40, 5, 0.05);
		emitter.setAlpha("landingL", 1, 0);
		emitter.setGravity("landingL", -2, 0.5);
		
		emitter.newType("landingR", [2]);
		emitter.setMotion("landingR", 30, 80, 0.1, -40, 5, 0.05);
		emitter.setAlpha("landingR", 1, 0);
		emitter.setGravity("landingR", -2, 0.5);
		
		emitter.newType("blood", [1]);
		emitter.setAlpha("blood", 1, 0);
		emitter.setGravity("blood", 8, 0.5);
		emitter.setMotion("blood", 0, 80, 0.3, 360, 5, 0.05);
		emitter.setColor("blood", 0x00FF00, 0x00FF00);
		addGraphic(emitter);
		
		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;
		friction.x = 0.82; 
		friction.y = 0.99;
		
		this.life = 300;
		isDead = false;
		godMode = false;
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
			sprite.resume();
			
			acceleration.x = acceleration.y = 0;
 
			if (!_onGround)
				hasTouchTheGround = false;
			
			if ( !hasTouchTheGround && _onGround) 
			{
				hasTouchTheGround = true;
				var sound = new Sfx("audio/player_soundJumpStop.wav");
				sound.play(SettingsMenu.soudVolume / 10);
				
				for (x in 0...10)
				{
					emitter.emit("landingL", 50, 150);
					emitter.emit("landingR", 110, 150);
				}
			}
			
			var ent:Entity = collide("sword", x, y);
			if(ent != null && Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen" && !godMode)
			{
				var currentScene:GameScreen = cast(scene, GameScreen);
				
				godMode = true;
				
				var timer:Timer = new Timer(300);
				timer.run = function() { godMode = false; timer.stop(); };
				
				life -= currentScene.player.weaponDamage;
				
				var sound = new Sfx("audio/enemy_pain.wav");
				sound.play(SettingsMenu.soudVolume / 10);
				
				for (x in 0...20)
					emitter.emit("blood", width / 2, height / 2);
				
				sprite.color = 0xFF0000;
				var timer2:Timer = new Timer(150);
				timer2.run = function() { sprite.color = 0xFFFFFF; timer2.stop(); };
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
				if (pl.distanceFrom(this, false) < 7*40 && pl.distanceFrom(this, false) > 75)
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
		else
		{
			super.update();
			sprite.pause();
		}
	}
}