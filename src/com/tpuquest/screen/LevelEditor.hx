package com.tpuquest.screen;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Image;

import com.tpuquest.entity.character.Boss;
import com.tpuquest.entity.character.Character;
import com.tpuquest.entity.character.Enemy;
import com.tpuquest.entity.character.Player;
import com.tpuquest.entity.character.Talker;
import com.tpuquest.entity.character.Trader;
import com.tpuquest.entity.helper.ChangeMap;
import com.tpuquest.entity.helper.Helper;
import com.tpuquest.entity.helper.KillTheHuman;
import com.tpuquest.entity.helper.ShowMessage;
import com.tpuquest.entity.helper.Spawn;
import com.tpuquest.entity.helper.Teleporter;
import com.tpuquest.entity.helper.WinGame;
import com.tpuquest.entity.item.Coin;
import com.tpuquest.entity.item.Item;
import com.tpuquest.entity.item.Potion;
import com.tpuquest.entity.item.Weapon;
import com.tpuquest.utils.DrawText;
import com.tpuquest.utils.PointXY;
import com.tpuquest.utils.TileGridLevel;
import com.tpuquest.dialog.InputBox;
import com.tpuquest.dialog.MessageBox;

import flash.geom.Point;

#if windows
import sys.FileSystem;
#end

import openfl.Assets;

class LevelEditor extends Screen
{
	private var captionText:DrawText;
	private var coordsText:DrawText;
	private var elementText:DrawText;
	private var typeText:DrawText;
	private var extraText:DrawText;
	
	private var cursorPos:PointXY;
	private var currentPos:PointXY;
	private var currentType:Int;
	private var currentElement:Int;
	private var currentExtra:Bool;
	
	private var cursor:Image;
	private var settingsFrame:Image;
	
	private var isCursorChanged:Bool;
	
	private var lvl:TileGridLevel;
	private var background:Image;
	
	public static var itemsList:Array<Dynamic>;
	public static var charactersList:Array<Dynamic>;
	public static var helpersList:Array<Dynamic>;
	
	private static var elementMax:Int;
	private static var currentTile:Entity;
	private static var currentItem:Item;
	private static var currentCharacter:Character;
	private static var currentSticker:Entity;
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
	private var weaponImg:Image;
	
	public function new() 
	{
		super();
	}
#if windows
	public override function begin()
	{
		super.begin();

		LoadElementLists();

		lvl = new TileGridLevel("Untitled", 100, 100);
		addList( lvl.getEntities() );

		background = Image.createRect(HXP.width, HXP.height, 0xFFFFFF, 1);
        background.color = lvl.bgcolor;
        background.scrollX = background.scrollY = 0;
        addGraphic(background).layer = 100; 
		
		settingsFrame = Image.createRect(330, 105, 0x424242, 0.5);
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
		
		extraText = new DrawText("Collidability: True", GameFont.Imperial, 16, 20, 100, 0xFFFFFF, false);
		extraText.label.scrollX = extraText.label.scrollY = 0;
		addGraphic(extraText.label);	
		
		currentPos = new PointXY(0, 0);
		cursorPos = new PointXY(0, 0);
		currentElement = 0;
		currentType = 0;
		currentExtra = false;
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
		
		weaponImg = new Image("graphics/items/sword.png");
		weaponImg.scrollX = weaponImg.scrollY = 0;
		weaponImg.visible = false;
		
		addGraphic(coinImg, -5, 670, 53);
		addGraphic(heartImg, -5, 670, 23);
		addGraphic(weaponImg, -5, 600, 40);
		
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
		var temp3:String = "";
		
		currentTile.visible = false;
		currentItem.visible = false;
		currentCharacter.visible = false;
		currentSticker.visible = false;
		currentHelper.visible = false;
		
		remove(currentItem);
		remove(currentCharacter);
		remove(currentHelper);
		
		switch(currentType)
		{
			case 0:
			{
				temp1 = "Landscape";
				temp3 = "Collidability: " + Std.string(currentExtra);
				elementMax = lvl.tilesMap.tileMap.tileCount - 1;
				temp2 = "tileset.png";
				
				cast(currentTile.graphic, Spritemap).frame = currentElement;
				
				currentTile.x = 300 + HXP.camera.x;
				currentTile.y = 60 + HXP.camera.y;
				currentTile.visible = true;
				currentTile.layer = -1;
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
					currentItem.layer = -1;
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
					currentCharacter.layer = -1;
					currentCharacter.behaviorOn = false;
					add(currentCharacter);
				}
			}
			case 3:
			{
				temp1 = "Sticker";
				temp3 = "Behind creatures: " + Std.string(currentExtra);
				elementMax = lvl.stickersMap.tileMap.tileCount - 1;
				temp2 = "stickerset.png";

				cast(currentSticker.graphic, Spritemap).frame = currentElement;

				currentSticker.x = 300 + HXP.camera.x;
				currentSticker.y = 60 + HXP.camera.y;
				currentSticker.visible = true;
				currentSticker.layer = -1;
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
		extraText.ChangeStr(temp3, false);
	}
	
	public override function update()
	{
		if (itsTestDude)
		{	
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
			
			if (player.weaponized)
				weaponImg.visible = true;
			else
				weaponImg.visible = false;
				
			if ((Input.pressed("esc") || Screen.joyPressed("BACK")) && !Screen.overrideControlByBox)
			{
				itsTestDude = false;
				
				removeList( lvl.getEntities() );
				player.behaviorOn = false;
				HXP.camera.x = 0;
				HXP.camera.y = 0;
				HXP.screen.x = 0;
				HXP.screen.y = 0;
				cursor.x = 360;
				cursor.y = 280;
				
				cursorPos = new PointXY(0, 0);
				currentPos = new PointXY(0, 0);
				lvl = TileGridLevel.LoadLevel("levels/testLevel.xml", false);
				addList( lvl.getEntities() );
				
				currentElement = 0;
				currentType = 0;
				currentExtra = false;
				isCursorChanged = false;
		
				coinImg.visible = false;
				heartImg.visible = false;
				weaponImg.visible = false;
				coinsText.label.visible = false;
				hpText.label.visible = false;
				cursor.visible = true;
			
				add(currentCharacter);
				add(currentHelper);
				add(currentItem);
				add(currentSticker);
				add(currentTile);
			}
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
							lvl = TileGridLevel.LoadLevel( "levels/" + iB.getInput() + ".xml", false, false );
							addList( lvl.getEntities() );
							background.color = lvl.bgcolor;
							
							var plPos:PointXY = new PointXY(0, 0);
							
							for (x in lvl.characters)
							{
								if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.Player")
								{
									plPos.x = Std.int(x.x / 40 - 9);
									plPos.y = Std.int(x.y / 40 - 7);
								}
							}
							
							HXP.camera.x = plPos.x * 40;
							HXP.camera.y = plPos.y * 40;
							cursorPos = new PointXY(0, 0);
							currentPos = plPos;
							
							isCursorChanged = true;
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
				removeList( lvl.getEntities() );
				lvl = new TileGridLevel();
				addList( lvl.getEntities() );
				background.color = lvl.bgcolor;
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
				lvl = TileGridLevel.LoadLevel("levels/testLevel.xml", false, true);
				addList( lvl.getEntities() );
				itsTestDude = true;
				
				for (x in lvl.characters)
				{
					if (Type.getClassName(Type.getClass(x)) == "com.tpuquest.entity.character.Player")
						player = x;
				}
				
				currentCharacter.visible = false;
				currentHelper.visible = false;
				currentItem.visible = false;
				currentSticker.visible = false;
				currentTile.visible = false;
				
				coinImg.visible = true;
				heartImg.visible = true;
				coinsText.label.visible = true;
				hpText.label.visible = true;
				cursor.visible = false;
				
				remove(currentCharacter);
				remove(currentHelper);
				remove(currentItem);
				remove(currentSticker);
				remove(currentTile);
			}
			if ((Input.pressed("up") || Screen.joyCheck("DPAD_UP")) && !Screen.overrideControlByBox && currentPos.y > 0)
			{
					cursorPos.y--;
					currentPos.y--;
					isCursorChanged = true;
			}
			if ((Input.pressed("down") || Screen.joyCheck("DPAD_DOWN")) && !Screen.overrideControlByBox && currentPos.y < lvl.tilesMap.tileMap.rows - 1)
			{
				cursorPos.y++;
				currentPos.y++;
				isCursorChanged = true;
			}
			if ((Input.pressed("left") || Screen.joyCheck("DPAD_LEFT")) && !Screen.overrideControlByBox && currentPos.x > 0)
			{
				cursorPos.x--;
				currentPos.x--;
				isCursorChanged = true;
			}
			if ((Input.pressed("right") || Screen.joyCheck("DPAD_RIGHT")) && !Screen.overrideControlByBox && currentPos.y < lvl.tilesMap.tileMap.columns - 1)
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
			
			if ((Input.pressed(Key.INSERT) || Screen.joyPressed("RS_BUTTON")) && !Screen.overrideControlByBox)
			{
				currentExtra = !currentExtra;
				var temp3:String = "";
				switch(currentType)
				{
					case 0: 
						temp3 = "Collidability: " + Std.string(currentExtra);
					case 3:
						temp3 = "Behind creatures: " + Std.string(currentExtra);
				}
				extraText.ChangeStr(temp3, false);
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
				lvl.tilesMap.addTile(currentPos.x, currentPos.y, currentElement, currentExtra);
				lvl.tiles.push( { x : currentPos.x, y : currentPos.y, id : currentElement, solid : currentExtra } );
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
					case "com.tpuquest.entity.item.Coin":
						temp = new Coin(new PointXY(tX -10, tY - 10), cast(currentItem, Coin).coinAmount, cast(currentItem, Coin).imgPath, cast(currentItem, Coin).name);
					case "com.tpuquest.entity.item.Potion":
						temp = new Potion(new PointXY(tX -10, tY - 10), cast(currentItem, Potion).potionAmount, cast(currentItem, Potion).imgPath, cast(currentItem, Potion).name);
					case "com.tpuquest.entity.item.Weapon":
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
					case "com.tpuquest.entity.character.Talker":
						temp = new Talker(new Point(tX, tY), currentCharacter.spritePath, currentCharacter.characterName);
					case "com.tpuquest.entity.character.Trader":
						temp = new Trader(new Point(tX, tY), currentCharacter.spritePath, currentCharacter.characterName);
					case "com.tpuquest.entity.character.Enemy":
						temp = new Enemy(new Point(tX, tY), currentCharacter.spritePath, cast(currentCharacter, Enemy).life, cast(currentCharacter, Enemy).enemyType,  currentCharacter.characterName);
					case "com.tpuquest.entity.character.Player":
						temp = new Player(new Point(tX, tY), currentCharacter.spritePath, cast(currentCharacter, Player).life, cast(currentCharacter, Player).money, cast(currentCharacter, Player).weaponDamage, currentCharacter.characterName);
					case "com.tpuquest.entity.character.Boss":
						temp = new Boss(new Point(tX, tY), currentCharacter.spritePath, cast(currentCharacter, Boss).life, currentCharacter.characterName);
				}
				temp.behaviorOn = false;
				lvl.characters.push(temp);
				add(temp);
			}
			case 3:
			{
				if (currentExtra)				
					lvl.stickersMapBehind.addTile(currentPos.x, currentPos.y, currentElement, false);
				else
					lvl.stickersMap.addTile(currentPos.x, currentPos.y, currentElement, false);
					
				lvl.stickers.push( { x : currentPos.x, y : currentPos.y, id : currentElement, solid : currentExtra } );
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
					case "com.tpuquest.entity.helper.ChangeMap":
						temp = new ChangeMap(new PointXY(tX, tY), cast(currentHelper, ChangeMap).nextMapPath, cast(currentHelper, ChangeMap).keepPlayer, cast(currentHelper, ChangeMap).instantly, cast(currentHelper, ChangeMap).removeAfterUsing, currentHelper.helperName, true);
					case "com.tpuquest.entity.helper.ShowMessage":
						temp = new ShowMessage(new PointXY(tX, tY), currentHelper.helperName, true);
					case "com.tpuquest.entity.helper.Spawn":
						temp = new Spawn(new PointXY(tX, tY), currentHelper.helperName, true);
					case "com.tpuquest.entity.helper.WinGame":
						temp = new WinGame(new PointXY(tX, tY), currentHelper.helperName, true);
					case "com.tpuquest.entity.helper.Teleporter":
						temp = new Teleporter(new PointXY(tX, tY), cast(currentHelper, Teleporter).pointTo, currentHelper.helperName, true);
					case "com.tpuquest.entity.helper.KillTheHuman":
						temp = new KillTheHuman(new PointXY(tX, tY), currentHelper.helperName, true);
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
				lvl.tilesMap.addTile(currentPos.x, currentPos.y, -1, false);
				lvl.tiles.remove( { x : currentPos.x, y : currentPos.y, id : lvl.tilesMap.getTile(currentPos.x, currentPos.y), solid : lvl.tilesMap.collideGrid.getTile(currentPos.x, currentPos.y) } );
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
				lvl.stickersMap.addTile(currentPos.x, currentPos.y, -1, false);
				lvl.stickersMapBehind.addTile(currentPos.x, currentPos.y, -1, false);
				
				lvl.stickers.remove( { x : currentPos.x, y : currentPos.y, id : lvl.stickersMap.getTile(currentPos.x, currentPos.y), solid : false } );
				lvl.stickers.remove( { x : currentPos.x, y : currentPos.y, id : lvl.stickersMapBehind.getTile(currentPos.x, currentPos.y), solid : true } );
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
	
	private function LoadElementLists()
	{
		itemsList = new Array<Dynamic>();
		charactersList = new Array<Dynamic>();
		helpersList = new Array<Dynamic>();
		
		var xmlItems:Xml = Xml.parse(Assets.getText("cfg/items.xml")).firstElement();
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
		currentItem.layer = -1;

		var xmlCharacters:Xml = Xml.parse(Assets.getText("cfg/characters.xml")).firstElement();
		for (x in xmlCharacters.elements())
		{
			switch(x.get("type"))
			{
				case "talker":
					charactersList.push(new Talker(new Point(0, 0), x.get("spritePath"), x.get("name"), false));
				case "trader":
					charactersList.push(new Trader(new Point(0, 0), x.get("spritePath"), x.get("name"), false));
				case "enemy":
					charactersList.push(new Enemy(new Point(0, 0), x.get("spritePath"), Std.parseInt(x.get("hp")), Std.parseInt(x.get("enemyType")), x.get("name"), false));
				case "player":
					charactersList.push(new Player(new Point(0, 0), x.get("spritePath"), Std.parseInt(x.get("hp")), Std.parseInt(x.get("money")), Std.parseInt(x.get("weaponDamage")), x.get("name"), false));
				case "boss":
					charactersList.push(new Boss(new Point(0, 0), x.get("spritePath"), Std.parseInt(x.get("hp")), x.get("name"), false));
			}
		}
		currentCharacter = charactersList[0];
		currentCharacter.visible = false;
		currentCharacter.layer = -1;
		currentCharacter.behaviorOn = false;

		var sprite1:Spritemap = new Spritemap("graphics/tileset.png", 40, 40);
		currentTile = new Entity(0, 0, sprite1);
		sprite1.frame = 0;
		currentTile.visible = true;
		currentTile.layer = -1;
		add(currentTile);
		
		var sprite2:Spritemap = new Spritemap("graphics/stickerset.png", 40, 40);
		currentSticker = new Entity(0, 0, sprite2);
		sprite2.frame = 0;
		currentSticker.visible = false;
		currentSticker.layer = -1;
		add(currentSticker);

		var xmlHelpers:Xml = Xml.parse(Assets.getText("cfg/helpers.xml")).firstElement();
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
					helpersList.push(new ChangeMap(new PointXY(0, 0), x.get("mapPath"), tCP_b, tI_b, x.get("removeAfterUsing") == "1", x.get("name"), true));
				case "spawn":
					helpersList.push(new Spawn(new PointXY(0, 0), x.get("name"), true));
				case "teleporter":
					helpersList.push(new Teleporter(new PointXY(0, 0), new PointXY(Std.parseInt(x.get("xTo")), Std.parseInt(x.get("yTo"))), x.get("name"), true));
				case "killer":
					helpersList.push(new KillTheHuman(new PointXY(0, 0), x.get("name"), true));
			}
		}
		currentHelper = helpersList[0];
		currentHelper.visible = false;
		currentHelper.layer = -1;
		
		elementMax = 0;
	}
#end
}