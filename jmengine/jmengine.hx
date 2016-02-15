//----------------------------------------------------------------------------------------------------
// jmengine.hx
//	Author: trent (2/13/16)
//	Modified: trent (2/14/16)
//
// Core Joy Machine WebGL engine class.
//----------------------------------------------------------------------------------------------------
package jmengine;

import snow.types.Types;

import lib.com.babylonhx.materials.StandardMaterial;

import lib.com.babylonhx.Engine;
import lib.com.babylonhx.Scene;

import jmengine.gui.StatGraph;

//----------------------------------------------------------------------------------------------------
// JMEngine Class Definition.
class JMEngine
{
	public var engine : Engine;
	public var scene : Scene;

	private var stats : StatGraph;

	//------------------------------------------------------------------------------------------------
	public function new( )
	{
	}

	//------------------------------------------------------------------------------------------------
	public function ready( )
	{
		// Setup the core Joy Machine WebGL engine.
		scene = new Scene( engine );

		engine.runRenderLoop( function( )
							  {
								  scene.render( );
							  } );

		// Set default settings.
		// Standard material.
		StandardMaterial.DiffuseTextureEnabled = true;
		StandardMaterial.BumpTextureEnabled = true;
		StandardMaterial.SpecularTextureEnabled = true;

		// Allocate stats.
		stats = new StatGraph( );
	}

	//------------------------------------------------------------------------------------------------
	public function render( )
	{
		// Start stats.
		stats.Begin( );

		engine._renderLoop( );

		// End stats.
		stats.End( );

		// Update stats.
		stats.Render( );
	}

	//------------------------------------------------------------------------------------------------
	public function onmousedown( x : Int, y : Int, button : Int, timestamp : Float, window_id : Int )
	{
		for( f in Engine.mouseDown )
		{
			f( x, y, button );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function onmouseup( x : Int, y : Int, button : Int, timestamp : Float, window_id : Int )
	{
		for( f in Engine.mouseUp )
		{
			f( x, y, button );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function onmousemove( x : Int, y : Int, xrel : Int, yrel : Int, timestamp : Float, window_id : Int )
	{
		for( f in Engine.mouseMove )
		{
			f( x, y );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function onmousewheel( x : Int, y : Int, timestamp : Float, window_id : Int )
	{
		for( f in Engine.mouseWheel )
		{
			f( y );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function ontouchdown( x : Float, y : Float, touch_id : Int, timestamp : Float )
	{
		for( f in Engine.touchDown )
		{
			f( x, y, touch_id, timestamp );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function ontouchup( x : Float, y : Float, touch_id : Int, timestamp : Float )
	{
		for( f in Engine.touchUp )
		{
			f( x, y, touch_id, timestamp );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function ontouchmove( x : Float, y : Float, dx : Float, dy : Float, touch_id : Int, timestamp : Float )
	{
		for( f in Engine.touchMove )
		{
			f( x, y, dx, dy, touch_id, timestamp );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function onkeyup( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		for( f in Engine.keyUp )
		{
			f( keycode );
		}
	}

	//------------------------------------------------------------------------------------------------
	public function onkeydown( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		for( f in Engine.keyDown )
		{
			f( keycode );
		}
	}

	//------------------------------------------------------------------------------------------------
	// Properties.
}