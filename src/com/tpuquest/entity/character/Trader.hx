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

class Trader extends Character
{
	private var sprite:Spritemap;
	
	private static inline var kMoveSpeed:Float = 5;
	private static inline var kJumpForce:Int = 22;
	
	public function new(point:Point, spritePath:String, name:String = "", behavior:Bool = true) 
	{
		super(point, spritePath, name, behavior);
		
		sprite = new Spritemap("graphics/characters/lukegg.png", 80, 164);
		sprite.add("idle", [0, 0, 0, 0, 1, 2, 2, 2, 2, 2, 2, 1, 3, 4, 5, 6, 6, 6, 6, 6, 7, 8], 3, true);
		sprite.play("idle");
		
		sprite.scale = 0.48;
		//sprite.x = -20;
		
		setHitbox(38, 79);
		type = "trader";
		graphic = sprite;

		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = 5;//kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
		
		layer = 1;
	}
	
	public override function update()
	{
		if (behaviorOn)
		{
			sprite.resume();
			
			acceleration.x = acceleration.y = 0;
			
			super.update();
		}
		else
		{
			super.update();
			sprite.pause();
		}
	}
}