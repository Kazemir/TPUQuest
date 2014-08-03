package com.tpuquest.ui;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Mask;
import com.haxepunk.HXP;
import openfl.text.TextField;
import openfl.text.TextFieldType;

class Textbox extends Entity
{
	private var _textField:TextField;

	public function new(x:Float = 0, y:Float = 0, caption:String = "", spritemap:Spritemap = null ) 
	{
		super(x, y);
		
		_textField = new TextField();
		
		_textField.text = "OK!";
		_textField.type = TextFieldType.INPUT;
		_textField.multiline = false;
		_textField.wordWrap = false;
		_textField.visible = false;
		_textField.width = 400;
		_textField.height = 400;
		
		
		HXP.stage.addChild(_textField);
		HXP.stage.focus = _textField;
		// put caret at the end
		_textField.setSelection(_textField.text.length, _textField.text.length);
	}
	
	public override function update()
	{
		super.update();
		
		trace(_textField.text);
	}
}