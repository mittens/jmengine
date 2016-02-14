//----------------------------------------------------------------------------------------------------
// demo.hx
//	Author: trent (2/13/16)
//	Modified:
//
// Base demo setup and configuration.
//----------------------------------------------------------------------------------------------------
package demos;

import lib.com.babylonhx.lights.IShadowLight;
import lib.com.babylonhx.lights.shadows.ShadowGenerator;
import lib.com.babylonhx.cameras.ArcRotateCamera;
import lib.com.babylonhx.lights.DirectionalLight;
import lib.com.babylonhx.lights.shadows.ShadowGenerator;
import lib.com.babylonhx.math.Color3;
import lib.com.babylonhx.math.Vector3;
import lib.com.babylonhx.Scene;

//----------------------------------------------------------------------------------------------------
// Demo Class Definition.
class Demo
{
	public function new( scene : Scene )
	{
		// Light
		var directional = new DirectionalLight( "l_sun", new Vector3( 0, -80, 10 ), scene );
		directional.diffuse = new Color3( 1, 1, 1 );
		directional.specular = new Color3( 0.1, 0.1, 0.1 );
		directional.intensity = 1;

		directional._shadowGenerator = new ShadowGenerator( 1024, cast( directional, IShadowLight ) );

		// Camera
		var camera = new ArcRotateCamera( "c_arc", 0, Math.PI*0.25, 400, Vector3.Zero( ), scene );
		camera.lowerRadiusLimit = 25;
		camera.upperRadiusLimit = 500;

		camera.attachControl( );
	}
}