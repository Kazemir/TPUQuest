package com.tpuquest.unitTests;
import com.haxepunk.graphics.Text;
import com.tpuquest.utils.DrawText;
import haxe.unit.TestCase;
import com.haxepunk.Entity;

class TestDrawText extends haxe.unit.TestCase
{
	public function testCreateTextEntity()
	{
		var e1:Text = DrawText.CreateTextEntity("TEST", GameFont.Arial, 25, 10, 15, 0xFFFFFF, false);
		var e2:Text = DrawText.CreateTextEntity("TEST", GameFont.Arial, 25, 11, 21, 0xFFFFFF, true);
		
		assertEquals(e1.x, 10);
		assertEquals(e1.y, 15);
		assertEquals(e2.x, 11);
		assertEquals(e2.y, 21);
    }
	
	public function testNew()
	{
		try
		{
			var test:DrawText = new DrawText("TEST", GameFont.Arial, -25, 10, 15, 0xFFFFFF, false);
			var test1:DrawText = new DrawText("TEST", GameFont.Arial, 25, 10, 15, -53, false);
			var test2:DrawText = new DrawText("TEST", GameFont.Arial, 25, 10, 15, 0xFFFFFFF, false);
		}
		catch (msg : String)
		{
			assertEquals("Error! Incorrect parameters!", msg);
		}
    }
	
	public function testChangeStr()
	{
		var test:DrawText = new DrawText("TEST", GameFont.Arial, 25, 10, 15, 0xFFFFFF, false);
		test.ChangeStr("TEST2", false);
		assertEquals("TEST2", test.label.text);
	}
	
	public function testChangeColor()
	{
		var test:DrawText = new DrawText("TEST", GameFont.Arial, 25, 10, 15, 0xFFFFFF, false);
		test.ChangeColor(0x0);
		assertEquals(0x0, test.label.color);
	}
	
	public function testChangePoint()
	{
		var test:DrawText = new DrawText("TEST", GameFont.Arial, 25, 10, 15, 0xFFFFFF, false);
		test.ChangePoint(5.0, 6.0);
		assertEquals(test.label.x, 5.0);
		assertEquals(test.label.y, 6.0);
	}
}