package com.tpuquest.unitTests;
import com.tpuquest.character.Talker;
import haxe.unit.TestCase;

class TestTalker extends haxe.unit.TestCase
{
	public function testNew()
	{
		var t:Talker = new Talker(20, 20, 1, "TEST");
		assertEquals(t.x, 20);
		assertEquals(t.y, 20);
	}
}