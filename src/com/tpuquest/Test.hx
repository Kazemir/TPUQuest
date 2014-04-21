package com.tpuquest;
import com.tpuquest.unitTests.*;
import flash.system.System;

class Test
{
	static function main() 
	{
		var r = new haxe.unit.TestRunner();
        r.add(new TestPointXY());
		r.add(new TestDrawText());
		r.add(new TestTalker());
		r.add(new TestPlayer());
		r.add(new TestBoss());
		r.add(new TestTrader());
		r.add(new TestEnemy());
        r.run();
		
		System.exit(0);
	}
}