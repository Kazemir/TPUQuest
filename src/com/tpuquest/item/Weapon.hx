package com.tpuquest.item;

class Weapon extends Item
{
	public var weaponDamage:Int;
	public var weaponType:Int;
	
	public function new(x:Int, y:Int, damage:Int, type:Int) 
	{
		super(x, y);
		
		this.weaponDamage = damage;
		this.weaponType = type;
	}
	
	public override function update()
	{
		super.update();
	}
}