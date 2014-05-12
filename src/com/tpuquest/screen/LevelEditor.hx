package com.tpuquest.screen;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Tilemap;
import com.haxepunk.utils.Draw;
import com.tpuquest.entity.character.Boss;
import com.tpuquest.entity.character.Character;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.Player;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.*;
import com.haxepunk.HXP;
import com.tpuquest.entity.character.Talker;
import com.tpuquest.entity.character.Trader;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.Spawn;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Item;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.utils.Level;
import com.tpuquest.entity.Sticker;
import com.tpuquest.entity.Tile;
import flash.display.Sprite;
import flash.geom.Point;
import com.haxepunk.utils.Key;
import flash.geom.Rectangle;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;

import haxe.io.Eof;
import sys.FileSystem;
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
	private var background:Image;
	
	public static var itemsList:Array<Dynamic>;
	public static var charactersList:Array<Dynamic>;
	public static var tilesList:Array<Dynamic>;
	public static var stickersList:Array<Dynamic>;
	public static var helpersList:Array<Dynamic>;
	
	private static var elementMax:Int;
	private static var currentTile:Tile;
	private static var currentItem:Item;
	private static var currentCharacter:Character;
	private static var currentSticker:Sticker;
	private static var currentHelper:Helper;
	
	private var iB:InputBox;
	private var waitingForAnswer:Bool;
	private var typeOfAnswer:Int;
	
	private var itsTestDude:Bool;
	private var coinsText:DrawText;
	private var hpText:DrawText;
	private var player:Player;
	private var coinImg:Image;
	private var heartImg:Image;
	
	public function new() 
	{
		super();
	}
	
	public override function begin()
	{
		super.begin();

		LoadElementLists();
		
		lvl = new Level();
		addList( lvl.getEntities() );
		
		background = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        background.color = lvl.bgcolor;
        background.scrollX = background.scrollY = 0;
        addGraphic(background).layer = 100; 
		
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

		addGraphic(cursor, 0, 0, 0);
		cursor.x = 360;
		cursor.y = 280;
		
		var helpFrame:Image = Image.createRect(HXP.width - 50, 25, 0x424242, 0.5);
		helpFrame.scrollX = helpFrame.scrollY = 0;
		addGraphic(helpFrame, -9, 25, HXP.height - 25);
		
		var helpText:DrawText = new DrawText("F1 - New, F2 - Load, F3 - Save, F4 - Change bg color, F5 - Test", GameFont.Imperial, 16, HXP.halfWidth, HXP.height - 13, 0xFFFFFF, true);
		helpText.label.scrollX = helpText.label.scrollY = 0;
		addGraphic(helpText.label, -10);
		
		waitingForAnswer = false;
		typeOfAnswer = -1;
		itsTestDude = false;
		
		coinsText = new DrawText("000", GameFont.PixelCyr, 20, 700, 50, 0xFFFFFF, false);
		coinsText.label.scrollX = coinsText.label.scrollY = 0;
		addGraphic(coinsText.label, -5);
		coinsText.label.visible = false;
		
		hpText = new DrawText("100", GameFont.PixelCyr, 20, 700, 20, 0xFFFFFF, false);
		hpText.label.scrollX = hpText.label.scrollY = 0;
		addGraphic(hpText.label, -5);
		hpText.label.visible = false;
		
		coinImg = new Image("graphics/items/coin.png");
		coinImg.scrollX = coinImg.scrollY = 0;
		
		heartImg = new Image("graphics/items/heart.png");
		heartImg.scrollX = heartImg.scrollY = 0;
		
		addGraphic(coinImg, -5, 670, 53);
		addGraphic(heartImg, -5, 670, 23);
		
		coinImg.visible = false;
		heartImg.visible = false;
	}
	
	public function updateText()
	{
		coordsText.ChangeStr("Pos: " + Std.string(currentPos.x) + ", " + Std.string(currentPos.y), false);
		
		if (isCursorChanged)
		{
			isCursorChanged = false;
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
		}
	}
	
	private function UpdateTools()
	{
		if (currentType > 4)
			currentType = 0;
		if (currentType < 0)
			currentType = 4;
		
		if (currentElement > elementMax)
			currentElement = 0;
		if (currentElement < 0)
			currentElement = elementMax;
		
		var temp1:String = "";
		var temp2:String = "";
		currentTile.visible = false;
		currentItem.visible = false;
		currentCharacter.visible = false;
		currentSticker.visible = false;
		currentHelper.visible = false;
		switch(currentType)
		{
			case 0:
			{
				temp1 = "Landscape";
				elementMax = 0;
				if (tilesList.length != 0)
				{
					elementMax = tilesList.length - 1;
					currentTile = tilesList[currentElement];
					temp2 = tilesList[currentElement].tileName;

					currentTile.x = 300 + HXP.camera.x;
					currentTile.y = 60 + HXP.camera.y;
					currentTile.visible = true;
					currentTile.layer = 0;
					add(currentTile);
				}
			}
			case 1:
			{
				temp1 = "Item";
				elementMax = 0;
				if (itemsList.length != 0)
				{
					elementMax = itemsList.length - 1;
					currentItem = itemsList[currentElement];
					temp2 = itemsList[currentElement].itemName;
					
					currentItem.x = 300 + HXP.camera.x;
					currentItem.y = 60 + HXP.camera.y;
					currentItem.visible = true;
					currentItem.layer = 0;
					add(currentItem);
				}
			}
			case 2:
			{
				temp1 = "Character";
				elementMax = 0;
				if (charactersList.length != 0)
				{
					elementMax = charactersList.length - 1;
					currentCharacter = charactersList[currentElement];
					temp2 = charactersList[currentElement].characterName;
					
					currentCharacter.x = 300 + HXP.camera.x;
					currentCharacter.y = 60 + HXP.camera.y;
					currentCharacter.visible = true;
					currentCharacter.layer = 0;
					currentCharacter.behaviorOn = false;
					add(currentCharacter);
				}
			}
			case 3:
			{
				temp1 = "Sticker";
				elementMax = 0;
				if (stickersList.length != 0)
				{
					elementMax = stickersList.length - 1;
					currentSticker = stickersList[currentElement];
					temp2 = stickersList[currentElement].tileName;

					currentSticker.x = 300 + HXP.camera.x;
					currentSticker.y = 60 + HXP.camera.y;
					currentSticker.visible = true;
					currentSticker.layer = -1;
					add(currentSticker);
				}
			}
			case 4:
			{
				temp1 = "Helper";
				elementMax = 0;
				if (helpersList.length != 0)
				{
					elementMax = helpersList.length - 1;
					currentHelper = helpersList[currentElement];
					temp2 = helpersList[currentElement].helperName;
					
					currentHelper.x = 300 + HXP.camera.x;
					currentHelper.y = 60 + HXP.camera.y;
					currentHelper.visible = true;
					currentHelper.layer = -2;
					add(currentHelper);
				}
			}
		}
		typeText.ChangeStr("Type: " + currentType + ", " + temp1, false);
		elementText.ChangeStr("Tile: " + currentElement + ", " + temp2, false);
	}
	
	public override function update()
	{
		if (itsTestDude)
		{
			if ((Input.pressed("esc") || Screen.joyPressed("BACK")) && !Screen.overrideControlByBox)
			{
				itsTestDude = false;
				
				removeList( lvl.getEntities() );
				HXP.camera.x = 0;
				HXP.camera.y = 0;
				isCursorChanged = true;
				cursorPos = new PointXY(0, 0);
				currentPos = new PointXY(0, 0);
				lvl = Level.LoadLevel("levels/testLevel.xml", false);
				addList( lvl.getEntities() );
				
				coinImg.visible = false;
				heartImg.visible = false;
				coinsText.label.visible = false;
				hpText.label.visible = false;
				cursor.visible = true;
			}
			
			var t:String = Std.string(player.money);
			for ( j  in 0...-t.length + 3)
			{
				t = "0" + t;
			}
			coinsText.ChangeStr(t, false);
			
			t = Std.string(player.life);
			for ( j  in 0...-t.length + 3)
			{
				t = "0" + t;
			}
			hpText.ChangeStr(t, false);
		}
		else
		{
			if (!Screen.overrideControlByBox && waitingForAnswer)
			{
				switch(typeOfAnswer)
				{
					case 0:	//SaveLevel
						if (iB.getInput() != "")
						{
							lvl.levelName = iB.getInput();
							lvl.SaveLevel( "levels/" + iB.getInput() + ".xml" );
						}
					case 1:	//LoadLevel
						if (iB.getInput() != "")
						{
							removeList( lvl.getEntities() );
							lvl = Level.LoadLevel( "levels/" + iB.getInput() + ".xml", false );
							addList( lvl.getEntities() );
							background.color = lvl.bgcolor;
						}
					case 2: //Color
						if (iB.getInput() != "")
						{
							lvl.bgcolor = Std.parseInt(iB.getInput());
							background.color = lvl.bgcolor;
						}
				}
				waitingForAnswer = false;
				typeOfAnswer = -1;
			}
			
			if ((Input.pressed("esc") || Screen.joyPressed("BACK")) && !Screen.overrideControlByBox)
			{
				MainMenu.menuMusic.play(SettingsMenu.musicVolume / 10, 0, true);
				HXP.scene = new MainMenu();
			}
			if (Input.pressed(Key.F1) && !Screen.overrideControlByBox)
			{
				iB = new InputBox(HXP.halfWidth, HXP.halfHeight, "Загрузка карты", "Список карт:\n------------\n");
				add(iB);
				waitingForAnswer = true;
				typeOfAnswer = 1;
			}
			if (Input.pressed(Key.F2) && !Screen.overrideControlByBox)
			{
				var t:String = "";
				for (x in FileSystem.readDirectory("levels/"))
				{
					t += x.split(".")[0] + "\n";
				}
				iB = new InputBox(HXP.halfWidth, HXP.halfHeight, "Загрузка карты", "Список карт:\n------------\n" + t);
				add(iB);
				waitingForAnswer = true;
				typeOfAnswer = 1;
			}
			if (Input.pressed(Key.F3) && !Screen.overrideControlByBox)
			{
				iB = new InputBox(HXP.halfWidth, HXP.halfHeight, "Сохранение карты", "Введите назвиние вашей карты для сохранения:");
				add(iB);
				waitingForAnswer = true;
				typeOfAnswer = 0;
			}
			if (Input.pressed(Key.F4) && !Screen.overrideControlByBox)
			{
				iB = new InputBox(HXP.halfWidth, HXP.halfHeight, "Фоновый цвет", "Введите цвет фоновой заливки карты (DEC or HEX):");
				add(iB);
				waitingForAnswer = true;
				typeOfAnswer = 2;
			}
			if (Input.pressed(Key.F5) && !Screen.overrideControlByBox)
			{
				lvl.SaveLevel( "levels/testLevel.xml" );
				removeList( lvl.getEntities() );
				lvl = Level.LoadLevel("levels/testLevel.xml", true);
				addList( lvl.getEntities() );
				itsTestDude = true;
				
				for (x in lvl.characters)
				{
					if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.character.Player")
						player = x;
				}
				
				coinImg.visible = true;
				heartImg.visible = true;
				coinsText.label.visible = true;
				hpText.label.visible = true;
				cursor.visible = false;
			}
			if ((Input.pressed("up") || Screen.joyCheck("DPAD_UP")) && !Screen.overrideControlByBox)
			{
				cursorPos.y--;
				currentPos.y--;
				isCursorChanged = true;
			}
			if ((Input.pressed("down") || Screen.joyCheck("DPAD_DOWN")) && !Screen.overrideControlByBox)
			{
				cursorPos.y++;
				currentPos.y++;
				isCursorChanged = true;
			}
			if ((Input.pressed("left") || Screen.joyCheck("DPAD_LEFT")) && !Screen.overrideControlByBox)
			{
				cursorPos.x--;
				currentPos.x--;
				isCursorChanged = true;
			}
			if ((Input.pressed("right") || Screen.joyCheck("DPAD_RIGHT")) && !Screen.overrideControlByBox)
			{
				cursorPos.x++;
				currentPos.x++;
				isCursorChanged = true;
			}
			if ((Input.pressed("action") || Screen.joyPressed("A")) && !Screen.overrideControlByBox)
			{
				ActionButton();
			}
			if ((Input.pressed(Key.DELETE) || Screen.joyPressed("B")) && !Screen.overrideControlByBox)
			{
				DeleteButton();
			}
			if ((Input.pressed(Key.HOME) || Screen.joyPressed("X")) && !Screen.overrideControlByBox)
			{
				currentType++;
				currentElement = 0;
				UpdateTools();
			}
			if ((Input.pressed(Key.END) || Screen.joyPressed("Y")) && !Screen.overrideControlByBox)
			{
				currentType--;
				currentElement = 0;
				UpdateTools();
			}
			if ((Input.pressed(Key.PAGE_UP) || Screen.joyPressed("RB")) && !Screen.overrideControlByBox)
			{
				currentElement++;
				UpdateTools();
			}
			if ((Input.pressed(Key.PAGE_DOWN) || Screen.joyPressed("LB")) && !Screen.overrideControlByBox)
			{
				currentElement--;
				UpdateTools();
			}
			
			updateText();
		}

		cursor.x = (cursorPos.x + 9) * 40 + HXP.camera.x;
		cursor.y = (cursorPos.y + 7) * 40 + HXP.camera.y;
		currentTile.x = 300 + HXP.camera.x;
		currentTile.y = 60 + HXP.camera.y;
		currentItem.x = 300 + HXP.camera.x;
		currentItem.y = 60 + HXP.camera.y;
		currentCharacter.x = 300 + HXP.camera.x;
		currentCharacter.y = 60 + HXP.camera.y;
		currentSticker.x = 300 + HXP.camera.x;
		currentSticker.y = 60 + HXP.camera.y;
		currentHelper.x = 300 + HXP.camera.x;
		currentHelper.y = 60 + HXP.camera.y;
		
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
				var tX = (currentPos.x + 9) * 40 + 10;
				var tY = (currentPos.y + 7) * 40 + 10;
				for (x in lvl.items)
				{
					if (x.x == tX && x.y == tY)
					{
						lvl.items.remove(x);
						remove(x);
					}
				}
				var temp:Item = new Item(new PointXY(0, 0));
				switch(Type.getClassName(Type.getClass(currentItem)))
				{
					case "com.tpuquest.item.Coin":
						temp = new Coin(new PointXY(tX -10, tY - 10), cast(currentItem, Coin).coinAmount, cast(currentItem, Coin).imgPath, cast(currentItem, Coin).name);
					case "com.tpuquest.item.Potion":
						temp = new Potion(new PointXY(tX -10, tY - 10), cast(currentItem, Potion).potionAmount, cast(currentItem, Potion).imgPath, cast(currentItem, Potion).name);
					case "com.tpuquest.item.Weapon":
						temp = new Weapon(new PointXY(tX -10, tY - 10), cast(currentItem, Weapon).weaponDamage, cast(currentItem, Weapon).imgPath, cast(currentItem, Weapon).name);
				}
				lvl.items.push(temp);
				add(temp);
			}
			case 2:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.characters)
				{
					if (x.x == tX && x.y == tY)
					{
						lvl.characters.remove(x);
						remove(x);
					}
				}
				var temp:Character = new Character(new Point(0, 0), "");
				switch(Type.getClassName(Type.getClass(currentCharacter)))
				{
					case "com.tpuquest.character.Talker":
						temp = new Talker(new Point(tX, tY), currentCharacter.spritePath, currentCharacter.characterName);
					case "com.tpuquest.character.Trader":
						temp = new Trader(new Point(tX, tY), currentCharacter.spritePath, currentCharacter.characterName);
					case "com.tpuquest.character.Enemy":
						temp = new Enemy(new Point(tX, tY), currentCharacter.spritePath, cast(currentCharacter, Enemy).life, currentCharacter.characterName);
					case "com.tpuquest.character.Player":
						temp = new Player(new Point(tX, tY), currentCharacter.spritePath, cast(currentCharacter, Player).life, cast(currentCharacter, Player).money, currentCharacter.characterName);
					case "com.tpuquest.character.Boss":
						temp = new Boss(new Point(tX, tY), currentCharacter.spritePath, cast(currentCharacter, Boss).life, currentCharacter.characterName);
				}
				temp.behaviorOn = false;
				lvl.characters.push(temp);
				add(temp);
			}
			case 3:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.stickers)
				{
					if (x.tilePoint.x == tX && x.tilePoint.y == tY)
					{
						lvl.stickers.remove(x);
						remove(x);
					}
				}
				var temp:Sticker = new Sticker(new PointXY(tX, tY), stickersList[currentElement].behindCreatures, stickersList[currentElement].imgPath, stickersList[currentElement].tileName);
				lvl.stickers.push(temp);
				
				add(temp);
			}
			case 4:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.helpers)
				{
					if (x.helperPoint.x == tX && x.helperPoint.y == tY)
					{
						lvl.helpers.remove(x);
						remove(x);
					}
				}
				var temp:Helper = new Helper(new PointXY(0, 0), "", false);
				
				switch(Type.getClassName(Type.getClass(currentHelper)))
				{
					case "com.tpuquest.helper.ChangeMap":
						temp = new ChangeMap(new PointXY(tX, tY), cast(currentHelper, ChangeMap).nextMapPath, cast(currentHelper, ChangeMap).keepPlayer, cast(currentHelper, ChangeMap).instantly, currentHelper.helperName, true);
					case "com.tpuquest.helper.ShowMessage":
						temp = new ShowMessage(new PointXY(tX, tY), currentHelper.helperName, true);
					case "com.tpuquest.helper.Spawn":
						temp = new Spawn(new PointXY(tX, tY), currentHelper.helperName, true);
				}
				
				lvl.helpers.push(temp);
				
				add(temp);
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
				var tX = (currentPos.x + 9) * 40 + 10;
				var tY = (currentPos.y + 7) * 40 + 10;
				for (x in lvl.items)
				{
					if (x.x == tX && x.y == tY)
					{
						lvl.items.remove(x);
						remove(x);
					}
				}
			}
			case 2:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.characters)
				{
					if (x.x == tX && x.y == tY)
					{
						lvl.characters.remove(x);
						remove(x);
					}
				}
			}
			case 3:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.stickers)
				{
					if (x.tilePoint.x == tX && x.tilePoint.y == tY)
					{
						lvl.stickers.remove(x);
						remove(x);
					}
				}
			}
			case 4:
			{
				var tX = (currentPos.x + 9) * 40;
				var tY = (currentPos.y + 7) * 40;
				for (x in lvl.helpers)
				{
					if (x.helperPoint.x == tX && x.helperPoint.y == tY)
					{
						lvl.helpers.remove(x);
						remove(x);
					}
				}
			}
		}
	}	
	
	private static function LoadElementLists()
	{
		itemsList = new Array<Dynamic>();
		charactersList = new Array<Dynamic>();
		tilesList = new Array<Dynamic>();
		stickersList = new Array<Dynamic>();
		helpersList = new Array<Dynamic>();
		
		var xmlItems:Xml = Xml.parse(File.getContent("cfg/items.xml")).firstElement();
		for (x in xmlItems.elements())
		{
			switch(x.get("type"))
			{
				case "coin":
					itemsList.push(new Coin(new PointXY(0, 0), Std.parseInt(x.get("coinAmount")), x.get("path"), x.get("name")));
				case "potion":
					itemsList.push(new Potion(new PointXY(0, 0), Std.parseInt(x.get("potionAmount")), x.get("path"), x.get("name")));
				case "weapon":
					itemsList.push(new Weapon(new PointXY(0, 0), Std.parseInt(x.get("weaponDamage")), x.get("path"), x.get("name")));
			}
		}
		currentItem = itemsList[0];
		currentItem.visible = false;
		currentItem.layer = 0;

		var xmlCharacters:Xml = Xml.parse(File.getContent("cfg/characters.xml")).firstElement();
		for (x in xmlCharacters.elements())
		{
			switch(x.get("type"))
			{
				case "talker":
					charactersList.push(new Talker(new Point(0, 0), x.get("spritePath"), x.get("name"), false));
				case "trader":
					charactersList.push(new Trader(new Point(0, 0), x.get("spritePath"), x.get("name"), false));
				case "enemy":
					charactersList.push(new Enemy(new Point(0, 0), x.get("spritePath"), Std.parseInt(x.get("hp")), x.get("name"), false));
				case "player":
					charactersList.push(new Player(new Point(0, 0), x.get("spritePath"), Std.parseInt(x.get("hp")), Std.parseInt(x.get("money")), x.get("name"), false));
				case "boss":
					charactersList.push(new Boss(new Point(0, 0), x.get("spritePath"), Std.parseInt(x.get("hp")), x.get("name"), false));
			}
		}
		currentCharacter = charactersList[0];
		currentCharacter.visible = false;
		currentCharacter.layer = 0;
		currentCharacter.behaviorOn = false;

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
		currentTile.visible = true;
		currentTile.layer = 0;
		
		var xmlStickers:Xml = Xml.parse(File.getContent("cfg/stickers.xml")).firstElement();
		for (x in xmlStickers.elements())
		{
			var tC = x.get("behindCreatures");
			var tCb:Bool = false;
			if (tC == "1")
				tCb = true;
				
			stickersList.push(new Sticker(new PointXY(0, 0), tCb, x.get("path"), x.get("name")));
		}
		currentSticker = stickersList[0];
		currentSticker.visible = false;
		//currentSticker.layer = 0;
		
		var xmlHelpers:Xml = Xml.parse(File.getContent("cfg/helpers.xml")).firstElement();
		for (x in xmlHelpers.elements())
		{
			switch(x.get("type"))
			{
				case "message":
					helpersList.push(new ShowMessage(new PointXY(0, 0), x.get("name"), true));
				case "nextlevel":
					var tCP = Std.parseInt(x.get("currentPlayer"));
					var tCP_b = false;
					if (tCP == 1)
						tCP_b = true;
					var tI = Std.parseInt(x.get("instantly"));
					var tI_b = false;
					if (tI == 1)
						tI_b = true;
					helpersList.push(new ChangeMap(new PointXY(0, 0), x.get("mapPath"), tCP_b, tI_b, x.get("name"), true));
				case "spawn":
					helpersList.push(new Spawn(new PointXY(0, 0), x.get("name"), true));
			}
		}
		currentHelper = helpersList[0];
		currentHelper.visible = false;
		currentHelper.layer = 0;
		
		elementMax = tilesList.length - 1;
	}
}