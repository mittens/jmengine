//----------------------------------------------------------------------------------------------------
// assetresource.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Asset resource for the AssetManager.
//----------------------------------------------------------------------------------------------------
package jmengine.assetmanager;

import lib.com.babylonhx.materials.textures.BaseTexture;

//----------------------------------------------------------------------------------------------------
// AssetResource Class Definition.
class AssetResource< T >
{
	public var resource : T;

	public var path : String;

	public var isLoading : Bool = false;
	public var loadingProgress : Float = 0.0;

	public var priority : Int = 0;

	public var _callback : Void -> Void;

	//------------------------------------------------------------------------------------------------
	public function new( resourcePath : String, ?loadAsync : Bool = true )
	{
		path = resourcePath;

		if( !loadAsync )
		{
			// Load resource synchronously (still mark as isLoading, but by the time it's loading, it'l already be done).
			isLoading = true;
			loadingProgress = 1;
		}
	}

	//------------------------------------------------------------------------------------------------
	public function update( )
	{
		// TODO: Get multithreaded (or coroutines) working.
	}
}