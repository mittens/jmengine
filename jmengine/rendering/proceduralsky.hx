//----------------------------------------------------------------------------------------------------
// proceduralsky.hx
//	Author: trent (2/15/16)
//	Modified:
//
// Base definition for a procedural sky (temporarily based on BabylonHx's implementation).
//----------------------------------------------------------------------------------------------------
package jmengine.rendering;

import lib.com.babylonhx.math.Vector3;
import lib.com.babylonhx.math.Matrix;
import lib.com.babylonhx.materials.textures.BaseTexture;
import lib.com.babylonhx.mesh.AbstractMesh;
import lib.com.babylonhx.mesh.Mesh;
import lib.com.babylonhx.mesh.VertexBuffer;
import lib.com.babylonhx.tools.Tags;
import lib.com.babylonhx.materials.Material;
import lib.com.babylonhx.materials.MaterialDefines;
import lib.com.babylonhx.materials.ShadersStore;
import lib.com.babylonhx.materials.EffectFallbacks;
import lib.com.babylonhx.animations.IAnimatable;

import lib.com.babylonhx.Scene;
import lib.com.babylonhx.Engine;

import haxe.ds.Vector;

class ProceduralSkyParameters extends MaterialDefines
{

	public static inline var CLIPPLANE:Int = 0;
	public static inline var POINTSIZE:Int = 1;
	public static inline var FOG:Int = 2;
	public static inline var VERTEXCOLOR:Int = 3;
	public static inline var VERTEXALPHA:Int = 4;

	public function new( )
	{
		super( );

		this._keys = Vector.fromData( ["CLIPPLANE", "POINTSIZE", "FOG", "VERTEXCOLOR", "VERTEXALPHA"] );

		defines = new Vector(this._keys.length);
		for( i in 0...this._keys.length )
		{
			defines[i] = false;
		}
	}

}

class ProceduralSky extends Material
{
	static var fragmentShader:String = "precision highp float;\r\n\r\n// Input\r\nvarying vec3 vPositionW;\r\n\r\n#ifdef VERTEXCOLOR\r\nvarying vec4 vColor;\r\n#endif\r\n\r\n#ifdef CLIPPLANE\r\nvarying float fClipDistance;\r\n#endif\r\n\r\n// Sky\r\nuniform float luminance;\r\nuniform float turbidity;\r\nuniform float rayleigh;\r\nuniform float mieCoefficient;\r\nuniform float mieDirectionalG;\r\nuniform vec3 sunPosition;\r\n\r\n// Fog\r\n#ifdef FOG\r\n#define FOGMODE_NONE    0.\r\n#define FOGMODE_EXP     1.\r\n#define FOGMODE_EXP2    2.\r\n#define FOGMODE_LINEAR  3.\r\n#define E 2.71828\r\n\r\nuniform vec4 vFogInfos;\r\nuniform vec3 vFogColor;\r\nvarying float fFogDistance;\r\n\r\nfloat CalcFogFactor()\r\n{\r\n\tfloat fogCoeff = 1.0;\r\n\tfloat fogStart = vFogInfos.y;\r\n\tfloat fogEnd = vFogInfos.z;\r\n\tfloat fogDensity = vFogInfos.w;\r\n\r\n\tif (FOGMODE_LINEAR == vFogInfos.x)\r\n\t{\r\n\t\tfogCoeff = (fogEnd - fFogDistance) / (fogEnd - fogStart);\r\n\t}\r\n\telse if (FOGMODE_EXP == vFogInfos.x)\r\n\t{\r\n\t\tfogCoeff = 1.0 / pow(E, fFogDistance * fogDensity);\r\n\t}\r\n\telse if (FOGMODE_EXP2 == vFogInfos.x)\r\n\t{\r\n\t\tfogCoeff = 1.0 / pow(E, fFogDistance * fFogDistance * fogDensity * fogDensity);\r\n\t}\r\n\r\n\treturn clamp(fogCoeff, 0.0, 1.0);\r\n}\r\n#endif\r\n\r\n// Constants\r\nconst float e = 2.71828182845904523536028747135266249775724709369995957;\r\nconst float pi = 3.141592653589793238462643383279502884197169;\r\nconst float n = 1.0003;\r\nconst float N = 2.545E25;\r\nconst float pn = 0.035;\r\n\r\nconst vec3 lambda = vec3(680E-9, 550E-9, 450E-9);\r\n\r\nconst vec3 K = vec3(0.686, 0.678, 0.666);\r\nconst float v = 4.0;\r\n\r\nconst float rayleighZenithLength = 8.4E3;\r\nconst float mieZenithLength = 1.25E3;\r\nconst vec3 up = vec3(0.0, 1.0, 0.0);\r\n\r\nconst float EE = 1000.0;\r\nconst float sunAngularDiameterCos = 0.999956676946448443553574619906976478926848692873900859324;\r\n\r\nconst float cutoffAngle = pi/1.95;\r\nconst float steepness = 1.5;\r\n\r\nvec3 totalRayleigh(vec3 lambda)\r\n{\r\n\treturn (8.0 * pow(pi, 3.0) * pow(pow(n, 2.0) - 1.0, 2.0) * (6.0 + 3.0 * pn)) / (3.0 * N * pow(lambda, vec3(4.0)) * (6.0 - 7.0 * pn));\r\n}\r\n\r\nvec3 simplifiedRayleigh()\r\n{\r\n\treturn 0.0005 / vec3(94, 40, 18);\r\n}\r\n\r\nfloat rayleighPhase(float cosTheta)\r\n{\t \r\n\treturn (3.0 / (16.0*pi)) * (1.0 + pow(cosTheta, 2.0));\r\n}\r\n\r\nvec3 totalMie(vec3 lambda, vec3 K, float T)\r\n{\r\n\tfloat c = (0.2 * T ) * 10E-18;\r\n\treturn 0.434 * c * pi * pow((2.0 * pi) / lambda, vec3(v - 2.0)) * K;\r\n}\r\n\r\nfloat hgPhase(float cosTheta, float g)\r\n{\r\n\treturn (1.0 / (4.0*pi)) * ((1.0 - pow(g, 2.0)) / pow(1.0 - 2.0*g*cosTheta + pow(g, 2.0), 1.5));\r\n}\r\n\r\nfloat sunIntensity(float zenithAngleCos)\r\n{\r\n\treturn EE * max(0.0, 1.0 - exp(-((cutoffAngle - acos(zenithAngleCos))/steepness)));\r\n}\r\n\r\nfloat A = 0.15;\r\nfloat B = 0.50;\r\nfloat C = 0.10;\r\nfloat D = 0.20;\r\nfloat E = 0.02;\r\nfloat F = 0.30;\r\nfloat W = 1000.0;\r\n\r\nvec3 Uncharted2Tonemap(vec3 x)\r\n{\r\n\treturn ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;\r\n}\r\n\r\nvoid main(void) {\r\n\t// Clip plane\r\n#ifdef CLIPPLANE\r\n\tif (fClipDistance > 0.0)\r\n\t\tdiscard;\r\n#endif\r\n\r\n\t/**\r\n\t*--------------------------------------------------------------------------------------------------\r\n\t* Sky Color\r\n\t*--------------------------------------------------------------------------------------------------\r\n\t*/\r\n\tconst vec3 cameraPos = vec3(0.0, 0.0, 0.0);\r\n\tfloat sunfade = 1.0 - clamp(1.0 - exp((sunPosition.y / 450000.0)), 0.0, 1.0);\r\n\tfloat rayleighCoefficient = rayleigh - (1.0 * (1.0 - sunfade));\r\n\tvec3 sunDirection = normalize(sunPosition);\r\n\tfloat sunE = sunIntensity(dot(sunDirection, up));\r\n\tvec3 betaR = simplifiedRayleigh() * rayleighCoefficient;\r\n\tvec3 betaM = totalMie(lambda, K, turbidity) * mieCoefficient;\r\n\tfloat zenithAngle = acos(max(0.0, dot(up, normalize(vPositionW - cameraPos))));\r\n\tfloat sR = rayleighZenithLength / (cos(zenithAngle) + 0.15 * pow(93.885 - ((zenithAngle * 180.0) / pi), -1.253));\r\n\tfloat sM = mieZenithLength / (cos(zenithAngle) + 0.15 * pow(93.885 - ((zenithAngle * 180.0) / pi), -1.253));\r\n\tvec3 Fex = exp(-(betaR * sR + betaM * sM));\r\n\tfloat cosTheta = dot(normalize(vPositionW - cameraPos), sunDirection);\r\n\tfloat rPhase = rayleighPhase(cosTheta*0.5+0.5);\r\n\tvec3 betaRTheta = betaR * rPhase;\r\n\tfloat mPhase = hgPhase(cosTheta, mieDirectionalG);\r\n\tvec3 betaMTheta = betaM * mPhase;\r\n\t\r\n\tvec3 Lin = pow(sunE * ((betaRTheta + betaMTheta) / (betaR + betaM)) * (1.0 - Fex),vec3(1.5));\r\n\tLin *= mix(vec3(1.0), pow(sunE * ((betaRTheta + betaMTheta) / (betaR + betaM)) * Fex, vec3(1.0 / 2.0)), clamp(pow(1.0-dot(up, sunDirection), 5.0), 0.0, 1.0));\r\n\r\n\tvec3 direction = normalize(vPositionW - cameraPos);\r\n\tfloat theta = acos(direction.y);\r\n\tfloat phi = atan(direction.z, direction.x);\r\n\tvec2 uv = vec2(phi, theta) / vec2(2.0 * pi, pi) + vec2(0.5, 0.0);\r\n\tvec3 L0 = vec3(0.1) * Fex;\r\n\t\r\n\tfloat sundisk = smoothstep(sunAngularDiameterCos, sunAngularDiameterCos + 0.00002, cosTheta);\r\n\tL0 += (sunE * 19000.0 * Fex) * sundisk;\r\n\t\r\n\tvec3 whiteScale = 1.0/Uncharted2Tonemap(vec3(W));\r\n\tvec3 texColor = (Lin+L0);   \r\n\ttexColor *= 0.04 ;\r\n\ttexColor += vec3(0.0,0.001,0.0025)*0.3;\r\n\r\n\tfloat g_fMaxLuminance = 1.0;\r\n\tfloat fLumScaled = 0.1 / luminance;     \r\n\tfloat fLumCompressed = (fLumScaled * (1.0 + (fLumScaled / (g_fMaxLuminance * g_fMaxLuminance)))) / (1.0 + fLumScaled); \r\n\r\n\tfloat ExposureBias = fLumCompressed;\r\n\r\n\tvec3 curr = Uncharted2Tonemap((log2(2.0/pow(luminance,4.0)))*texColor);\r\n\tvec3 skyColor = curr * whiteScale;\r\n\r\n\tvec3 retColor = pow(skyColor,vec3(1.0/(1.2+(1.2*sunfade))));\r\n\t\r\n\tvec4 baseColor = vec4(retColor, 1.0);\r\n\t/**\r\n\t*--------------------------------------------------------------------------------------------------\r\n\t* Sky Color\r\n\t*--------------------------------------------------------------------------------------------------\r\n\t*/\r\n\t\r\n\t// Alpha\r\n\tfloat alpha = 1.0;\r\n\r\n#ifdef VERTEXCOLOR\r\n\tbaseColor.rgb *= vColor.rgb;\r\n#endif\r\n\r\n\t// Lighting\r\n\tvec3 diffuseBase = vec3(1.0, 1.0, 1.0);\r\n\r\n#ifdef VERTEXALPHA\r\n\talpha *= vColor.a;\r\n#endif\r\n\r\n\t// Composition\r\n\tvec4 color = vec4(baseColor.rgb, alpha);\r\n\r\n#ifdef FOG\r\n\tfloat fog = CalcFogFactor();\r\n\tcolor.rgb = fog * color.rgb + (1.0 - fog) * vFogColor;\r\n#endif\r\n\r\n\tgl_FragColor = color;\r\n}";

	static var vertexShader:String = "precision highp float;\r\n\r\n// Attributes\r\nattribute vec3 position;\r\n\r\n#ifdef VERTEXCOLOR\r\nattribute vec4 color;\r\n#endif\r\n\r\n// Uniforms\r\nuniform mat4 world;\r\nuniform mat4 viewProjection;\r\n\r\n#ifdef POINTSIZE\r\nuniform float pointSize;\r\n#endif\r\n\r\n// Output\r\nvarying vec3 vPositionW;\r\n\r\n#ifdef VERTEXCOLOR\r\nvarying vec4 vColor;\r\n#endif\r\n\r\n#ifdef CLIPPLANE\r\nuniform vec4 vClipPlane;\r\nvarying float fClipDistance;\r\n#endif\r\n\r\n#ifdef FOG\r\nvarying float fFogDistance;\r\n#endif\r\n\r\nvoid main(void) {\r\n\tgl_Position = viewProjection * world * vec4(position, 1.0);\r\n\t\r\n\tvec4 worldPos = world * vec4(position, 1.0);\r\n\tvPositionW = vec3(worldPos);\r\n\r\n\t// Clip plane\r\n#ifdef CLIPPLANE\r\n\tfClipDistance = dot(worldPos, vClipPlane);\r\n#endif\r\n\r\n\t// Fog\r\n#ifdef FOG\r\n\tfFogDistance = (view * worldPos).z;\r\n#endif\r\n\r\n\t// Vertex color\r\n#ifdef VERTEXCOLOR\r\n\tvColor = color;\r\n#endif\r\n\r\n\t// Point size\r\n#ifdef POINTSIZE\r\n\tgl_PointSize = pointSize;\r\n#endif\r\n}\r\n";

	// Public members
	public var luminance:Float = 1.0;
	public var turbidity:Float = 10.0;
	public var rayleigh:Float = 2.0;
	public var mieCoefficient:Float = 0.005;
	public var mieDirectionalG:Float = 0.8;

	public var distance:Float = 500;
	public var inclination:Float = 0.49;
	public var azimuth:Float = 0.25;

	// Private members
	private var _sunPosition:Vector3 = Vector3.Zero( );

	private var _renderId:Int;

	private var _defines:ProceduralSkyParameters = new ProceduralSkyParameters();
	private var _cachedDefines:ProceduralSkyParameters = new ProceduralSkyParameters();

	public function new( name:String, scene:Scene )
	{
		super( name, scene );

		if( !ShadersStore.Shaders.exists( "proceduralsky.frag" ) )
		{
			ShadersStore.Shaders.set( "proceduralsky.frag", fragmentShader );
			ShadersStore.Shaders.set( "proceduralsky.vert", vertexShader );
		}
	}

	override public function needAlphaBlending( ):Bool
	{
		return (this.alpha < 1.0);
	}

	override public function needAlphaTesting( ):Bool
	{
		return false;
	}

	override public function getAlphaTestTexture( ):BaseTexture
	{
		return null;
	}

	// Methods

	private function _checkCache( scene:Scene, ?mesh:AbstractMesh, useInstances:Bool = false ):Bool
	{
		if( mesh == null )
		{
			return true;
		}

		if( mesh._materialDefines != null && mesh._materialDefines.isEqual( this._defines ) )
		{
			return true;
		}

		return false;
	}

	override public function isReady( ?mesh:AbstractMesh, useInstances:Bool = false ):Bool
	{
		if( this.checkReadyOnlyOnce )
		{
			if( this._wasPreviouslyReady )
			{
				return true;
			}
		}

		var scene = this.getScene( );

		if( !this.checkReadyOnEveryCall )
		{
			if( this._renderId == scene.getRenderId( ) )
			{
				if( this._checkCache( scene, mesh, useInstances ) )
				{
					return true;
				}
			}
		}

		var engine:Engine = scene.getEngine( );
		this._defines.reset( );

		// Effect
		if( scene.clipPlane != null )
		{
			this._defines.defines[ProceduralSkyParameters.CLIPPLANE] = true;
		}

		// Point size
		if( this.pointsCloud || scene.forcePointsCloud )
		{
			this._defines.defines[ProceduralSkyParameters.POINTSIZE] = true;
		}

		// Fog
		if( scene.fogEnabled && mesh != null && mesh.applyFog && scene.fogMode != Scene.FOGMODE_NONE && this.fogEnabled )
		{
			this._defines.defines[ProceduralSkyParameters.FOG] = true;
		}

		// Attribs
		if( mesh != null )
		{
			if( mesh.useVertexColors && mesh.isVerticesDataPresent( VertexBuffer.ColorKind ) )
			{
				this._defines.defines[ProceduralSkyParameters.VERTEXCOLOR] = true;

				if( mesh.hasVertexAlpha )
				{
					this._defines.defines[ProceduralSkyParameters.VERTEXALPHA] = true;
				}
			}
		}

		// Get correct effect
		if( !this._defines.isEqual( this._cachedDefines ) || ( this._effect == null ) )
		{
			this._defines.cloneTo( this._cachedDefines );

			scene.resetCachedMaterial( );

			// Fallbacks
			var fallbacks:EffectFallbacks = new EffectFallbacks();
			if( this._defines.defines[ProceduralSkyParameters.FOG] )
			{
				fallbacks.addFallback( 1, "FOG" );
			}

			//Attributes
			var attribs:Array<String> = [VertexBuffer.PositionKind];

			if( this._defines.defines[ProceduralSkyParameters.VERTEXCOLOR] )
			{
				attribs.push( VertexBuffer.ColorKind );
			}

			// Legacy browser patch
			var shaderName:String = "proceduralsky";

			var join:String = this._defines.toString( );
			this._effect = scene.getEngine( ).createEffect( shaderName,
															attribs,
															["world", "viewProjection",
															"vFogInfos", "vFogColor", "pointSize", "vClipPlane",
															"luminance", "turbidity", "rayleigh", "mieCoefficient", "mieDirectionalG", "sunPosition"
															],
															[],
															join, fallbacks, this.onCompiled, this.onError );
		}

		if( !this._effect.isReady( ) )
		{
			return false;
		}

		this._renderId = scene.getRenderId( );
		this._wasPreviouslyReady = true;

		if( mesh != null )
		{
			if( mesh._materialDefines == null )
			{
				mesh._materialDefines = new ProceduralSkyParameters();
			}

			this._defines.cloneTo( mesh._materialDefines );
		}

		return true;
	}

	override public function bindOnlyWorldMatrix( world:Matrix )
	{
		this._effect.setMatrix( "world", world );
	}

	override public function bind( world:Matrix, ?mesh:Mesh )
	{
		var scene = this.getScene( );

		// Matrices
		this.bindOnlyWorldMatrix( world );
		this._effect.setMatrix( "viewProjection", scene.getTransformMatrix( ) );

		if( scene.getCachedMaterial( ) != this )
		{
			// Clip plane
			if( scene.clipPlane != null )
			{
				var clipPlane = scene.clipPlane;
				this._effect.setFloat4( "vClipPlane", clipPlane.normal.x, clipPlane.normal.y, clipPlane.normal.z, clipPlane.d );
			}

			// Point size
			if( this.pointsCloud )
			{
				this._effect.setFloat( "pointSize", this.pointSize );
			}
		}

		// View && Fog
		if( scene.fogEnabled && mesh.applyFog && scene.fogMode != Scene.FOGMODE_NONE )
		{
			this._effect.setMatrix( "view", scene.getViewMatrix( ) );

			this._effect.setFloat4( "vFogInfos", scene.fogMode, scene.fogStart, scene.fogEnd, scene.fogDensity );
			this._effect.setColor3( "vFogColor", scene.fogColor );
		}

		// Sky
		this._effect.setFloat( "luminance", this.luminance );
		this._effect.setFloat( "turbidity", this.turbidity );
		this._effect.setFloat( "rayleigh", this.rayleigh );
		this._effect.setFloat( "mieCoefficient", this.mieCoefficient );
		this._effect.setFloat( "mieDirectionalG", this.mieDirectionalG );

		var theta = Math.PI*(this.inclination - 0.5);
		var phi = 2*Math.PI*(this.azimuth - 0.5);

		this._sunPosition.x = this.distance*Math.cos( phi );
		this._sunPosition.y = this.distance*Math.sin( phi )*Math.sin( theta );
		this._sunPosition.z = this.distance*Math.sin( phi )*Math.cos( theta );

		this._effect.setVector3( "sunPosition", this._sunPosition );

		super.bind( world, mesh );
	}

	public function getAnimatables( ):Array<IAnimatable>
	{
		return [];
	}

	override public function dispose( forceDisposeEffect:Bool = false )
	{
		super.dispose( forceDisposeEffect );
	}

	override public function clone( name:String, cloneChildren:Bool = false ):ProceduralSky
	{
		var newMaterial = new ProceduralSky(name, this.getScene( ));

		// Base material
		this.copyTo( newMaterial );

		newMaterial.luminance = this.luminance;
		newMaterial.turbidity = this.turbidity;
		newMaterial.rayleigh = this.rayleigh;
		newMaterial.mieCoefficient = this.mieCoefficient;
		newMaterial.mieDirectionalG = this.mieDirectionalG;
		newMaterial.distance = this.distance;
		newMaterial.inclination = this.inclination;
		newMaterial.azimuth = this.azimuth;

		return newMaterial;
	}

	override public function serialize( ):Dynamic
	{
		var serializationObject = super.serialize( );
		serializationObject.customType = "ProceduralSky";

		serializationObject.luminance = this.luminance;
		serializationObject.turbidity = this.turbidity;
		serializationObject.rayleigh = this.rayleigh;
		serializationObject.mieCoefficient = this.mieCoefficient;
		serializationObject.mieDirectionalG = this.mieDirectionalG;
		serializationObject.distance = this.distance;
		serializationObject.inclination = this.inclination;
		serializationObject.azimuth = this.azimuth;

		return serializationObject;
	}

	public static function Parse( source:Dynamic, scene:Scene, rootUrl:String ):ProceduralSky
	{
		var material = new ProceduralSky(source.name, scene);

		material.alpha = source.alpha;
		material.id = source.id;

		Tags.AddTagsTo( material, source.tags );
		material.backFaceCulling = source.backFaceCulling;
		material.wireframe = source.wireframe;

		if( source.checkReadyOnlyOnce )
		{
			material.checkReadyOnlyOnce = source.checkReadyOnlyOnce;
		}

		material.luminance = source.luminance;
		material.turbidity = source.turbidity;
		material.rayleigh = source.rayleigh;
		material.mieCoefficient = source.mieCoefficient;
		material.mieDirectionalG = source.mieDirectionalG;
		material.distance = source.distance;
		material.inclination = source.inclination;
		material.azimuth = source.azimuth;

		return material;
	}
}