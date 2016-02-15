//----------------------------------------------------------------------------------------------------
// entrypoint.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Main app entry point.
//----------------------------------------------------------------------------------------------------
package jmengine.app;

import snow.system.window.Window;
import snow.types.Types;
import snow.App;

import jmengine.JMEngine;

//------------------------------------------------------------------------------------------------
// IEntryPoint Class Definition.
class EntryPoint
{
	public var jmengine : JMEngine;

	//------------------------------------------------------------------------------------------------
	public function new( )
	{
		// Allocate the engine.
		jmengine = new JMEngine( );
	}

	//------------------------------------------------------------------------------------------------
	public function ready( )
	{
		// Render loop.
		jmengine.ready( );
	}

	//------------------------------------------------------------------------------------------------
	public function render( window : Window )
	{
		jmengine.render( );
	}

	//------------------------------------------------------------------------------------------------
	public function onmousedown( x : Int, y : Int, button : Int, timestamp : Float, window_id : Int )
	{
		jmengine.onmousedown( x, y, button, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	public function onmouseup( x : Int, y : Int, button : Int, timestamp : Float, window_id : Int )
	{
		jmengine.onmouseup( x, y, button, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	public function onmousemove( x : Int, y : Int, xrel : Int, yrel : Int, timestamp : Float, window_id : Int )
	{
		jmengine.onmousemove( x, y, xrel, yrel, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	public function onmousewheel( x : Int, y : Int, timestamp : Float, window_id : Int )
	{
		jmengine.onmousewheel( x, y, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	public function ontouchdown( x : Float, y : Float, touch_id : Int, timestamp : Float )
	{
		jmengine.ontouchdown( x, y, touch_id, timestamp );
	}

	//------------------------------------------------------------------------------------------------
	public function ontouchup( x : Float, y : Float, touch_id : Int, timestamp : Float )
	{
		jmengine.ontouchup( x, y, touch_id, timestamp );
	}

	//------------------------------------------------------------------------------------------------
	public function ontouchmove( x : Float, y : Float, dx : Float, dy : Float, touch_id : Int, timestamp : Float )
	{
		jmengine.ontouchmove( x, y, dx, dy, touch_id, timestamp );
	}

	//------------------------------------------------------------------------------------------------
	public function onkeyup( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		jmengine.onkeyup( keycode, scancode, repeat, mod, timestamp, window_id );
	}

	//------------------------------------------------------------------------------------------------
	public function onkeydown( keycode : Int, scancode : Int, repeat : Bool, mod : ModState, timestamp : Float, window_id : Int )
	{
		jmengine.onkeydown( keycode, scancode, repeat, mod, timestamp, window_id );
	}
}