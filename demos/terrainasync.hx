//----------------------------------------------------------------------------------------------------
// terrain_async.hx
//	Author: trent (2/14/16)
//	Modified:
//
// Simple terrain sample demo (using asynchronous asset loading).
//----------------------------------------------------------------------------------------------------
package demos;

import lib.com.babylonhx.materials.StandardMaterial;
import lib.com.babylonhx.math.Color3;
import lib.com.babylonhx.mesh.Mesh;

import lib.com.babylonhx.Scene;

import jmengine.assetmanager.AssetManager;

//----------------------------------------------------------------------------------------------------
// TerrainAsync Class Definition.
class TerrainAsync
{
	//------------------------------------------------------------------------------------------------
	public function new( scene : Scene )
	{
		// Ground
		var groundMaterial = new StandardMaterial( "m_terrain_ground", scene );

		groundMaterial.ambientTexture = AssetManager.get_Instance( ).LoadTextureAsync( "assets/terrain/terrain_color.png", scene, 1 );
		groundMaterial.bumpTexture = AssetManager.get_Instance( ).LoadTextureAsync( "assets/terrain/terrain_normal.png", scene, 1 );
		groundMaterial.roughness = 0.25;
		groundMaterial.specularColor = new Color3( 1, 1, 1 );
		groundMaterial.specularPower = 0.01;

		var ground : Mesh = Mesh.CreateGroundFromHeightMap( "mesh_ground", "assets/terrain/terrain_heightmap.png", 750, 750, 1024, 0, 100, scene, false );
		ground.material = groundMaterial;

		scene.addMesh( ground );
	}
}