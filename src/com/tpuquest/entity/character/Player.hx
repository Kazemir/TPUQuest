package com.tpuquest.entity.character;

import com.tpuquest.screen.MultiplayerGameScreen;
import haxe.Timer;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;

import com.tpuquest.dialog.DialogBox;
import com.tpuquest.dialog.TradeBox;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.Teleporter;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Item;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.screen.GameScreen;
import com.tpuquest.screen.LevelEditor;
import com.tpuquest.screen.LoseScreen;
import com.tpuquest.screen.Screen;
import com.tpuquest.screen.SettingsMenu;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.utils.CLocals;

import flash.geom.Point;

class Player extends Character
{
	public var money:Int;
	public var life:Int;
	public var weaponDamage:Int;
	public var weaponized:Bool;
	
	private var sprite:Spritemap;
	private var emitter:Emitter;
	private var helpText:DrawText;
	
	public var isDead:Bool;
	public var controlOn:Bool;
	private var godMode:Bool;

	public static inline var kMoveSpeed:Float = 5;
	public static inline var kJumpForce:Int = 23;
	public var hasTouchTheGround(default, null) : Bool;
	
	private var currentScene:GameScreen;
	
	public function new(point:Point, spritePath:String, hp:Int = 100, money:Int = 0, weaponDamage:Int = 0, name:String = "", behavior:Bool = true) 
	{
		super(point, "graphics/characters/character.png", name, behavior);
		
		eyesToTheRight = true;
		hasTouchTheGround = true;
		
		sprite = new Spritemap("graphics/characters/character.png", 32, 32);
		sprite.add("idle", [8, 8, 8, 9], 3, true);
		sprite.add("walk", [0, 1, 2, 3, 4, 5, 6, 7], 19, true);
		sprite.add("jump", [10]);
		sprite.add("attack", [16, 15, 14, 13, 13, 13, 13], 30, false);

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
		
		emitter = new Emitter("graphics/particle.png", 10, 10);
		addGraphic(emitter);
				
		emitter.newType("landingL", [2]);
		emitter.setMotion("landingL", 150, 40, 0.1, 40, 5, 0.05);
		emitter.setAlpha("landingL", 1, 0);
		emitter.setGravity("landingL", -2, 0.5);
		
		emitter.newType("landingR", [2]);
		emitter.setMotion("landingR", 30, 40, 0.1, -40, 5, 0.05);
		emitter.setAlpha("landingR", 1, 0);
		emitter.setGravity("landingR", -2, 0.5);
		
		emitter.newType("blood", [1]);
		emitter.setMotion("blood", 0, 30, 0.2, 360, 5, 0.05);
		emitter.setAlpha("blood", 1, 0);
		emitter.setGravity("blood", -2, 0.5);
		emitter.setColor("blood", 0xFF0000, 0xFF0000);
		
		helpText = new DrawText("TRADE", GameFont.PixelCyr, 14, 23, -15, 0, true);
		addGraphic(helpText.label);
		helpText.label.visible = false;
		
		this.money = money;
		this.life = hp;
		this.isDead = false;
		this.controlOn = true;
		this.godMode = false;
		
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
		if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.MultiplayerGameScreen")
			currentScene = cast(scene, MultiplayerGameScreen);
	}
	
	private function setAnimations()
	{
		if (sprite.currentAnim == "attack")
		{
			//attack = false;
			//setHitbox(40, 80, 0, 0);
			if(sprite.complete)
				sprite.play("idle");
		}
		else if (!_onGround)
		{
			sprite.play("jump");
			
			if (velocity.x < 0) // left
			{
				eyesToTheRight = false;
				sprite.flipped = true;
			}
			else if(velocity.x > 0) // right
			{
				eyesToTheRight = true;
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
				eyesToTheRight = false;
				sprite.flipped = true;
			}
			else // right
			{
				eyesToTheRight = true;
				sprite.flipped = false;	
			}
		}
	}
	
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
				controlOn = true;
				var sound = new Sfx("audio/player_soundJumpStop.wav");
				sound.play(SettingsMenu.soudVolume / 10);
				
				for (x in 0...10)
				{
					emitter.emit("landingL", 20, 80);
					emitter.emit("landingR", 20, 80);
				}
			}
			
			var ent:Entity;
			
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
				if ((Input.pressed("jump") || Screen.joyPressed("A") || Screen.touchPressed("jump")) && _onGround)
				{
					acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
					
					var sound = new Sfx("audio/player_soundJumpStart.wav");
					sound.play(SettingsMenu.soudVolume / 10);
				}
				if (Input.pressed("action") || Screen.joyPressed("X") || Screen.touchPressed("action"))
				{
					if((ent = collide("trader", x, y)) != null)
					{
						var traderList:Array<Item> = new Array<Item>();
						traderList.push(new Potion(new PointXY(0, 0), 25, "graphics/items/potion_red_small.png"));
						traderList.push(new Potion(new PointXY(0, 0), 50, "graphics/items/potion_red.png"));
						traderList.push(new Potion(new PointXY(0, 0), 100, "graphics/items/heart.png"));
						var t:TradeBox = new TradeBox(HXP.halfWidth, HXP.halfHeight, CLocals.text.game_traderBox_caption, traderList, [5, 10, 15]);
						currentScene.add(t);
						
						for (x in currentScene.lvl.characters)
							x.behaviorOn = false;
					}
					else if((ent = collide("talker", x, y)) != null)
					{
						var t:DialogBox = new DialogBox(HXP.halfWidth, HXP.halfHeight, CLocals.text.game_talkerBox_caption);
						currentScene.add(t);
						
						for (x in currentScene.lvl.characters)
							x.behaviorOn = false;
					}
					else if ((ent = collide("helper", x, y)) != null)
					{
						if (Type.getClassName(Type.getClass(ent)) == "com.tpuquest.entity.helper.ChangeMap")
						{
							var cm:ChangeMap = cast(ent, ChangeMap);
							if (cm.removeAfterUsing)
							{
								currentScene.lvl.helpers.remove(cm);
								currentScene.remove(cm);
							}
							currentScene.NextMap(cm.nextMapPath, cm.keepPlayer, cm.instantly);
						}
					}
					else if (weaponized && sprite.currentAnim != "attack")
					{
						sprite.play("attack", true);
						
						/*var sword:Entity = new Entity(0, 0);
						var swordLength:Int = 70;
						sword.setHitbox(swordLength, 40);
						
						if (sprite.flipped) //left
							sword.x = this.x + 40 - swordLength - 5;
						else
							sword.x = this.x + 5;
						
						sword.y = this.y + 30;
						sword.type = "enemy_sword";*/
						
						var sword:Sword = new Sword(this);
						currentScene.add(sword);
						
						var tm:Timer = new Timer(10);
						tm.run = function() 
						{
							if (sprite.currentAnim != "attack")
							{
								tm.stop();
								currentScene.remove(sword);
							}
							/*else
							{
								if (this.eyesToTheRight) //left
									sword.x = this.x + 40 - swordLength - 5;
								else
									sword.x = this.x + 5;
								sword.y = this.y + 30;
							}*/
						};
						
						var sound = new Sfx("audio/player_attack.wav");
						sound.play(SettingsMenu.soudVolume / 10);
					}
				}
			}
			
			helpText.label.visible = false;
			if ((ent = collide("trader", x, y)) != null)
			{
				helpText = new DrawText(CLocals.text.gameHelp_trade, GameFont.PixelCyr, 14, 23, -15, 0, true);
				addGraphic(helpText.label);
			}
			else if ((ent = collide("talker", x, y)) != null)
			{
				helpText = new DrawText(CLocals.text.gameHelp_talk, GameFont.PixelCyr, 14, 23, -15, 0, true);
				addGraphic(helpText.label);
			}
			else if ((ent = collide("helper", x, y)) != null)
			{
				if (Type.getClassName(Type.getClass(ent)) == "com.tpuquest.entity.helper.ChangeMap")
				{
					helpText = new DrawText(CLocals.text.gameHelp_enter, GameFont.PixelCyr, 14, 23, -15, 0, true);
					addGraphic(helpText.label);
				}
			}
			
			ent = collide("coin", x, y);
			if(ent != null)
			{
				var cn:Coin = cast(ent, Coin);
				money += cn.coinAmount;
				scene.remove(cn);
				
				if (currentScene != null)
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
				
				if (currentScene != null)
					currentScene.lvl.items.remove(cn);
				
				var sound = new Sfx("audio/player_soundPotion.wav");
				sound.play(SettingsMenu.soudVolume / 10);
			}
			
			if(collide("enemy", x, y) != null || collide("boss", x, y) != null || collide("enemy_sword", x, y) != null)
			{
				if(controlOn && !godMode)
				{
					controlOn = false;
					godMode = true;
					
					var timer:Timer = new Timer(1500);
					
					timer.run = function() { godMode = false; sprite.alpha = 1.0; timer.stop(); };
					
					var sound = new Sfx("audio/player_soundPain.wav");
					sound.play(SettingsMenu.soudVolume / 10);
					life -= 5;
					
					var test:Bool;
					
					if ((ent = collide("enemy_sword", x, y)) != null)
						test = cast(ent, Sword).father.eyesToTheRight;
					else
						test = velocity.x < 0;
					
					if (test)
					{
						velocity.x = kMoveSpeed * 5;
					}
					else
					{
						velocity.x = -kMoveSpeed * 5;
					}
					velocity.y = -HXP.sign(gravity.y) * kJumpForce * 0.5;
					
					for (x in 0...20)
						emitter.emit("blood", width / 2, height / 2);
					
					sprite.color = 0xFF0000;
					var timer2:Timer = new Timer(150);
					timer2.run = function() 
					{ 
						sprite.color = 0xFFFFFF; 
						sprite.alpha = 0.5; 
						timer2.stop(); 
					};
				}
			}
			
			ent = collide("helper", x, y);
			if(ent != null)
			{
				switch(Type.getClassName(Type.getClass(ent)))
				{
					case "com.tpuquest.entity.helper.ShowMessage":
						var sm:ShowMessage = cast(ent, ShowMessage);
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
				
				if (currentScene != null)
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
			
			super.update();
			setAnimations();
			
			HXP.camera.x = x - HXP.halfWidth + 20;
			HXP.camera.y = y - HXP.halfHeight + 40;
		}
		else
		{
			super.update();
			//setAnimations();
			sprite.pause();
		}
	}	
}