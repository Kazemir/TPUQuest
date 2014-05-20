package com.tpuquest.entity.character;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.Spawn;
import com.tpuquest.entity.helper.Teleporter;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.LevelEditor;
import com.tpuquest.screen.LoseScreen;
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
	public var attack:Bool;
	
	public var controlOn:Bool;
	
	private var currentScene:GameScreen;
	
	public function new(point:Point, spritePath:String, hp:Int = 100, money:Int = 0, weaponDamage:Int = 0, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		
		sprite = new Spritemap(spritePath, 32, 32);
		sprite.add("idle", [8, 8, 8, 9], 3, true);
		sprite.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 19, true);
		sprite.add("jump", [10]);
		sprite.add("attack", [16, 15, 14, 13], 20, false);

		sprite.play("idle");
	 
		sprite.scale = 2.5;
		sprite.x = -20;
		
		setHitbox(40, 80);
		type = "player";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = kMoveSpeed;
		friction.x = 0.82;
		friction.y = 0.99;
		
		this.money = money;
		this.life = hp;
		this.isDead = false;
		this.controlOn = true;
		
		if (weaponDamage > 0)
		{
			weaponized = true;
			this.weaponDamage = weaponDamage;
		}
		else
		{
			weaponized = false;
			this.weaponDamage = 0;
		}
	}
	
	public override function added()
	{
		if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
			currentScene = cast(scene, GameScreen);
	}
	
	private function setAnimations()
	{
		if (attack || sprite.currentAnim == "attack")
		{
			if (sprite.complete)
			{
				attack = false;
				setHitbox(40, 80, 0, 0);
				sprite.play("idle");
			}
		}
		else if (!_onGround)
		{
			sprite.play("jump");
			
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
				controlOn = true;
				var sound = new Sfx("audio/player_soundJumpStop.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			if (controlOn && !Screen.overrideControlByBox)
			{
				if (Input.check("left") || Screen.joyCheck("DPAD_LEFT") || Screen.touchCheck("left"))
				{
					acceleration.x = -kMoveSpeed;
				}
				if (Input.check("right") || Screen.joyCheck("DPAD_RIGHT") || Screen.touchCheck("right"))
				{
					acceleration.x = kMoveSpeed;
				}
				if ((Input.pressed("jump") || Screen.joyPressed("X") || Screen.touchPressed("up")) && _onGround)
				{
					acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
					
					var sound = new Sfx("audio/player_soundJumpStart.wav");
					sound.play(SettingsMenu.soudVolume / 10);
				}
				if ((Input.pressed("action") || Screen.joyPressed("A") || Screen.touchPressed("action")) && weaponized)
				{
					attack = true;
					sprite.play("attack", true);
					
					if (sprite.flipped) //left
					{
						setHitbox(70, 80, 30);
					}
					else
					{
						setHitbox(70, 80, 0);
					}
					
					//setAnimations();
					var sound = new Sfx("audio/player_attack.wav");
					sound.play(SettingsMenu.soudVolume / 10);
				}
			}
			
			super.update();
			
			var ent:Entity = collide("coin", x, y);
			if(ent != null)
			{
				var cn:Coin = cast(ent, Coin);
				money += cn.coinAmount;
				scene.remove(cn);
				
				if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
					currentScene.lvl.items.remove(cn);
				
				var sound = new Sfx("audio/player_soundMoney.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			ent = collide("potion", x, y);
			if(ent != null && life < 100)
			{
				var cn:Potion = cast(ent, Potion);
				life += cn.potionAmount;
				scene.remove(cn);
				
				if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
					currentScene.lvl.items.remove(cn);
				
				var sound = new Sfx("audio/player_soundPotion.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			ent = collide("enemy", x, y);
			if(ent != null)
			{
				var cn:Enemy = cast(ent, Enemy);
				if (attack && controlOn)
				{
					cn.life -= weaponDamage;
					if (cn.enemyType == 1)
					{
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
					
					var sound = new Sfx("audio/enemy_pain.wav");
					if(cn.enemyType < 2 || cn.enemyType > 7)
						sound.play(SettingsMenu.soudVolume / 10);
						
					attack = false;
					setHitbox(40, 80, 0, 0);
				}
				else if(controlOn)
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
			
			ent = collide("boss", x, y);
			if (ent != null)
			{
				var cn:Boss = cast(ent, Boss);
				if (attack && controlOn)
				{
					cn.life -= weaponDamage;
					
					attack = false;
					setHitbox(40, 80, 0, 0);
				}
				else if(controlOn)
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
						currentScene.lvl.helpers.remove(cm);
						currentScene.remove(cm);
						currentScene.NextMap(cm.nextMapPath, cm.keepPlayer, cm.instantly);
					case "com.tpuquest.entity.helper.ShowMessage":
						var sm:ShowMessage = cast(ent, ShowMessage);
					case "com.tpuquest.entity.helper.Spawn":
						var sp:Spawn = cast(ent, Spawn);
					case "com.tpuquest.entity.helper.Teleporter":
						var tp:Teleporter = cast(ent, Teleporter);
						/*//controlOn = false;
						behaviorOn = false;
						this.set_x(tp.x);
						this.set_y(tp.y);
						behaviorOn = true;
						//this.
						//controlOn = true;
						//moveBy(tp.x - x, tp.y - y);*/
					case "com.tpuquest.entity.helper.KillTheHuman":
						life = 0;
				}
			}
			
			ent = collide("weapon", x, y);
			if(ent != null)
			{
				var wp:Weapon = cast(ent, Weapon);
				weaponized = true;
				weaponDamage = wp.weaponDamage;
				scene.remove(wp);
				
				if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
					currentScene.lvl.items.remove(wp);
				
				var sound = new Sfx("audio/player_soundSword.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			if (life <= 0)
			{
				life = 0;
				isDead = true;
				controlOn = false;
				behaviorOn = false;
				
				currentScene.music.stop();
				HXP.scene = new LoseScreen();
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