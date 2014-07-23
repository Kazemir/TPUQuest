package com.tpuquest.entity;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.Mask;
import com.tpuquest.entity.character.Character;

class Sword extends Entity
{
	public var father:Character;
	
	public function new( father:Character ) 
	{
		this.father = father;
		
		super(0, 0);
		
		var swordLength:Int = 70;
		setHitbox(swordLength, 40);
		
		if (!father.eyesToTheRight) //left
			x = father.x + 40 - swordLength - 5;
		else
			x = father.x + 5;
		
		y = father.y + 30;
		
		if (Type.getClassName(Type.getClass(father)) == "com.tpuquest.entity.character.EnemyPlayer")
			type = "enemy_sword";
		else
			type = "sword";
	}	
}