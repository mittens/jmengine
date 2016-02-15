//----------------------------------------------------------------------------------------------------
// sky.hx
//	Author: trent (2/15/16)
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

import jmengine.rendering.ProceduralSky;

//----------------------------------------------------------------------------------------------------
// Sky Class Definition.
class Sky
{
	//------------------------------------------------------------------------------------------------
	public function new( scene : Scene )
	{
		// Ground
		var skyMaterial = new ProceduralSky( "m_sky", scene );
		var skydome : Mesh = Mesh.CreateSphere( "mesh_skybox", 16, 1000, scene );

		skyMaterial.backFaceCulling = false;

		skydome.material = skyMaterial;

		scene.addMesh( skydome );
	}
}