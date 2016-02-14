//----------------------------------------------------------------------------------------------------
// assetmanager.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Asset manager (singleton) for JMEngine for loading files asynchronously.
//----------------------------------------------------------------------------------------------------
package com.jmengine.assetmanager;

import lib.com.babylonhx.materials.textures.BaseTexture;

import lib.com.babylonhx.Scene;

//----------------------------------------------------------------------------------------------------
// Rseource Structure Definition;
typedef Resource< T > =
{
	var resource : T;

	var path : String;

	var isLoading : Bool = false;
	var loadingProgress : Float = 0.0;

	var _callback : Void -> Void;
}

//----------------------------------------------------------------------------------------------------
class AssetManager
{
	// Singleton instance.
	public static var instance : AssetManager = new AssetManager( );

	// Textures.
	private var texturesLoading : Map< String, AssetResource< BaseTexture > >;
	private var texturesLoaded : Map< String, AssetResource< BaseTexture > >;

	//------------------------------------------------------------------------------------------------
	private function new( )
	{
		// Just allocate the various maps.
		texturesLoading = new Map< String, AssetResource< BaseTexture > >( );
		texturesLoaded = new Map< String, AssetResource< BaseTexture > >( );
	}

	//------------------------------------------------------------------------------------------------
	public function LoadTextureSync< T >( resourcePath : String, scene : Scene ) : T
	{
		// Load a texture synchronously.
	}

	//------------------------------------------------------------------------------------------------
	public function LoadTextureAsync< T >( resourcePath : String, scene : Scene, _iteratorCallback : Void -> Float = null, _successCallback : Void -> Void = null, _failureCallback : Void -> Void = null ) : T
	{
		// Load a texture asynchronously.
	}
}