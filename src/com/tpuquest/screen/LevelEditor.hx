package com.tpuquest.screen;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.utils.Draw;
import com.tpuquest.character.Player;
import com.haxepunk.utils.Input;
import com.haxepunk.HXP;
import com.tpuquest.item.Item;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.world.Level;
import com.tpuquest.world.Tile;
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

import com.tpuquest.dialog.InputBox;
import com.tpuquest.dialog.MessageBox;

class LevelEditor extends Screen
{
	private var captionText:DrawText;
	private var coordsText:DrawText;
	private var elementText:DrawText;
	private var typeText:DrawText;
	
	private var cursorPos:PointXY;
	private var currentPos:PointXY;
	private var currentType:Int;
	private var currentElement:Int;
	
	private var cursor:Image;
	private var settingsFrame:Image;
	
	private var isCursorChanged:Bool;
	
	private var lvl:Level;
	
	public static var itemsList:Array<Dynamic>;
	public static var charactersList:Array<Dynamic>;
	public static var tilesList:Array<Dynamic>;
	
	private static var elementMax:Int;
	private static var currentTile:Tile;
	
	private var waitingForAnswer:Bool;
	private var typeOfAnswer:Int;

	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		super.begin();

		LoadElementLists();
		
		lvl = Level.LoadLevel( "levels/new_old.xml" );
		//lvl.SaveLevel( "levels/map2.xml" );
		//lvl = new Level();
		addList( lvl.getEntities() );
		//removeList( lvl.getEntities() );
		
		var base = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        base.color = lvl.bgcolor;
        base.scrollX = base.scrollY = 0;
        addGraphic(base).layer = 100; 
		
		settingsFrame = Image.createRect(330, 85, 0x424242, 0.5);
		addGraphic(settingsFrame, 0, 0, 0);
		settingsFrame.x = 18;
		settingsFrame.y = 22;
		settingsFrame.scrollX = settingsFrame.scrollY = 0;
		
		cursor = Image.createRect(40, 40, 0xFFFFFF, 0.4);
		
		captionText = new DrawText("Level Editor", GameFont.Imperial, 16, 20, 20, 0xFFFFFF, false);
		captionText.label.scrollX = captionText.label.scrollY = 0;
		addGraphic(captionText.label);

		coordsText = new DrawText("Pos: 0, 0", GameFont.Imperial, 16, 20, 40, 0xFFFFFF, false);
		coordsText.label.scrollX = coordsText.label.scrollY = 0;
		addGraphic(coordsText.label);
		
		typeText = new DrawText("Type: 0, Landscape", GameFont.Imperial, 16, 20, 60, 0xFFFFFF, false);
		typeText.label.scrollX = typeText.label.scrollY = 0;
		addGraphic(typeText.label);
		
		elementText = new DrawText("Tile: 0, Grass", GameFont.Imperial, 16, 20, 80, 0xFFFFFF, false);
		elementText.label.scrollX = elementText.label.scrollY = 0;
		addGraphic(elementText.label);	
		
		currentPos = new PointXY(0, 0);
		cursorPos = new PointXY(0, 0);
		currentElement = 0;
		currentType = 0;
		isCursorChanged = false;

		//add(new MessageBox(HXP.halfWidth, HXP.halfHeight, "ЗаголовокЗаголовокЗаголовокЗаголовок", "Я помню как\n она стала моей. В теплый летний и без того радостный день, на голову свалилось еще большее счастье."));
		add(new InputBox(HXP.halfWidth, HXP.halfHeight, "InputBox", "Введите назвиние карты для загрузки:"));
		
		addGraphic(cursor, 0, 0, 0);
		cursor.x = 360;
		cursor.y = 280;
		
		waitingForAnswer = false;
		typeOfAnswer = -1;
	}
	
	public function updateText()
	{
		coordsText.ChangeStr("Pos: " + Std.string(currentPos.x) + ", " + Std.string(currentPos.y), false);
		
		if (isCursorChanged)
		{
			isCursorChanged = false;
			//x -9..10
			//y -7..7
			if (cursorPos.x < -8)
			{
				HXP.camera.x -= 40;
				cursorPos.x = -8;
			}
			if (cursorPos.x > 9)
			{
				HXP.camera.x += 40;
				cursorPos.x = 9;
			}
			if (cursorPos.y < -6)
			{
				HXP.camera.y -= 40;
				cursorPos.y = -6;
			}
			if (cursorPos.y > 6)
			{
				HXP.camera.y += 40;
				cursorPos.y = 6;
			}

			cursor.x = (cursorPos.x + 9) * 40 + HXP.camera.x;
			cursor.y = (cursorPos.y + 7) * 40 + HXP.camera.y;
			currentTile.x = 300 + HXP.camera.x;
			currentTile.y = 60 + HXP.camera.y;
		}
	}
	
	private function UpdateTools()
	{
		if (currentType > 3)
			currentType = 0;
		if (currentType < 0)
			currentType = 3;
		
		if (currentElement > elementMax)
			currentElement = 0;
		if (currentElement < 0)
			currentElement = elementMax;
		
		var temp1:String = "";
		var temp2:String = "";
		currentTile.visible = false;
		switch(currentType)
		{
			case 0:
			{
				temp1 = "Landscape";
				elementMax = tilesList.length - 1;
				currentTile = tilesList[currentElement];
				temp2 = tilesList[currentElement].tileName;

				currentTile = tilesList[currentElement];
				currentTile.x = 300 + HXP.camera.x;
				currentTile.y = 60 + HXP.camera.y;
				currentTile.visible = true;
				currentTile.layer = 0;
				add(currentTile);
			}
			case 1:
			{
				temp1 = "Item";
				elementMax = itemsList.length - 1;
				/*switch(currentElement)
				{
					case default:
						temp2 = "";
				}*/
			}
			case 2:
			{
				temp1 = "Character";
				elementMax = charactersList.length - 1;
				/*switch(currentElement)
				{
					case default:
						temp2 = "";
				}*/
			}
			case 3:
			{
				temp1 = "Sticker";
				elementMax = 0;
				/*switch(currentElement)
				{
					case default:
						temp2 = "";
				}*/
			}
			case 4:
			{
				temp1 = "Helper";
				elementMax = 0;
				/*switch(currentElement)
				{
					case default:
						temp2 = "";
				}*/
			}
		}
		typeText.ChangeStr("Type: " + currentType + ", " + temp1, false);
		elementText.ChangeStr("Tile: " + currentElement + ", " + temp2, false);
	}
	
	private var iB:InputBox;
	
	public override function update()
	{
		if (!Screen.overrideControlByBox && waitingForAnswer)
		{
			switch(typeOfAnswer)
			{
				case 0:	//SaveLevel
					if(iB.getInput() != "")
						lvl.SaveLevel( "levels/" + iB.getInput() + ".xml" );
			}
		}
		
		if (Input.pressed("esc") && !Screen.overrideControlByBox)
		{
			lvl.SaveLevel( "levels/new_old.xml" );
			MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
			HXP.scene = new MainMenu();
		}
		if (Input.pressed(Key.F2) && !Screen.overrideControlByBox)
		{
			iB = new InputBox(HXP.halfWidth, HXP.halfHeight, "Сохранение карты", "Введите назвиние вашей карты для сохранения:");
			add(iB);
			waitingForAnswer = true;
			typeOfAnswer = 0;
		}
		if (Input.pressed("up") && !Screen.overrideControlByBox)
		{
			cursorPos.y--;
			currentPos.y--;
			isCursorChanged = true;
		}
		if (Input.pressed("down") && !Screen.overrideControlByBox)
		{
			cursorPos.y++;
			currentPos.y++;
			isCursorChanged = true;
		}
		if (Input.pressed("left") && !Screen.overrideControlByBox)
		{
			cursorPos.x--;
			currentPos.x--;
			isCursorChanged = true;
		}
		if (Input.pressed("right") && !Screen.overrideControlByBox)
		{
			cursorPos.x++;
			currentPos.x++;
			isCursorChanged = true;
		}
		if (Input.pressed("action") && !Screen.overrideControlByBox)
		{
			ActionButton();
		}
		if (Input.pressed(Key.DELETE) && !Screen.overrideControlByBox)
		{
			DeleteButton();
		}
		if (Input.pressed(Key.HOME) && !Screen.overrideControlByBox)
		{
			currentType++;
			currentElement = 0;
			UpdateTools();
		}
		if (Input.pressed(Key.END) && !Screen.overrideControlByBox)
		{
			currentType--;
			currentElement = 0;
			UpdateTools();
		}
		if (Input.pressed(Key.PAGE_UP) && !Screen.overrideControlByBox)
		{
			currentElement++;
			UpdateTools();
		}
		if (Input.pressed(Key.PAGE_DOWN) && !Screen.overrideControlByBox)
		{
			currentElement--;
			UpdateTools();
		}
		
		updateText();
		super.update();
	}
	
	private function ActionButton()
	{
		switch(currentType)
		{
			case 0:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.tiles)
				{
					if (x.tilePoint.x == tX && x.tilePoint.y == tY)
					{
						lvl.tiles.remove(x);
						remove(x);
					}
				}
				var temp:Tile = new Tile(new PointXY(tX, tY), tilesList[currentElement].collidability, tilesList[currentElement].imgPath, tilesList[currentElement].soundPath, tilesList[currentElement].tileName);
				lvl.tiles.push(temp);
				
				add(temp);
			}
			case 1:
			{

			}
			case 2:
			{

			}
			case 3:
			{

			}
		}
	}
	
	private function DeleteButton()
	{
		switch(currentType)
		{
			case 0:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.tiles)
				{
					if (x.tilePoint.x == tX && x.tilePoint.y == tY)
					{
						lvl.tiles.remove(x);
						remove(x);
					}
				}
			}
			case 1:
			{

			}
			case 2:
			{

			}
			case 3:
			{

			}
		}
	}	
	
	private static function LoadElementLists()
	{
		itemsList = new Array<Dynamic>();
		charactersList = new Array<Dynamic>();
		tilesList = new Array<Dynamic>();
		
		/*var xmlItems:Xml = Xml.parse(File.getContent("cfg/tiles.xml")).firstElement();
		for (x in xmlItems.elements())
		{
			itemsList.push(new Item(
		}*/
		var xmlTiles:Xml = Xml.parse(File.getContent("cfg/tiles.xml")).firstElement();
		for (x in xmlTiles.elements())
		{
			var tC = x.get("collidability");
			var tCb:Bool = false;
			if (tC == "1")
				tCb = true;
			
				
			tilesList.push(new Tile(new PointXY(0, 0), tCb, x.get("path"), x.get("soundPath"), x.get("name")));
		}
		currentTile = tilesList[0];
		currentTile.visible = false;
		currentTile.layer = 0;
		elementMax = tilesList.length - 1;
	}
}