package com.tpuquest.screen;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.utils.Draw;
import com.tpuquest.character.Player;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.utils.DrawText;
import com.tpuquest.world.Level;
import flash.display.Sprite;
import flash.geom.Point;
import com.haxepunk.utils.Key;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import haxe.io.Eof;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;

import com.tpuquest.dialog.*;

class LevelEditor extends Screen
{
	private var coordsText:DrawText;
	private var elementText:DrawText;
	private var typeText:DrawText;
	
	private var cursorPos:Point;
	private var currentPos:Point;
	private var currentType:Int;
	private var currentElement:Int;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		addGraphic(Image.createRect(330, 85, 0x424242, 1), 0, 18, 22);
		
		addGraphic(Image.createRect(9999, 1, 0, 1), 0, 0, 280);
		addGraphic(Image.createRect(9999, 1, 0, 1), 0, 0, 320);
		addGraphic(Image.createRect(1, 9999, 0, 1), 0, 400, 0);
		addGraphic(Image.createRect(1, 9999, 0, 1), 0, 440, 0);
		
		addGraphic(DrawText.CreateTextEntity("Level Editor", GameFont.Imperial, 16, 20, 20, 0xFFFFFF, false));

		coordsText = new DrawText("Pos: 0, 0", GameFont.Imperial, 16, 20, 40, 0xFFFFFF, false);
		addGraphic(coordsText.label);
		
		typeText = new DrawText("Type: 0, Ландшафт", GameFont.Imperial, 16, 20, 60, 0xFFFFFF, false);
		addGraphic(typeText.label);
		
		elementText = new DrawText("Tile: 0, Воздух", GameFont.Imperial, 16, 20, 80, 0xFFFFFF, false);
		addGraphic(elementText.label);	
		
		currentPos = new Point(0, 0);
		currentElement = 0;
		currentType = 0;
		
		//20x15 (wxh) - размер поля, 40x40px - tile
		//10,7 - center
		
		var t1:MessageBox = new MessageBox(200, 200, "Caption", "SampleText");
		//add(t1.text.overlay);
		add(t1);
		
		var lvl:Level = Level.LoadLevel( "levels/map1.xml" );
		lvl.SaveLevel( "levels/map2.xml" );
		addList( lvl.getEntities() );
		//removeList( lvl.getEntities() );
		//addGraphic(DrawText.CreateTextEntity(Std.string(lvl.items[2].itemPoint.x), GameFont.Imperial, 16, 200, 200, 0xFFFFFF, false));
		
		
		super.begin();
	}
	
	public function updateText()
	{
		coordsText.ChangeStr("Pos: " + Std.string(currentPos.x) + ", " + Std.string(currentPos.y), false);
		//coordsText.ChangeStr("Pos: " + Std.string(HXP.halfHeight) + ", " + Std.string(HXP.halfWidth), false);
		
		if (currentType > 4)
			currentType = 0;
		if (currentType < 0)
			currentType = 4;
		
		if (currentElement > 4)
			currentElement = 0;
		if (currentElement < 0)
			currentElement = 4;
		
		var temp:String = "";
		switch(currentElement)
		{
			case 0:
				temp = "Воздух";
			case 1:
				temp = "Земля";
			case 2:
				temp = "Трава";
			case 3:
				temp = "Камень";
			case 4:
				temp = "Кирпич";
		}
		elementText.ChangeStr("Tile: " + currentElement + ", " + temp, false);
		
		switch(currentType)
		{
			case 0:
				temp = "Ландшафт";
			case 1:
				temp = "Предмет";
			case 2:
				temp = "Торговец";
			case 3:
				temp = "Говорун";
			case 4:
				temp = "Босс";
		}
		typeText.ChangeStr("Type: " + currentType + ", " + temp, false);
	}
	
	public override function update()
	{
		if (Input.pressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		if (Input.pressed("up"))
		{
			currentPos.y--;
		}
		if (Input.pressed("down"))
		{
			currentPos.y++;
		}
		if (Input.pressed("left"))
		{
			currentPos.x--;
		}
		if (Input.pressed("right"))
		{
			currentPos.x++;
		}
		if (Input.pressed("action"))
		{
			
		}
		if (Input.pressed(Key.HOME))
		{
			currentType++;
		}
		if (Input.pressed(Key.END))
		{
			currentType--;
		}
		if (Input.pressed(Key.PAGE_UP))
		{
			currentElement++;
		}
		if (Input.pressed(Key.PAGE_DOWN))
		{
			currentElement--;
		}
		
		updateText();
		super.update();
	}
	
}