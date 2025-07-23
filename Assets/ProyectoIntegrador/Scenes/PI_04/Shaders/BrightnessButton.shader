// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrightnessButton"
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
		uniform float _Angle;
		uniform float3 _Vector1;
		uniform float _Min;
		uniform float _Brightness;
		uniform float _Sharpness;
		uniform float _Step;
		uniform float3 _Vector2;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float _Ste;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode44 = tex2D( _TextureSample0, uv_TextureSample0 );
			float3 ase_worldNormal = i.worldNormal;
			float dotResult37 = dot( ase_worldNormal , _Vector0 );
			float4 lerpResult42 = lerp( ( tex2DNode44 * _Color3 ) , ( tex2DNode44 * _Color2 ) , dotResult37);
			float2 break8 = i.uv_texcoord;
			float temp_output_6_0 = radians( _Angle );
			float dotResult51 = dot( ase_worldNormal , _Vector1 );
			float temp_output_27_0 = pow( ( 1.0 - ( abs( ( frac( ( ( ( break8.x * cos( temp_output_6_0 ) ) + ( break8.y * sin( temp_output_6_0 ) ) ) + dotResult51 ) ) - _Min ) ) * _Brightness ) ) , _Sharpness );
			float4 lerpResult32 = lerp( _Color0 , _Color1 , temp_output_27_0);
			float4 temp_cast_0 = (_Step).xxxx;
			float dotResult54 = dot( ase_worldNormal , _Vector2 );
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			o.Albedo = ( lerpResult42 * ( lerpResult32 + ( 1.0 - step( temp_cast_0 , ( pow( dotResult54 , 4.0 ) * tex2D( _TextureSample1, uv_TextureSample1 ) ) ) ) ) ).rgb;
			float2 temp_cast_2 = (0.5).xx;
			float temp_output_98_0 = step( length( ( frac( ( i.uv_texcoord * 30.0 ) ) - temp_cast_2 ) ) , _Ste );
			o.Emission = ( _Color1 * temp_output_27_0 * temp_output_98_0 ).rgb;
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
188;73;511;621;967.5229;-723.0034;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;34;-2985.739,-45.5731;Inherit;False;1095.434;412.1287;Angulo de línea;9;4;6;5;9;7;8;10;11;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-2928.739,167.646;Inherit;False;Property;_Angle;Angle;1;0;Create;True;0;0;0;False;0;False;23.87807;40.8;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;6;-2616.474,209.443;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;5;-2842.83,18.9664;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;36;-733.6822,-575.6556;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;7;-2443.631,256.3955;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;33;-1848.672,31.35598;Inherit;False;1715.048;324.309;Brillo;12;18;19;20;21;22;23;24;26;25;27;51;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosOpNode;9;-2431.253,125.5703;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;8;-2485.76,4.426863;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2225.751,166.031;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;52;-1833.148,166.3726;Inherit;True;Property;_Vector1;Vector 1;16;0;Create;True;0;0;0;False;0;False;0,0,0;6.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2246.068,27.87293;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;53;-1699.896,-80.91772;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2042.894,56.31714;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;51;-1648.268,150.5721;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1429.97,81.35596;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1289.74,187.1232;Inherit;False;Property;_Min;Min;4;0;Create;True;0;0;0;False;0;False;0.5;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;19;-1272.397,86.85292;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-1074.971,120.5195;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;67;-901.6418,485.4047;Inherit;False;Property;_Vector2;Vector 2;19;0;Create;True;0;0;0;False;0;False;0,0,0;0.35,0,0.98;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;68;-2080.222,958.1091;Inherit;False;1095.434;412.1287;Angulo de línea;9;79;78;76;75;74;72;71;70;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-1924.524,709.5971;Inherit;False;Constant;_Float4;Float 4;20;0;Create;True;0;0;0;False;0;False;30;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;70;-2045.844,1018.906;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;54;-613.7477,477.8965;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;22;-923.9714,119.5195;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-916.2173,222.3249;Inherit;False;Property;_Brightness;Brightness;5;0;Create;True;0;0;0;False;0;False;2;1.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-736.6722,125.8195;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;61;-468.3163,577.4495;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;58;-738.2092,711.3296;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;0;False;0;False;-1;None;4b69a6228249ce0478d40bc17c26e399;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-1705.589,690.8869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1419.286,842.4582;Inherit;False;Constant;_Float5;Float 5;20;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;94;-1527.817,694.629;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-640.8311,240.5048;Inherit;False;Property;_Sharpness;Sharpness;9;0;Create;True;0;0;0;False;0;False;2.84;4;1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-253.8196,576.0648;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;26;-517.3234,122.4788;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-150.8458,481.5913;Inherit;False;Property;_Step;Step;18;0;Create;True;0;0;0;False;0;False;0.5;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;41;-115.6019,-472.6716;Inherit;False;Property;_Color2;Color 2;13;0;Create;True;0;0;0;False;0;False;0,0.5499787,1,0;0.3632067,0.7108209,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;95;-1316.981,695.4108;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;31;-114.2272,-35.83098;Inherit;False;Property;_Color1;Color 1;7;0;Create;True;0;0;0;False;0;False;0.990566,0.03270739,0.03270739,1;0.9811321,0.9625077,0.6525454,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-116.5403,-207.6563;Inherit;False;Property;_Color0;Color 0;10;0;Create;True;0;0;0;False;0;False;0.5377358,0.0228284,0.0228284,1;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;47;-2.667652,-838.6786;Inherit;False;Property;_Color3;Color 3;14;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.3333326,0.9589847,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;38;-404.8562,-449.9033;Inherit;False;Property;_Vector0;Vector 0;11;0;Create;True;0;0;0;False;0;False;0,1,1;7.3,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;59;40.82208,562.2267;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;27;-313.274,218.6251;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-72.96507,-1070.042;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;0;False;0;False;-1;None;75b5d253d68a4d249b8a5d1b5f7ff2f7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;97;-1116.183,695.1364;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;535.5099,-205.1163;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-783.019,919.5565;Inherit;False;Property;_Ste;Ste;20;0;Create;True;0;0;0;False;0;False;0.1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;312.3796,-894.2905;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;66;515.5552,561.6469;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;257.4238,-570.9448;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;37;-117.2662,-572.6882;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;42;835.2077,-553.1718;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;73;-943.1566,1035.038;Inherit;False;1715.048;324.309;Brillo;12;91;90;89;88;87;86;85;84;83;82;81;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;98;-555.5671,910.1758;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;788.0057,168.18;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;90;388.1927,1126.161;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;48;74.92033,-636.9236;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-10.70132,1226.007;Inherit;False;Property;_Float2;Float 2;6;0;Create;True;0;0;0;False;0;False;2;1.77;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;75;-1580.244,1008.109;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;80;-921.5743,1155.92;Inherit;False;Property;_Vector3;Vector 3;15;0;Create;True;0;0;0;False;0;False;0,0,0;6.5,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;69;-2023.222,1171.328;Inherit;False;Property;_Float0;Float 0;2;0;Create;True;0;0;0;False;0;False;23.87807;40.8;0;90;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-2963.04,1013.342;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;0.35;0.73;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-2974.891,903.4405;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;72;-1538.115,1260.078;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-521.2565,1056.261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;264.685,1244.187;Inherit;False;Property;_Float3;Float 3;8;0;Create;True;0;0;0;False;0;False;2.84;4;1;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;81;-742.7524,1154.254;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1335.38,1190.916;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-1342.572,1011.362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;86;-18.45531,1123.202;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;91;603.6407,1182.411;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;1121.278,-298.2752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RadiansOpNode;71;-1710.958,1213.125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;413.0263,97.9793;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;85;-169.4548,1124.202;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;74;-1542.901,1152.474;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;84;-384.2238,1190.805;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;0;False;0;False;0.5;0.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;83;-366.8808,1090.535;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-1179.784,1073.125;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-2778.024,937.2067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;168.8439,1129.502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;35;1335.105,-299.44;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;BrightnessButton;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;4;0
WireConnection;7;0;6;0
WireConnection;9;0;6;0
WireConnection;8;0;5;0
WireConnection;11;0;8;1
WireConnection;11;1;7;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;53;0;36;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;51;0;53;0
WireConnection;51;1;52;0
WireConnection;18;0;12;0
WireConnection;18;1;51;0
WireConnection;19;0;18;0
WireConnection;21;0;19;0
WireConnection;21;1;20;0
WireConnection;54;0;36;0
WireConnection;54;1;67;0
WireConnection;22;0;21;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;61;0;54;0
WireConnection;92;0;70;0
WireConnection;92;1;93;0
WireConnection;94;0;92;0
WireConnection;57;0;61;0
WireConnection;57;1;58;0
WireConnection;26;0;24;0
WireConnection;95;0;94;0
WireConnection;95;1;96;0
WireConnection;59;0;60;0
WireConnection;59;1;57;0
WireConnection;27;0;26;0
WireConnection;27;1;25;0
WireConnection;97;0;95;0
WireConnection;32;0;29;0
WireConnection;32;1;31;0
WireConnection;32;2;27;0
WireConnection;46;0;44;0
WireConnection;46;1;47;0
WireConnection;66;0;59;0
WireConnection;40;0;44;0
WireConnection;40;1;41;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;42;0;46;0
WireConnection;42;1;40;0
WireConnection;42;2;37;0
WireConnection;98;0;97;0
WireConnection;98;1;99;0
WireConnection;62;0;32;0
WireConnection;62;1;66;0
WireConnection;90;0;88;0
WireConnection;48;0;37;0
WireConnection;75;0;70;0
WireConnection;72;0;71;0
WireConnection;82;0;98;0
WireConnection;82;1;81;0
WireConnection;81;1;80;0
WireConnection;76;0;75;1
WireConnection;76;1;72;0
WireConnection;78;0;75;0
WireConnection;78;1;74;0
WireConnection;86;0;85;0
WireConnection;91;0;90;0
WireConnection;91;1;89;0
WireConnection;45;0;42;0
WireConnection;45;1;62;0
WireConnection;71;0;69;0
WireConnection;49;0;31;0
WireConnection;49;1;27;0
WireConnection;49;2;98;0
WireConnection;85;0;83;0
WireConnection;85;1;84;0
WireConnection;74;0;71;0
WireConnection;83;0;82;0
WireConnection;79;0;78;0
WireConnection;79;1;76;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;88;0;86;0
WireConnection;88;1;87;0
WireConnection;35;0;45;0
WireConnection;35;2;49;0
ASEEND*/
//CHKSM=F8B40AEF0A9D05265489A49C4C3419342976E249