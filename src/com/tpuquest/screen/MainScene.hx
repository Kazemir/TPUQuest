package com.tpuquest.screen;
import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Touch;
import com.tpuquest.character.Player;
import flash.system.System;
import com.haxepunk.graphics.Text;
import com.haxepunk.Sfx;
import com.haxepunk.HXP;

class MainScene extends Screen
{
	public function new()
	{
		super();
	}
	
	public override function begin()
	{
		tommy = new Sfx("audio/Tommy-zola.mp3");
		music = new Sfx("audio/WouldntItBeNice.mp3");
		img = new Image("graphics/girl.jpg");
		
		//infoText = new Text("TPUQuest. Альфа v. 0.0.1", 5, 5);
		text = new Text("0, 0", 10, 30);
		text.size = 16;
		//infoText.size = 24;
		text.font = "font/Imperial.ttf";
		//infoText.font = "font/Imperial.ttf";
		//text.resizable = true;
		//text.scrollX = text.scrollY = 0;
		
		var overlay:Entity = new Entity(20, 20, text);
		overlay.layer = 0;
		add(overlay);
		
		//var overlay2:Entity = new Entity(5, 5, infoText);
		//overlay2.layer = 0;
		//add(overlay2);
		
		img.scale = 0.5;
		block = addGraphic(img);
		
		add(new Player(20, 20));
		
		super.begin();
	}
	
	public override function update()
	{
		if (Input.check("left"))
		{
			block.moveBy(-2, 0);
		}
		if (Input.check("right"))
		{
			block.moveBy(2, 0);
		}
		if (Input.check("up"))
		{
			block.moveBy(0, -2);
		}
		if (Input.check("down"))
		{
			block.moveBy(0, 2);
		}
		if (Input.pressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		if (Input.pressed(Key.T))
		{
			tommy.play();
			HXP.windowHeight = 1024;
		}
		if (Input.pressed(Key.X))
		{
			//text = null;
			
		}
		if (Input.pressed(Key.M))
		{
			if(music.playing)
				music.stop();
			else
				music.resume();
		}
		if (Input.mouseWheel)
		{
			if (Input.mouseWheelDelta > 0)
			{
				img.scale += 0.02;
			}
			else 
			{
				img.scale -= 0.02;
			}
		}
		text.text = Std.string(block.x) + ", " + Std.string(block.y);
		super.update();
	}
 
	private var block:Entity;
	private var text:Text;
	private var infoText:Text;
	private var img:Image;
	private var tommy:Sfx;
	private var music:Sfx;
}