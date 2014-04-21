package com.tpuquest.unitTests;
import com.tpuquest.character.*;
import haxe.unit.TestCase;

class TestEnemy extends haxe.unit.TestCase
{
	public function testNew()
	{
		var t:Enemy = new Enemy(20, 20, 1);
		assertEquals(t.x, 20);
		assertEquals(t.y, 20);
	}
}