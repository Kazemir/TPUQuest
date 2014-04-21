package com.tpuquest.unitTests;
import com.tpuquest.utils.PointXY;
import haxe.unit.TestCase;

class TestPointXY extends haxe.unit.TestCase
{
	public function testNew()
	{
		var p:PointXY = new PointXY(1, 1);
		assertEquals(p.x, 1);
		assertEquals(p.y, 1);
	}
	public function testAdd()
	{
		var p1:PointXY = new PointXY(1, 1);
		var p2:PointXY = new PointXY(2, 2);
		var p3:PointXY = PointXY.Add(p1, p2);
		assertEquals(p3.x, 3);
		assertEquals(p3.y, 3);
    }
	
	public function testSubtract()
	{
		var p1:PointXY = new PointXY(2, 2);
		var p2:PointXY = new PointXY(1, 1);
		var p3:PointXY = PointXY.Subtract(p1, p2);
		assertEquals(p3.x, 1);
		assertEquals(p3.y, 1);
    }
}