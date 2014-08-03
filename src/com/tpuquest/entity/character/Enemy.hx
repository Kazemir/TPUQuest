package com.tpuquest.entity.character;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.SettingsMenu;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.tpuquest.utils.PointXY;
import openfl.geom.Point;
import haxe.Timer;

class Enemy extends Character
{
	public var life:Int;
	public var enemyType:Int; //0 - кусака, 1 - набигака
	
	private var sprite:Spritemap;
	private var emitter:Emitter;
	
	public static inline var kMoveSpeed:Float = 5;
	public static inline var kJumpForce:Int = 20;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	public var wasAttacked:Bool;
	public var canAttack:Bool;
	
	private var godMode:Bool;
	
	public function new(point:Point, spritePath:String, hp:Int = 50, enemyType:Int = 0, name:String = "", behavior:Bool = true)
	{
		super(point, spritePath, name, behavior);
		
		wasAttacked = false;
		canAttack = true;
		hasTouchTheGround = true;
		this.enemyType = enemyType;
		this.life = hp;
		this.isDead = false;
		godMode = false;
		type = "enemy";
		
		emitter = new Emitter("graphics/particle.png", 10, 10);
		
		emitter.newType("landingL", [2]);
		emitter.setMotion("landingL", 150, 60, 0.1, 40, 5, 0.05);
		emitter.setAlpha("landingL", 1, 0);
		emitter.setGravity("landingL", -2, 0.5);
		
		emitter.newType("landingR", [2]);
		emitter.setMotion("landingR", 30, 60, 0.1, -40, 5, 0.05);
		emitter.setAlpha("landingR", 1, 0);
		emitter.setGravity("landingR", -2, 0.5);
		
		emitter.newType("blood", [1]);
		emitter.setAlpha("blood", 1, 0);
		emitter.setGravity("blood", -2, 0.5);
		emitter.setMotion("blood", 0, 30, 0.2, 360, 5, 0.05);
		emitter.setColor("blood", 0xFF0000, 0xFF0000);
		
		switch(enemyType)
		{
			case 0:	//Biter
				sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
				sprite.add("idle", [3, 4], 2, true);
				sprite.play("idle");
				sprite.scale = 2.7;
				life = 30;
				//sprite.x = -40;
				setHitbox(81, 80);
				
				emitter.setMotion("blood", 0, 60, 0.2, 360, 5, 0.05);
				emitter.setColor("blood", 0x00FF00, 0x00FF00);
			case 1:	//Goblin
				sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
				sprite.add("idle", [0, 0, 0, 0, 0, 10], 3, true);
				sprite.add("walk", [1, 12, 2, 11], 10, true);
				sprite.play("idle");
				sprite.scale = 2.7;
				life = 60;
				setHitbox(81, 80);
				
				emitter.setMotion("blood", 0, 60, 0.2, 360, 5, 0.05);
				emitter.setColor("blood", 0x00FF00, 0x00FF00);
			case 2:	//LAV
				sprite = new Spritemap("graphics/characters/lav.png", 303, 152);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 1.05;
				setHitbox(303, 160);
				life = 10;
			case 3:	//Vova
				sprite = new Spritemap("graphics/characters/vova.png", 132, 378);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(87 - 80);
				setHitbox(30, 87, 0, (87 - 80));
				life = 10;
			case 4:	//Misha
				sprite = new Spritemap("graphics/characters/kazemir.png", 192, 342);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(79 - 80);
				setHitbox(44, 79, 0, (79 - 80));
				life = 10;
			case 5:	//Vetal
				sprite = new Spritemap("graphics/characters/droz.png", 138, 348);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(80 - 80);
				setHitbox(32, 80, 0, (80 - 80));
				life = 10;
			case 6:	//Seroga
				sprite = new Spritemap("graphics/characters/serg.png", 252, 462);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(106 - 80);
				setHitbox(58, 106, 0, (106 - 80));
				life = 10;
			case 7:	//Doctor
				sprite = new Spritemap("graphics/characters/doctor.png", 891, 532);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.2255;
				life = 9999;
				//sprite.y = -(106 - 80);
				setHitbox(201, 120);
				type = "static";
			default:
				sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
				sprite.add("idle", [3, 4], 2, true);
				sprite.play("idle");
				sprite.scale = 2.7;
				setHitbox(81, 80);
		}
		sprite.smooth = false;
		graphic = sprite;
		
		addGraphic(emitter);
		
		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = kMoveSpeed;
		friction.x = 0.82;
		friction.y = 0.99;
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
			
			if ( !hasTouchTheGround && _onGround && enemyType == 1) 
			{
				hasTouchTheGround = true;
				var sound = new Sfx("audio/player_soundJumpStop.wav");
				sound.play(SettingsMenu.soudVolume / 10);
				
				for (x in 0...10)
				{
					emitter.emit("landingL", 40, 80);
					emitter.emit("landingR", 40, 80);
				}
			}
			
			var ent:Entity = collide("sword", x, y);
			if(ent != null && Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen" && !godMode)
			{
				//var currentScene:GameScreen = cast(scene, GameScreen);
				var agressor:Player = cast(cast(ent, Sword).father, Player);
				
				godMode = true;
				
				var timer:Timer = new Timer(300);
				timer.run = function() { godMode = false; timer.stop(); };
				
				life -= agressor.weaponDamage;
				if (enemyType == 1)
				{
					if (agressor.eyesToTheRight)
					{
						velocity.x = kMoveSpeed * 5;
					}
					else
					{
						velocity.x = -kMoveSpeed * 5;
					}
					velocity.y = -HXP.sign(gravity.y) * kJumpForce * 0.5;
				}
				
				var sound = new Sfx("audio/enemy_pain.wav");
				if(enemyType < 2 || enemyType > 7)
					sound.play(SettingsMenu.soudVolume / 10);
				
				wasAttacked = true;
				
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
				
				if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
				{
					var aaa:GameScreen = cast(scene, GameScreen);
					aaa.remove(this);
					aaa.lvl.characters.remove(this);
				}
				
					var sound = new Sfx("audio/enemy_death.wav");
					switch(enemyType)
					{
						case 2:	//LAV
							sound = new Sfx("audio/LAV_death.wav");
						case 3:	//Vova
							sound = new Sfx("audio/LAV_Roul2.wav");
						case 4:	//Misha
							sound = new Sfx("audio/LAV_Kaz.wav");
						case 5:	//Vetal
							sound = new Sfx("audio/LAV_Droz.wav");
						case 6:	//Seroga
							sound = new Sfx("audio/LAV_Pelew.wav");
					}
					sound.play(SettingsMenu.soudVolume / 10);
			}
				
			if (wasAttacked)
			{
				wasAttacked = false;
				canAttack = false;
				
				var timer:Timer = new Timer(500);
				timer.run = function() { canAttack = true; timer.stop(); };
			}
		
			if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen" && enemyType == 1 && canAttack)
			{
				var pl:Player = cast(scene, GameScreen).player;
				if (pl.distanceFrom(this, false) < 7*40 && pl.distanceFrom(this, false) > 40)
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
			
			if(enemyType == 1)
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