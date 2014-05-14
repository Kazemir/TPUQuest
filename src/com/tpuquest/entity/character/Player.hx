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
import com.tpuquest.utils.PointXY;
import flash.geom.Point;
import com.haxepunk.Sfx;

class Player extends Character
{
	public var money:Int;
	public var life:Int;
	public var weaponDamage:Int;
	public var weaponized:Bool;
	
	private var sprite:Spritemap;

	public static inline var kMoveSpeed:Float = 5;
	public static inline var kJumpForce:Int = 23;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	private var attack:Bool;
	
	public var controlOn:Bool;
	
	private var currentScene:GameScreen;
	
	
	public function new(point:Point, spritePath:String, hp:Int = 100, money:Int = 0, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		
		sprite = new Spritemap(spritePath, 32, 32);
		sprite.add("norm_idle", [8, 8, 8, 9], 3, true);
		sprite.add("norm_walk", [0, 1, 2, 3, 4, 5, 6, 7], 19, true);
		sprite.add("norm_jump", [10]);

		sprite.add("grav_idle", [19, 19, 19, 20], 2, true);
		sprite.add("grav_walk", [11, 12, 13, 14, 15, 16, 17, 18], 19, true);
		sprite.add("grav_jump", [21]);

		sprite.play("norm_idle");
	 
		sprite.scale = 2.5;
		sprite.x = -20;
		
		setHitbox(40, 80);
		//setHitboxTo(sprite);
		type = "player";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		this.money = money;
		this.life = hp;
		this.isDead = false;
		this.controlOn = true;
		
		weaponized = false;
		weaponDamage = 0;
	}
	
	public override function added()
	{
		if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
			currentScene = cast(scene, GameScreen);
	}
	
	private function setAnimations()
	{
		if (attack)
		{
			sprite.play("norm_jump");
		}
		else if (!_onGround)
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
		if (behaviorOn)
		{
			acceleration.x = acceleration.y = 0;

			if (!_onGround)
				hasTouchTheGround = false;
			
			if ( !hasTouchTheGround && _onGround) 
			{
				hasTouchTheGround = true;
				controlOn = true;
				var sound = new Sfx("audio/player_soundJumpStop.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			if (controlOn && !Screen.overrideControlByBox)
			{
				if (Input.check("left") || Screen.joyCheck("DPAD_LEFT"))
				{
					acceleration.x = -kMoveSpeed;
				}
				if (Input.check("right") || Screen.joyCheck("DPAD_RIGHT"))
				{
					acceleration.x = kMoveSpeed;
				}
				if ((Input.pressed("jump") || Screen.joyCheck("X")) && _onGround)
				{
					acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
					
					var sound = new Sfx("audio/player_soundJumpStart.wav");
					sound.play(SettingsMenu.soudVolume / 10);
				}
				if ((Input.pressed("action") || Screen.joyCheck("A")) && weaponized)
				{
					attack = true;
				}
			}
			
			super.update();
			
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
			
			ent = collide("enemy", x, y);
			if (ent == null)
				ent = collide("boss", x, y);
			if(ent != null)
			{
				var cn:Enemy = cast(ent, Enemy);
				if (attack)
				{
					cn.life -= weaponDamage;
					if (cn.velocity.x < 0)
					{
						cn.velocity.x = Enemy.kMoveSpeed * 5;
					}
					else
					{
						cn.velocity.x = -Enemy.kMoveSpeed * 5;
					}
					cn.velocity.y = -HXP.sign(cn.gravity.y) * Enemy.kJumpForce * 0.5;
				}
				else
				{
					controlOn = false;
					var sound = new Sfx("audio/player_soundPain.wav");
					sound.play(SettingsMenu.soudVolume / 10);
					life -= 5;
					if (velocity.x < 0)
					{
						velocity.x = kMoveSpeed * 5;
					}
					else
					{
						velocity.x = -kMoveSpeed * 5;
					}
					velocity.y = -HXP.sign(gravity.y) * kJumpForce * 0.5;
				}
			}
			
			ent = collide("helper", x, y);
			if(ent != null)
			{
				switch(Type.getClassName(Type.getClass(ent)))
				{
					case "com.tpuquest.entity.helper.ChangeMap":
						var cm:ChangeMap = cast(ent, ChangeMap);
						currentScene.NextMap(cm.nextMapPath, cm.keepPlayer, cm.instantly);
					case "com.tpuquest.entity.helper.ShowMessage":
						var sm:ShowMessage = cast(ent, ShowMessage);
					case "com.tpuquest.entity.helper.Spawn":
						var sp:Spawn = cast(ent, Spawn);
				}
			}
			
			ent = collide("weapon", x, y);
			if(ent != null)
			{
				var wp:Weapon = cast(ent, Weapon);
				weaponized = true;
				weaponDamage = wp.weaponDamage;
				scene.remove(wp);
				var sound = new Sfx("audio/player_soundSword.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			if (life <= 0)
			{
				life = 0;
				isDead = true;
				controlOn = false;
				behaviorOn = false;
			}
			if (life > 100)
				life = 100;
			
			setAnimations();
			HXP.camera.x = x - 400 + 20;
			HXP.camera.y = y - 300 + 40;
		}
		else
		{
			super.update();
			setAnimations();
		}
	}
	
}