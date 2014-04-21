package com.tpuquest.unitTests;
import com.tpuquest.character.*;
import haxe.unit.TestCase;

class TestTrader extends haxe.unit.TestCase
{
	public function testNew()
	{
		var t:Trader = new Trader(20, 20, 1);
		assertEquals(t.x, 20);
		assertEquals(t.y, 20);
	}
}