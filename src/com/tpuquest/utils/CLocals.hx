package com.tpuquest.utils;

class CLocalsProxy extends haxe.xml.Proxy<"assets/cfg/localisation.xml", String> { }

class CLocals {
    public static var all  = new Map<String, String>();
    public static var text  = new CLocalsProxy(all.get);
    
    public static function set( lang = "ru" ) : Void 
	{
		try {
			var l_xmlString = sys.io.File.getContent( "localisation.xml" );
			var l_xmlFast   = new haxe.xml.Fast( Xml.parse( l_xmlString ).firstElement() );
			for ( i_node in l_xmlFast.nodes.item ) 
			{
				var l_text : String = "";
				switch (lang) 
				{
					case "ru" : l_text = i_node.node.ru.innerData;
					case "en" : l_text = ( i_node.hasNode.en ) ? i_node.node.en.innerData : i_node.node.ru.innerData;
				}
				all.set( i_node.att.id, l_text );
			}
		} catch ( msg : String ) 
		{
			trace("Error in CLocals.hx: " + msg);
		}
    }
}