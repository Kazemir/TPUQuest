package com.tpuquest.entity.character;
import com.haxepunk.Entity;
import com.tpuquest.screen.GameScreen;
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
	public static inline var kJumpForce:Int = 20;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	public function new(point:Point, spritePath:String, hp:Int = 50, enemyType:Int = 0, name:String = "", behavior:Bool = true)
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		this.enemyType = enemyType;
		this.life = hp;
		this.isDead = false;
		
		switch(enemyType)
		{
			case 0:	//Biter
				sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
				sprite.add("idle", [3, 4], 2, true);
				sprite.play("idle");
				sprite.scale = 2.7;
				hp = 40;
				//sprite.x = -40;
				setHitbox(81, 80);
			case 1:	//Goblin
				sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
				sprite.add("idle", [0, 0, 0, 0, 0, 10], 3, true);
				sprite.add("walk", [1, 12, 2, 11], 10, true);
				sprite.play("idle");
				sprite.scale = 2.7;
				hp = 50;
				setHitbox(81, 80);
			case 2:	//LAV
				sprite = new Spritemap("graphics/characters/lav.png", 303, 152);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 1.05;
				setHitbox(303, 160);
				hp = 10;
			case 3:	//Vova
				sprite = new Spritemap("graphics/characters/vova.png", 132, 378);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(87 - 80);
				setHitbox(30, 87, 0, (87 - 80));
				hp = 10;
			case 4:	//Misha
				sprite = new Spritemap("graphics/characters/kazemir.png", 192, 342);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(79 - 80);
				setHitbox(44, 79, 0, (79 - 80));
				hp = 10;
			case 5:	//Vetal
				sprite = new Spritemap("graphics/characters/droz.png", 138, 348);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(80 - 80);
				setHitbox(32, 80, 0, (80 - 80));
				hp = 10;
			case 6:	//Seroga
				sprite = new Spritemap("graphics/characters/serg.png", 252, 462);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.23;
				sprite.y = -(106 - 80);
				setHitbox(58, 106, 0, (106 - 80));
				hp = 10;
			case 7:	//Doctor
				sprite = new Spritemap("graphics/characters/doctor.png", 891, 532);
				sprite.add("idle", [0], 3, false);
				sprite.play("idle");
				sprite.scale = 0.2255;
				hp = 9999;
				//sprite.y = -(106 - 80);
				//setHitbox(58, 106, 0);
			default:
				sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
				sprite.add("idle", [3, 4], 2, true);
				sprite.play("idle");
				sprite.scale = 2.7;
				setHitbox(81, 80);
		}
		
		type = "enemy";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = kMoveSpeed;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
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
			
			var ent:Entity = collide("player", x, y);
			if(ent != null)
			{
				var pl:Player = cast(ent, Player);
				
				if (pl.attack)
				{
					var sound = new Sfx("audio/enemy_pain.wav");
					/*switch(enemyType)
					{
						case 2:	//LAV
							sound = new Sfx("audio/LAV_pain.wav");
						case 3:	//Vova
							sound = new Sfx("audio/LAV_Roul2.wav");
						case 4:	//Misha
							sound = new Sfx("audio/LAV_Kaz.wav");
						case 5:	//Vetal
							sound = new Sfx("audio/LAV_Droz.wav");
						case 6:	//Seroga
							sound = new Sfx("audio/LAV_Pelew.wav");
					}*/
					if(enemyType < 2 || enemyType > 6)
						sound.play(SettingsMenu.soudVolume / 10);
				}
			}
			
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
				
			if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen" && enemyType == 1)
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
			
			if(enemyType == 1)
				setAnimations();
				
			prevPoint = new Point(x, y);
		}
		else
		{
			super.update();
		}
	}
}