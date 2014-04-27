package com.tpuquest.item;

class Coin extends Item
{
	public var coinAmount:Int;
	
	public function new(x:Int, y:Int, amount:Int) 
	{
		super(x, y);
		
		this.coinAmount = amount;
	}
	
	public override function update()
	{
		super.update();
	}
}