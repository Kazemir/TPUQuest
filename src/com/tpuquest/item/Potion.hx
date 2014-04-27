package com.tpuquest.item;

class Potion extends Item
{
	public var potionAmount:Int;
	public var potionType:Int;
	
	public function new(x:Int, y:Int, amount:Int, type:Int = 1) 
	{
		super(x, y);
		
		this.potionAmount = amount;
		this.potionType = type;
		// 1 - heal
	}
	
	public override function update()
	{
		super.update();
	}
}