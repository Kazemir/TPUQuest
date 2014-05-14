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

class Boss extends Character
{
	public var life:Int;
		
	private var sprite:Spritemap;
	
	public static inline var kMoveSpeed:Float = 5;
	public static inline var kJumpForce:Int = 22;
	public var hasTouchTheGround(default, null) : Bool;
	public var isDead:Bool;
	
	public function new(point:Point, spritePath:String, hp:Int = 100, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		hasTouchTheGround = true;
		
		sprite = new Spritemap("graphics/characters/gremlins.png", 30, 30);
		sprite.add("idle", [5, 5, 5, 5, 5, 15], 3, true);
		sprite.add("walk", [6, 17, 7, 16], 19, true);
		sprite.play("idle");
		
		sprite.scale = 5.0;
		sprite.x = -20;
		
		setHitbox(40, 80);
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
			
			setAnimations();
		}
	}
}