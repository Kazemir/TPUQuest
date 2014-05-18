package com.tpuquest.screen;
import com.tpuquest.screen.ScoresMenu.Record;
import com.tpuquest.utils.DrawText;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.tpuquest.utils.CLocals;

import haxe.xml.*;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;

import openfl.utils.SystemPath;

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
	
	private function LoadScores()
	{
		var scoresData:Xml;
		if ( FileSystem.exists( SystemPath.applicationStorageDirectory + "scores.xml" ) )
		{
			scoresData = Xml.parse(File.getContent( SystemPath.applicationStorageDirectory + "scores.xml" ));
			scoresList = new Array<Record>();
			
			var i:Int = 0;
			for (temp in scoresData.firstChild().iterator())
			{
				textPlayersElements[i].ChangeStr( temp.get( "name" ), false );
				var t:String = temp.get( "score" );
				
				scoresList.push(  { name : temp.get( "name" ), score : Std.parseInt(t) } );
				
				for ( j  in 0...-t.length + 9)
				{
					t = "0" + t;
				}
				textPlayersElements[i + 10].ChangeStr( t, false );
				i++;
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
				
				textPlayersElements[i].ChangeStr( temp.get( "name" ), false );
				textPlayersElements[i + 10].ChangeStr( temp.get( "score" ), false );
				
				scoresList.push(  { name : "AAA", score : 0 } );
			}
			
			var fout:FileOutput = File.write( SystemPath.applicationStorageDirectory + "scores.xml", false );
			fout.writeString( scoresData.toString() );
			fout.close();
		}

		CLocals.set( SettingsMenu.language );
	}
	
	public function AddNewResult( name:String, score:Int)
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