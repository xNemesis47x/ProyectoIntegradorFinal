// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Card"
{
	Properties
	{
		_Angle("Angle", Range( 0 , 90)) = 23.87807
		_Min("Min", Float) = 0.5
		_Brightness("Brightness", Float) = 2
		_Color1("Color 1", Color) = (0.990566,0.03270739,0.03270739,1)
		_Sharpness("Sharpness", Range( 1 , 4)) = 2.84
		_Color0("Color 0", Color) = (0.5377358,0.0228284,0.0228284,1)
		_Vector0("Vector 0", Vector) = (0,1,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Color2("Color 2", Color) = (0,0.5499787,1,0)
		_Color3("Color 3", Color) = (0,0,0,0)
		_Vector1("Vector 1", Vector) = (0,0,0,0)
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Step("Step", Float) = 0.5
		_Vector2("Vector 2", Vector) = (0,0,0,0)
		_Ste("Ste", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color3;
		uniform float4 _Color2;
		uniform float3 _Vector0;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Step;
		uniform float3 _Vector2;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _Angle;
		uniform float3 _Vector1;
		uniform float _Min;
		uniform float _Brightness;
		uniform float _Sharpness;
		uniform float _Ste;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode44 = tex2D( _TextureSample0, uv_TextureSample0 );
			float3 ase_worldNormal = i.worldNormal;
			float3 WorldNormal103 = ase_worldNormal;
			float dotResult37 = dot( WorldNormal103 , _Vector0 );
			float4 lerpResult42 = lerp( ( tex2DNode44 * _Color3 ) , ( tex2DNode44 * _Color2 ) , dotResult37);
			float4 BaseColor114 = lerpResult42;
			float4 lerpResult32 = lerp( _Color0 , _Color1 , float4( 0,0,0,0 ));
			float4 temp_cast_0 = (_Step).xxxx;
			float dotResult54 = dot( WorldNormal103 , _Vector2 );
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 PuntosFijos122 = ( 1.0 - step( temp_cast_0 , ( pow( dotResult54 , 4.0 ) * tex2D( _TextureSample1, uv_TextureSample1 ) ) ) );
			o.Albedo = ( BaseColor114 * ( lerpResult32 + PuntosFijos122 ) ).rgb;
			float2 break8 = i.uv_texcoord;
			float temp_output_6_0 = radians( _Angle );
			float Angulo112 = ( ( break8.x * cos( temp_output_6_0 ) ) + ( break8.y * sin( temp_output_6_0 ) ) );
			float dotResult51 = dot( WorldNormal103 , _Vector1 );
			float Brillo109 = pow( ( 1.0 - ( abs( ( frac( ( Angulo112 + dotResult51 ) ) - _Min ) ) * _Brightness ) ) , _Sharpness );
			float2 temp_cast_2 = (0.5).xx;
			float Puntos119 = step( length( ( frac( ( i.uv_texcoord * 30.0 ) ) - temp_cast_2 ) ) , _Ste );
			o.Emission = ( _Color1 * Brillo109 * Puntos119 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
267;73;579;609;3548.352;2234.043;6.778829;True;False
Node;AmplifyShaderEditor.CommentaryNode;34;-3311.314,-61.52217;Inherit;False;1292.982;399.0516;Angulo de línea;10;112;12;11;10;8;9;7;5;6;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3254.314,151.6969;Inherit;False;Property;_Angle;Angle;0;0;Create;True;0;0;0;False;0;False;23.87807;40.8;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;6;-2942.049,193.4939;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-3168.405,3.017337;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;-3299.371,-1327.717;Inherit;False;486.8867;234.1343;World Normal;2;36;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;7;-2769.206,240.4464;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;9;-2756.828,109.6212;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;8;-2811.335,-11.5222;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WorldNormalVector;36;-3249.371,-1273.222;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2571.643,11.92387;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2551.326,150.0819;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;33;-3308.219,-476.797;Inherit;False;1666.752;407.1018;Brillo;15;105;27;26;25;24;22;23;21;20;19;18;51;52;109;113;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;-3051.884,-1277.717;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2368.469,40.36808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-2234.87,42.19835;Inherit;False;Angulo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;52;-3295.295,-225.4695;Inherit;False;Property;_Vector1;Vector 1;10;0;Create;True;0;0;0;False;0;False;0,0,0;6.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;105;-3294.474,-300.6269;Inherit;False;103;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;124;-3296.913,729.7139;Inherit;False;1729.706;552.7667;Puntos Fijos;10;106;67;54;61;58;57;60;59;66;122;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;51;-3090.914,-293.8807;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-3293.831,-384.6284;Inherit;False;112;Angulo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-3243.792,779.7139;Inherit;False;103;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-2889.517,-377.397;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;67;-3246.913,860.711;Inherit;False;Property;_Vector2;Vector 2;13;0;Create;True;0;0;0;False;0;False;0,0,0;0.35,0,0.98;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;117;-3300.718,-1074.257;Inherit;False;1697.595;564.5157;BaseColor;13;114;42;38;104;37;41;116;40;47;46;44;121;126;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;118;-3304.004,373.7659;Inherit;False;1262.352;341.349;Puntos Rotación;10;119;99;98;97;96;94;95;92;70;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2728.486,-235.2299;Inherit;False;Property;_Min;Min;1;0;Create;True;0;0;0;False;0;False;0.5;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;70;-3254.004,423.7659;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;19;-2751.444,-378.4;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;54;-2961.05,841.0197;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-3250.718,-1024.257;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;75b5d253d68a4d249b8a5d1b5f7ff2f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;93;-3207.14,543.2532;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;116;-2954.739,-828.5184;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;58;-2956.83,963.3556;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;0;False;0;False;-1;None;4b69a6228249ce0478d40bc17c26e399;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;61;-2810.803,843.3801;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-3012.518,524.543;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-2616.421,-378.5334;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-3189.894,-780.5347;Inherit;False;Property;_Color2;Color 2;8;0;Create;True;0;0;0;False;0;False;0,0.5499787,1,0;0.990566,0.9874658,0.8924439,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-2484.967,-239.028;Inherit;False;Property;_Brightness;Brightness;2;0;Create;True;0;0;0;False;0;False;2;1.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;22;-2458.921,-378.2335;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-2501.688,772.5883;Inherit;False;Property;_Step;Step;12;0;Create;True;0;0;0;False;0;False;0.5;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;94;-2863.433,524.285;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-2637.997,-789.1946;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2881.902,611.1143;Inherit;False;Constant;_Float5;Float 5;20;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-2635.299,850.3509;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2324.919,-377.1334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;121;-2430.594,-939.2631;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-2393.43,-860.3965;Inherit;False;103;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-2727.597,523.0669;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;59;-2335.087,833.7276;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;47;-2890.245,-954.9773;Inherit;False;Property;_Color3;Color 3;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3333322,0.9589847,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;38;-2393.102,-777.2262;Inherit;False;Property;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0,1,1;7.3,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;37;-2197.373,-858.4465;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;126;-2381.045,-961.3342;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2317.478,-278.0481;Inherit;False;Property;_Sharpness;Sharpness;4;0;Create;True;0;0;0;False;0;False;2.84;4;1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;26;-2180.971,-375.2741;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;66;-2102.642,837.3344;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-2637.939,-1015.817;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LengthOpNode;97;-2551.799,522.7925;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-2565.088,602.9352;Inherit;False;Property;_Ste;Ste;14;0;Create;True;0;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-1734.91,181.1652;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0.990566,0.03270739,0.03270739,1;0.9811321,0.9625077,0.6525454,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-1737.223,9.339886;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.5377358,0.0228284,0.0228284,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-1912.443,830.6074;Inherit;False;PuntosFijos;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;27;-2014.621,-374.0279;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;98;-2395.096,525.0447;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;42;-2046.09,-1018.306;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-1842.814,-378.1709;Inherit;False;Brillo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-828.4342,101.4341;Inherit;False;122;PuntosFijos;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-1886.68,-1021.256;Inherit;False;BaseColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;-1085.173,11.87989;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2267.563,520.1442;Inherit;False;Puntos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1099.373,400.8938;Inherit;False;119;Puntos;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-338.3269,-62.18675;Inherit;False;114;BaseColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;-1102.618,320.7797;Inherit;False;109;Brillo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-621.7292,14.65858;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-833.3476,279.6194;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-132.0143,-7.735401;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;35;83.65942,-10.40587;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Card;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;7;0;6;0
WireConnection;9;0;6;0
WireConnection;8;0;5;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;11;0;8;1
WireConnection;11;1;7;0
WireConnection;103;0;36;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;112;0;12;0
WireConnection;51;0;105;0
WireConnection;51;1;52;0
WireConnection;18;0;113;0
WireConnection;18;1;51;0
WireConnection;19;0;18;0
WireConnection;54;0;106;0
WireConnection;54;1;67;0
WireConnection;116;0;44;0
WireConnection;61;0;54;0
WireConnection;92;0;70;0
WireConnection;92;1;93;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;22;0;21;0
WireConnection;94;0;92;0
WireConnection;40;0;116;0
WireConnection;40;1;41;0
WireConnection;57;0;61;0
WireConnection;57;1;58;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;121;0;40;0
WireConnection;95;0;94;0
WireConnection;95;1;96;0
WireConnection;59;0;60;0
WireConnection;59;1;57;0
WireConnection;37;0;104;0
WireConnection;37;1;38;0
WireConnection;126;0;121;0
WireConnection;26;0;24;0
WireConnection;66;0;59;0
WireConnection;46;0;44;0
WireConnection;46;1;47;0
WireConnection;97;0;95;0
WireConnection;122;0;66;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;42;0;46;0
WireConnection;42;1;126;0
WireConnection;42;2;37;0
WireConnection;109;0;27;0
WireConnection;114;0;42;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;119;0;98;0
WireConnection;62;0;32;0
WireConnection;62;1;123;0
WireConnection;49;0;31;0
WireConnection;49;1;111;0
WireConnection;49;2;120;0
WireConnection;45;0;115;0
WireConnection;45;1;62;0
WireConnection;35;0;45;0
WireConnection;35;2;49;0
ASEEND*/
//CHKSM=0B10152D2CA346093395FB7E35B067BD4BA0D421