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

class Talker extends Character
{
	private var sprite:Spritemap;
	public var speaking:Bool;
	
	private static inline var kMoveSpeed:Float = 5;
	private static inline var kJumpForce:Int = 22;
	
	public function new(point:Point, spritePath:String, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		sprite = new Spritemap("graphics/characters/wily.png", 55, 45);
		sprite.add("idle", [17, 18], 2, true);
		sprite.add("point", [15, 15, 15, 15, 7, 9, 11, 12], 5, false);
		sprite.add("speak", [14, 15], 4, true);
		sprite.play("idle");
		
		sprite.scale = 1.8;
		//sprite.x = -49.5;
		
		setHitbox(99, 81);
		type = "talker";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		speaking = false;
		
		layer = 1;
	}
	
	private function setAnimations()
	{
		if (Type.getClassName(Type.getClass(scene)) == "com.tpuquest.screen.GameScreen")
		{
			var pl:Player = cast(scene, GameScreen).player;

			if (pl.distanceFrom(this, false) < 6*40)
			{
				sprite.play("point");
				if (pl.x < this.x)
					sprite.flipped = false;
				else
					sprite.flipped = true;
			}
			else
			{
				sprite.play("idle");
			}
		}
		else
		{
			sprite.play("idle");
		}
	}
	
	public override function update()
	{
		if (behaviorOn)
		{
			sprite.resume();
			acceleration.x = acceleration.y = 0;
			
			super.update();
			
			if (speaking)
				sprite.play("speak");
			else
				setAnimations();
		}
		else
		{
			super.update();
			sprite.pause();
		}
	}
}