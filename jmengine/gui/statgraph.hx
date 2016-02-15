//----------------------------------------------------------------------------------------------------
// stats.hx
//	Author: trent (2/14/16)
//	Modified:
//
// UI stats display (from stats.js.hx).
//----------------------------------------------------------------------------------------------------
package jmengine.gui;

import js.Browser;

import js.stats.Stats;

//----------------------------------------------------------------------------------------------------
// Stats Class Definition.
class StatGraph
{
	private var stats : Stats;

	//------------------------------------------------------------------------------------------------
	public function new( )
	{
		// Setup stats.
		stats = new Stats( );
		stats.setMode( 0 );		// FPS.

		// Align top-left.
		stats.domElement.style.position = 'absolute';
		stats.domElement.style.left = '0px';
		stats.domElement.style.top = '0px';

		js.Browser.document.body.appendChild( stats.domElement );
	}

	//------------------------------------------------------------------------------------------------
	public function Begin( )
	{
		stats.begin( );
	}

	//------------------------------------------------------------------------------------------------
	public function End( )
	{
		stats.end( );
	}

	//------------------------------------------------------------------------------------------------
	public function Render( )
	{
		stats.update( );
	}
}