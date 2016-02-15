//----------------------------------------------------------------------------------------------------
// main.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Main app entry point.
//----------------------------------------------------------------------------------------------------
package;

import js.Browser;

import snow.system.window.Window;
import snow.types.Types;
import snow.App;

import lib.com.babylonhx.Engine;

import jmengine.JMEngine;

import jmengine.app.EntryPoint;

import demos.Demo;
import demos.Terrain;
import demos.TerrainAsync;

//------------------------------------------------------------------------------------------------
// Main class definition.
class Main extends snow.App
{
	var entryPoint : EntryPoint = new EntryPoint( );

	//------------------------------------------------------------------------------------------------
	override function config( config : AppConfig )
	{
		config.window.title = 'Joy Machine Engine (WebGL)';
		config.window.width = Browser.window.innerWidth;
		config.window.height = Browser.window.innerHeight;

		return config;
	}

	//------------------------------------------------------------------------------------------------
	override function ready( )
	{
		super.ready( );

		entryPoint.jmengine.engine = new Engine( SnowApp._snow.window );

		entryPoint.ready( );
		app.window.onrender = entryPoint.render;

		// Core demo setup.
		var demo = new Demo( entryPoint.jmengine.scene );

		// Various demo modules.
//		var terrain = new Terrain( entryPoint.jmengine.scene );
		var terrainAsync = new TerrainAsync( entryPoint.jmengine.scene );
	}

	//------------------------------------------------------------------------------------------------
	override function onmousedown( x : Int, y : Int, button : Int, timestamp : Float, window_id : Int )
	{
		entryPoint.onmousedown( x, y, button, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	override function onmouseup( x : Int, y : Int, button : Int, timestamp : Float, window_id : Int )
	{
		entryPoint.onmouseup( x, y, button, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	override function onmousemove( x : Int, y : Int, xrel : Int, yrel : Int, timestamp : Float, window_id : Int )
	{
		entryPoint.onmousemove( x, y, xrel, yrel, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	override function onmousewheel( x : Int, y : Int, timestamp : Float, window_id : Int )
	{
		entryPoint.onmousewheel( x, y, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	override function ontouchdown( x : Float, y : Float, touch_id : Int, timestamp : Float )
	{
		entryPoint.ontouchdown( x, y, touch_id, timestamp );
	}

	//------------------------------------------------------------------------------------------------
	override function ontouchup( x : Float, y : Float, touch_id : Int, timestamp : Float )
	{
		entryPoint.ontouchup( x, y, touch_id, timestamp );
	}

	//------------------------------------------------------------------------------------------------
	override function ontouchmove( x : Float, y : Float, dx : Float, dy : Float, touch_id : Int, timestamp : Float )
	{
		entryPoint.ontouchmove( x, y, dx, dy, touch_id, timestamp );
	}

	//------------------------------------------------------------------------------------------------
	override function onkeyup( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		if( keycode == Key.escape )
		{
			app.shutdown( );
		}

		entryPoint.onkeyup( keycode, scancode, repeat, mod, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	override function onkeydown( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		entryPoint.onkeydown( keycode, scancode, repeat, mod, timestamp, window_id );
	}
}