package com.tpuquest.utils;

import openfl.Assets;

class CLocalsProxy extends haxe.xml.Proxy<"assets/cfg/localisation.xml", String> { }

class CLocals {
    public static var all  = new Map<String, String>();
    public static var text  =  new CLocalsProxy(function(k) return all.get(k));
    
    public static function set( lang = "ru" ) : Void 
	{
		try {
			var l_xmlString = Assets.getText("cfg/localisation.xml");
			var l_xmlFast   = new haxe.xml.Fast( Xml.parse( l_xmlString ).firstElement() );
			for ( i_node in l_xmlFast.nodes.item ) 
			{
				var l_text : String = "";
				switch (lang) 
				{
					case "ru" : l_text = i_node.node.ru.innerData;
					case "en" : l_text = ( i_node.hasNode.en ) ? i_node.node.en.innerData : i_node.node.ru.innerData;
					case "de" : l_text = ( i_node.hasNode.de ) ? i_node.node.de.innerData : i_node.node.ru.innerData;
					case "ua" : l_text = ( i_node.hasNode.ua ) ? i_node.node.ua.innerData : i_node.node.ru.innerData;
					case "by" : l_text = ( i_node.hasNode.by ) ? i_node.node.by.innerData : i_node.node.ru.innerData;
					case "ga" : l_text = ( i_node.hasNode.ga ) ? i_node.node.ga.innerData : i_node.node.ru.innerData;
					case "fr" : l_text = ( i_node.hasNode.fr ) ? i_node.node.fr.innerData : i_node.node.ru.innerData;
					case "es" : l_text = ( i_node.hasNode.es ) ? i_node.node.es.innerData : i_node.node.ru.innerData;
					case "it" : l_text = ( i_node.hasNode.it ) ? i_node.node.it.innerData : i_node.node.ru.innerData;
					case "cz" : l_text = ( i_node.hasNode.cz ) ? i_node.node.cz.innerData : i_node.node.ru.innerData;
				}
				all.set( i_node.att.id, l_text );
			}
		} catch ( msg : String ) 
		{
			trace("Error in CLocals.hx: " + msg);
		}
    }
}