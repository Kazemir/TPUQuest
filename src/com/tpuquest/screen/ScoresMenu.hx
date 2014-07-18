package com.tpuquest.screen;
import com.haxepunk.utils.Data;
import com.tpuquest.screen.ScoresMenu.Record;
import com.tpuquest.utils.DrawText;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.tpuquest.utils.CLocals;

import haxe.xml.*;

#if !flash
import sys.FileSystem;
import sys.io.File;
#end

#if android
import openfl.utils.SystemPath;
#end

typedef Record = { name : String, score : Int };

class ScoresMenu extends Screen
{
	private var textPlayersElements:Array<DrawText>;
	private static var scoresList:Array<Record> = new Array<Record>();

	public function new() 
	{
		super();
	}

	public override function begin()
	{
		var img:Image = new Image("graphics/bg.jpg");
		img.scaleX = HXP.width / img.width;
		img.scaleY = HXP.height / img.height;
		addGraphic(img);
		
		addGraphic(DrawText.CreateTextEntity(CLocals.text.mainMenu_score, GameFont.Molot, 32, 400, 220, 0x0, true));
		
		textPlayersElements = new Array<DrawText>();
		for (i in 0...10) 
		{
			textPlayersElements.push(new DrawText("AAA", GameFont.PixelCyr, 24, 180, 260 + i * 20, 0x000000, false));
			addGraphic(textPlayersElements[i].label);
		}
		for (i in 10...20) 
		{
			textPlayersElements.push(new DrawText("0", GameFont.JoystixMonospace, 24, 460, 260 + (i-10)*20, 0x000000, false));
			addGraphic(textPlayersElements[i].label);
		}
		
		LoadScores();
		UpdateText();
		
		super.begin();
	}
	
	public override function update()
	{
		if (Input.pressed("esc") || Screen.joyPressed("BACK") || Screen.joyPressed("B") || Screen.touchPressed("esc"))
		{
			HXP.scene = new MainMenu();
		}
		
		super.update();
	}
	
	public static function LoadScores()
	{
		var scoresData:Xml;
#if android
		if ( FileSystem.exists( SystemPath.applicationStorageDirectory + "/scores.xml" ) )
		{
			scoresData = Xml.parse(File.getContent( SystemPath.applicationStorageDirectory + "/scores.xml" ));
#elseif flash
		Data.load("tpuquuest_data");
		if (Data.read("scores") != null)
		{
			scoresData = Xml.parse(Data.read("scores"));
#else
		if ( FileSystem.exists( "scores.xml" ) )
		{
			scoresData = Xml.parse(File.getContent( "scores.xml" ));
#end
			scoresList = new Array<Record>();
			
			for (temp in scoresData.firstChild().iterator())
			{
				scoresList.push(  { name : temp.get( "name" ), score : Std.parseInt( temp.get( "score" )) } );
			}
		}
		else
		{
			scoresData = Xml.createElement( "scores" );
			scoresList = new Array<Record>();
			
			for (i in 0...10) 
			{
				var temp:Xml = Xml.createElement("player" + Std.string(i + 1));
				temp.set("name", "AAA");
				temp.set("score", "0");
				scoresData.addChild(temp);
				
				scoresList.push(  { name : "AAA", score : 0 } );
			}
#if android	
			File.saveContent(SystemPath.applicationStorageDirectory + "/scores.xml", scoresData.toString() );
#elseif flash
			Data.write("scores", scoresData.toString());
			Data.save("tpuquuest_data", true);
#else
			File.saveContent("scores.xml", scoresData.toString() );
#end
		}
	}
	
	public static function AddNewResult( name:String, score:Int)
	{
		if (name.length > 12)
			name = name.substring(0, 11);
		if (score > 999999999)
			score = 999999999;
		if (score <= scoresList[9].score)
			return;

		scoresList.push(  { name : name, score : score } );
		scoresList.sort( function(a:Record, b:Record):Int
		{
			if (a.score > b.score) return -1;
			if (a.score < b.score) return 1;
			return 0;
		} );
		
		scoresList.splice(10, 1);
	}
	
	public static function SaveScores()
	{
		var scoresData:Xml = Xml.createElement( "scores" );
		
		for (i in 0...10) 
		{
			var temp:Xml = Xml.createElement("player" + Std.string(i + 1));
			temp.set("name", scoresList[i].name);
			temp.set("score", Std.string(scoresList[i].score));
			scoresData.addChild(temp);
		}
#if android	
			File.saveContent(SystemPath.applicationStorageDirectory + "/scores.xml", scoresData.toString() );
#elseif flash
			Data.write("scores", scoresData.toString());
			Data.save("tpuquuest_data", true);
#else
			File.saveContent("scores.xml", scoresData.toString() );
#end
	}
	
	private function UpdateText()
	{
		for (i in 0...10) 
		{
			textPlayersElements[i].ChangeStr( scoresList[i].name, false );
			
			var t:String = Std.string(scoresList[i].score);
			for ( j  in 0...-t.length + 9)
			{
				t = "0" + t;
			}
			textPlayersElements[i + 10].ChangeStr( t, false );
		}
	}
}