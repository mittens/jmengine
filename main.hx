package;

import js.Browser;

import js.stats.Stats;

import snow.system.window.Window;
import snow.types.Types;

import lib.com.babylonhx.Engine;
import lib.com.babylonhx.Scene;

class Main extends snow.App
{
	var engine : Engine;
	var scene : Scene;

	var stats : Stats;

	override function config( config : AppConfig ) : AppConfig
	{
		config.window.title = 'Joy Machine Engine (WebGL)';
		config.window.width = Browser.window.innerWidth;
		config.window.height = Browser.window.innerHeight;

		// Setup stats.
		stats = new Stats( );
		stats.setMode( 0 );		// FPS.

		// Align top-left.
		stats.domElement.style.position = 'absolute';
		stats.domElement.style.left = '0px';
		stats.domElement.style.top = '0px';

		return config;
	}

	override function ready( )
	{
		engine = new Engine( SnowApp._snow.window );
		scene = new Scene( engine );

		// Core demo setup.
		var demo = new demos.Demo( scene );

		// Various demo modules.
		var terrain = new demos.Terrain( scene );

		// Render loop.
		scene.getEngine( ).runRenderLoop( function( )
										  {
											  scene.render( );
										  } );
		app.window.onrender = render;

		js.Browser.document.body.appendChild( stats.domElement );
	}

	override function onmousedown( x  :  Int, y  :  Int, button  :  Int, timestamp  :  Float, window_id  :  Int )
	{
		for( f in Engine.mouseDown )
		{
			f( x, y, button );
		}
	}

	override function onmouseup( x  :  Int, y  :  Int, button  :  Int, timestamp  :  Float, window_id  :  Int )
	{
		for( f in Engine.mouseUp )
		{
			f( x, y, button );
		}
	}

	override function onmousemove( x  :  Int, y  :  Int, xrel  :  Int, yrel  :  Int, timestamp  :  Float, window_id  :  Int )
	{
		for( f in Engine.mouseMove )
		{
			f( x, y );
		}
	}

	override function onmousewheel( x  :  Int, y  :  Int, timestamp  :  Float, window_id  :  Int )
	{
		for( f in Engine.mouseWheel )
		{
			f( y );
		}
	}

	override function ontouchdown( x  :  Float, y  :  Float, touch_id  :  Int, timestamp  :  Float )
	{
		for( f in Engine.touchDown )
		{
			f( x, y, touch_id, timestamp );
		}
	}

	override function ontouchup( x  :  Float, y  :  Float, touch_id  :  Int, timestamp  :  Float )
	{
		for( f in Engine.touchUp )
		{
			f( x, y, touch_id, timestamp );
		}
	}

	override function ontouchmove( x  :  Float, y  :  Float, dx  :  Float, dy  :  Float, touch_id  :  Int, timestamp  :  Float )
	{
		for( f in Engine.touchMove )
		{
			f( x, y, dx, dy, touch_id, timestamp );
		}
	}

	override function onkeyup( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		if( keycode == Key.escape )
		{
			app.shutdown( );
		}

		for( f in Engine.keyUp )
		{
			f( keycode );
		}
	}

	override function onkeydown( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		for( f in Engine.keyDown )
		{
			f( keycode );
		}
	}

	function render( window : Window )
	{
		// Start stats.
		stats.begin( );

		engine._renderLoop( );

		// End stats.
		stats.end( );

		// Update stats.
		stats.update( );
	}
}