//----------------------------------------------------------------------------------------------------
// assetmanager.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Asset manager (singleton) for JMEngine for loading files asynchronously.
//----------------------------------------------------------------------------------------------------
package jmengine.assetmanager;

import lib.com.babylonhx.materials.textures.Texture;

import lib.com.babylonhx.Scene;

import jmengine.assetmanager.AssetResource;

//----------------------------------------------------------------------------------------------------
class AssetManager
{
	// Singleton instance.
	private static var instance	: Null< AssetManager > = null;
	public static var Instance( get, null ) : AssetManager;

	// Textures.
	// TODO: Use AssetResource.
//	private var texturesLoading : Map< String, AssetResource< Texture > >;
//	private var texturesLoaded : Map< String, AssetResource< Texture > >;
	private var texturesLoading : Map< String, Texture >;
	private var texturesLoaded : Map< String, Texture >;

	//------------------------------------------------------------------------------------------------
	private function new( )
	{
		// Just allocate the various maps.
		// TODO: Use AssetResource.
//		texturesLoading = new Map< String, AssetResource< Texture > >( );
//		texturesLoaded = new Map< String, AssetResource< Texture > >( );
		texturesLoading = new Map< String, Texture >( );
		texturesLoaded = new Map< String, Texture >( );
	}

	//------------------------------------------------------------------------------------------------
	public function LoadTextureSync( resourcePath : String, scene : Scene ) : Texture
	{
		// Load a texture synchronously.
		// TODO: Use AssetResource.

		var texture : Texture = new Texture( resourcePath, scene );
		if( texturesLoaded.exists( resourcePath ) )
		{
			// Texture is already loaded.
			return texturesLoaded[resourcePath];
		}

		// Add the texture to the cache.
		texturesLoaded[resourcePath] = texture;

		return texture;
	}

	//------------------------------------------------------------------------------------------------
	public function LoadTextureAsync( resourcePath : String, scene : Scene, priority : Int = 0, _iteratorCallback : Void -> Float = null, _successCallback : Void -> Void = null, _failureCallback : Void -> Void = null ) : Texture
	{
		// Load a texture asynchronously.
		// TODO: Actually load a texture asynchronously.
		// TODO: Use AssetResource.

		// Load a texture synchronously.
		var texture : Texture = new Texture( resourcePath, scene );
		if( texturesLoaded.exists( resourcePath ) )
		{
			// Texture is already loaded.
			return texturesLoaded[resourcePath];
		}

		// Add the texture to the cache.
		texturesLoaded[resourcePath] = texture;

		return texture;
	}

	//------------------------------------------------------------------------------------------------
	// Properties.
	public static function get_Instance( ) : AssetManager
	{
		if( instance == null )
		{
			// Allocate the singleton.
			instance = new AssetManager( );
		}

		return instance;
	}
}