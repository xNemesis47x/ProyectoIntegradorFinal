// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpecialCard"
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
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_Voronoi("Voronoi", Float) = 0
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
		uniform float _Angle;
		uniform float3 _Vector1;
		uniform float _Min;
		uniform float _Brightness;
		uniform float _Sharpness;
		uniform sampler2D _TextureSample2;
		uniform float _Voronoi;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode44 = tex2D( _TextureSample0, uv_TextureSample0 );
			float3 ase_worldNormal = i.worldNormal;
			float3 WorldNormal114 = ase_worldNormal;
			float dotResult37 = dot( WorldNormal114 , _Vector0 );
			float4 lerpResult42 = lerp( ( tex2DNode44 * _Color3 ) , ( tex2DNode44 * _Color2 ) , dotResult37);
			float4 BaseTexture123 = lerpResult42;
			float2 break8 = i.uv_texcoord;
			float temp_output_6_0 = radians( _Angle );
			float Angulo112 = ( ( break8.x * cos( temp_output_6_0 ) ) + ( break8.y * sin( temp_output_6_0 ) ) );
			float dotResult51 = dot( WorldNormal114 , _Vector1 );
			float Brillo119 = pow( ( 1.0 - ( abs( ( frac( ( Angulo112 + dotResult51 ) ) - _Min ) ) * _Brightness ) ) , _Sharpness );
			float4 lerpResult32 = lerp( _Color0 , _Color1 , Brillo119);
			o.Albedo = ( BaseTexture123 * ( 1.0 - lerpResult32 ) ).rgb;
			float4 Voronoi131 = ( tex2D( _TextureSample2, i.uv_texcoord ) * ( Brillo119 * _Voronoi ) );
			o.Emission = ( lerpResult32 + ( _Color1 * Brillo119 ) + Voronoi131 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

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
142;73;876;778;1259.327;168.1195;2.332367;False;False
Node;AmplifyShaderEditor.CommentaryNode;34;-3817.587,-108.0851;Inherit;False;1377.078;377.99;Angulo de línea;10;112;12;10;11;8;9;7;5;6;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3760.587,105.134;Inherit;False;Property;_Angle;Angle;0;0;Create;True;0;0;0;False;0;False;23.87807;0;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;6;-3448.322,146.9309;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-3674.678,-43.54562;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;8;-3317.608,-58.08516;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CommentaryNode;118;-3811.967,-346.4652;Inherit;False;495.2083;229.6452;WorldNormal;2;36;114;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinOpNode;7;-3275.479,193.8833;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;9;-3263.101,63.05832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;36;-3761.967,-296.46;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3057.599,103.519;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-3077.916,-34.63909;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;114;-3556.158,-296.4652;Inherit;False;WorldNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;33;-3817.549,285.7091;Inherit;False;1927.009;319.5988;Brillo;15;119;115;113;27;25;26;24;22;23;21;19;20;18;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2874.742,-6.194863;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-3785.784,338.9982;Inherit;False;114;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;52;-3802.024,420.726;Inherit;False;Property;_Vector1;Vector 1;10;0;Create;True;0;0;0;False;0;False;0,0,0;3,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-2694.889,-7.396811;Inherit;False;Angulo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-3590.115,336.7684;Inherit;False;112;Angulo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;51;-3617.142,404.9255;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-3398.842,335.7091;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3258.612,441.4767;Inherit;False;Property;_Min;Min;1;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;19;-3241.269,341.2061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-3043.843,374.8727;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;22;-2892.844,373.8727;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-2885.09,476.6784;Inherit;False;Property;_Brightness;Brightness;2;0;Create;True;0;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;125;-3811.896,613.5152;Inherit;False;1670.586;844.8317;BaseTexture;14;123;38;116;37;129;128;46;127;126;44;47;40;42;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-2705.545,380.1727;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2609.705,494.8583;Inherit;False;Property;_Sharpness;Sharpness;4;0;Create;True;0;0;0;False;0;False;2.84;4;1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-3790.554,671.269;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;0;Create;True;0;0;0;False;0;False;-1;None;75b5d253d68a4d249b8a5d1b5f7ff2f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;26;-2486.197,376.832;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;27;-2282.148,472.9786;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;126;-3481.948,1007.723;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;119;-2099.191,473.6613;Inherit;False;Brillo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-3472.642,1260.887;Inherit;False;Property;_Color2;Color 2;8;0;Create;True;0;0;0;False;0;False;0,0.5499787,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;133;-3808.405,1539.066;Inherit;False;1077.918;513.1133;Voronoi;8;108;101;104;110;121;100;130;131;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WireNode;127;-3285.524,1037.443;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-3746.217,1793.022;Inherit;False;119;Brillo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3177.151,1238.863;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-3718.968,1937.02;Inherit;False;Property;_Voronoi;Voronoi;12;0;Create;True;0;0;0;False;0;False;0;1.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;47;-3444.996,857.402;Inherit;False;Property;_Color3;Color 3;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;116;-2932.925,1091.012;Inherit;False;114;WorldNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;129;-2946.926,1352.775;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;38;-2892.165,1162.175;Inherit;False;Property;_Vector0;Vector 0;6;0;Create;True;0;0;0;False;0;False;0,1,1;0,1,1;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-3758.405,1616.121;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-3562.222,1794.067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;128;-2578.622,1293.329;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;101;-3503.219,1589.066;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;0;False;0;False;-1;None;1204d2d051008ae44bb79262bec83e97;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-3045.953,839.2667;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;130;-3207.596,1797.298;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-2705.373,1089.792;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;29;-1697.735,543.7246;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.5377358,0.0228284,0.0228284,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;120;-1306.993,741.0009;Inherit;False;119;Brillo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-1695.422,751.9498;Inherit;False;Property;_Color1;Color 1;3;0;Create;True;0;0;0;False;0;False;0.990566,0.03270739,0.03270739,1;0.7562709,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-3148.606,1594.584;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;-2516.121,1004.001;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;131;-2969.887,1591.55;Inherit;False;Voronoi;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;122;-1456.581,981.4067;Inherit;False;119;Brillo;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;-1076.674,550.2878;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;123;-2363.9,1006.973;Inherit;False;BaseTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;132;-492.9277,869.6274;Inherit;False;131;Voronoi;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1113.309,865.1793;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;66;-700.2032,575.7665;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;134;-829.6578,727.436;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-701.7646,492.9583;Inherit;False;123;BaseTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-465.2256,504.5357;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-264.69,744.945;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;35;-21.36283,504.6061;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SpecialCard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;8;0;5;0
WireConnection;7;0;6;0
WireConnection;9;0;6;0
WireConnection;11;0;8;1
WireConnection;11;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;114;0;36;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;112;0;12;0
WireConnection;51;0;115;0
WireConnection;51;1;52;0
WireConnection;18;0;113;0
WireConnection;18;1;51;0
WireConnection;19;0;18;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;22;0;21;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;26;0;24;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;126;0;44;0
WireConnection;119;0;27;0
WireConnection;127;0;126;0
WireConnection;40;0;127;0
WireConnection;40;1;41;0
WireConnection;129;0;40;0
WireConnection;110;0;121;0
WireConnection;110;1;104;0
WireConnection;128;0;129;0
WireConnection;101;1;108;0
WireConnection;46;0;44;0
WireConnection;46;1;47;0
WireConnection;130;0;110;0
WireConnection;37;0;116;0
WireConnection;37;1;38;0
WireConnection;100;0;101;0
WireConnection;100;1;130;0
WireConnection;42;0;46;0
WireConnection;42;1;128;0
WireConnection;42;2;37;0
WireConnection;131;0;100;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;32;2;120;0
WireConnection;123;0;42;0
WireConnection;49;0;31;0
WireConnection;49;1;122;0
WireConnection;66;0;32;0
WireConnection;134;0;32;0
WireConnection;45;0;124;0
WireConnection;45;1;66;0
WireConnection;111;0;134;0
WireConnection;111;1;49;0
WireConnection;111;2;132;0
WireConnection;35;0;45;0
WireConnection;35;2;111;0
ASEEND*/
//CHKSM=2030908A27C4E532BDCAD6A72FAF02A6A06708E9