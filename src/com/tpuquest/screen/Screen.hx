package com.tpuquest.screen;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.tpuquest.utils.DrawText;
import haxe.Utf8;

class Screen extends Scene
{
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		Input.define("left", [Key.LEFT, Key.A]);
		Input.define("right", [Key.RIGHT, Key.D]);
		Input.define("up", [Key.UP, Key.W]);
		Input.define("down", [Key.DOWN, Key.S]);
		Input.define("jump", [Key.SPACE]);
		Input.define("esc", [Key.ESCAPE]);
		Input.define("action", [Key.ENTER, Key.X]);
		
		addGraphic(DrawText.CreateTextEntity("TPUQuest. Alpha v0.0.2", GameFont.Molot, 12, 5, 5, 0x0, false));
		super.begin();
	}
	
	public override function update()
	{
		super.update();
	}
}