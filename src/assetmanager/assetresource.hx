//----------------------------------------------------------------------------------------------------
// assetresource.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Asset resource for the AssetManager.
//----------------------------------------------------------------------------------------------------
package com.jmengine.assetmanager;

//----------------------------------------------------------------------------------------------------
// AssetResource Class Definition.
class AssetResource< T >
{
	public var resource : T;

	public var path : String;

	public var isLoading : Bool = false;
	public var loadingProgress : Float = 0.0;

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
}