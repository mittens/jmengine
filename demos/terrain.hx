//----------------------------------------------------------------------------------------------------
// terrain.hx
//	Author: trent (2/13/16)
//	Modified:
//
// Simple terrain sample demo.
//----------------------------------------------------------------------------------------------------
package demos;

import lib.com.babylonhx.materials.StandardMaterial;
import lib.com.babylonhx.materials.textures.Texture;
import lib.com.babylonhx.math.Color3;
import lib.com.babylonhx.mesh.Mesh;

import lib.com.babylonhx.Scene;

//----------------------------------------------------------------------------------------------------
// Terrain Class Definition.
class Terrain
{
	public function new( scene : Scene )
	{
		// Ground
		var groundMaterial = new StandardMaterial( "m_terrain_ground", scene );
		StandardMaterial.DiffuseTextureEnabled = true;
		StandardMaterial.BumpTextureEnabled = true;
		StandardMaterial.SpecularTextureEnabled = true;

		groundMaterial.ambientTexture = new Texture( "assets/terrain/terrain_color.png", scene );
		groundMaterial.bumpTexture = new Texture( "assets/terrain/terrain_normal.png", scene );
		groundMaterial.roughness = 0.25;
		groundMaterial.specularColor = new Color3( 1, 1, 1 );
		groundMaterial.specularPower = 0.01;

		var ground : Mesh = Mesh.CreateGroundFromHeightMap( "mesh_ground", "assets/terrain/terrain_heightmap.png", 750, 750, 1024, 0, 100, scene, false );
		ground.material = groundMaterial;

		scene.addMesh( ground );
	}
}