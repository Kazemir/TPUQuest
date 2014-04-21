package com.tpuquest.unitTests;
import com.tpuquest.character.*;
import haxe.unit.TestCase;

class TestBoss extends haxe.unit.TestCase
{
	public function testNew()
	{
		var t:Boss = new Boss(20, 20, 1);
		assertEquals(t.x, 20);
		assertEquals(t.y, 20);
	}
}