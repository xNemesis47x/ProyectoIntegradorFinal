// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Boat"
{
	Properties
	{
		_Speed("Speed", Float) = 0
		_Ang("Ang", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		Stencil
		{
			Ref 17
			Comp GEqual
			Pass Replace
			Fail Replace
			ZFail Replace
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _Speed;
		uniform float _Ang;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 VertexPos55 = ase_vertex3Pos;
			float temp_output_4_0 = sin( ( _Time.y * _Speed ) );
			float temp_output_14_0 = ( temp_output_4_0 * _Ang );
			float Cos42 = cos( temp_output_14_0 );
			float3 break26 = ase_vertex3Pos;
			float X47 = break26.x;
			float Sin41 = sin( temp_output_14_0 );
			float Z49 = break26.z;
			float Y48 = break26.y;
			float4 appendResult33 = (float4(( ( Cos42 * X47 ) - ( Sin41 * Z49 ) ) , Y48 , ( ( Sin41 * X47 ) + ( Cos42 * Z49 ) ) , 0.0));
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float Limite60 = ( ( temp_output_4_0 * ase_worldPos.x ) * 0.0002 );
			v.vertex.xyz += ( ( float4( VertexPos55 , 0.0 ) - appendResult33 ) + Limite60 ).xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color40 = IsGammaSpace() ? float4(0.3867925,0.1587989,0,0) : float4(0.1237993,0.02168739,0,0);
			o.Albedo = color40.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
267;73;579;609;1020.881;-354.8505;1;False;False
Node;AmplifyShaderEditor.CommentaryNode;58;-1143.208,205.177;Inherit;False;1459.142;271.4504;Angulo movimiento;10;23;24;42;41;1;3;2;4;14;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1090.688,361.4674;Inherit;False;Property;_Speed;Speed;0;0;Create;True;0;0;0;False;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1;-1093.208,291.6094;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2;-917.4849,290.992;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;57;-1129.377,791.7482;Inherit;False;665.2399;413.2448;VertexPosition;6;47;48;49;26;25;55;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-645.7974,363.028;Inherit;False;Property;_Ang;Ang;1;0;Create;True;0;0;0;False;0;False;0;0.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-772.1671,289.592;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;25;-1103.44,911.2901;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-493.1775,291.8876;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;-874.6841,986.5029;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.CosOpNode;24;-324.9584,334.6423;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;23;-322.9628,258.1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-126.6581,330.8871;Inherit;False;Cos;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-126.3471,252.8548;Inherit;False;Sin;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;-706.4556,923.2444;Inherit;False;X;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;59;-1136.216,510.8156;Inherit;False;963.825;258.7646;LimiteOscilación;5;60;36;37;35;19;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-703.5375,1089.832;Inherit;False;Z;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;53;-1108.288,1645.142;Inherit;False;47;X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-1107.201,1721.257;Inherit;False;42;Cos;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-1106.388,1797.141;Inherit;False;49;Z;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-1113.388,1482.243;Inherit;False;49;Z;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-1107.932,1569.772;Inherit;False;41;Sin;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;19;-1086.216,563.0146;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;46;-1119.229,1253.714;Inherit;False;42;Cos;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-1115.545,1408.248;Inherit;False;41;Sin;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;51;-1117.088,1328.844;Inherit;False;47;X;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-938.5582,1592.943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-747.6353,657.8417;Inherit;False;Constant;_Amplitud;Amplitud;2;0;Create;True;0;0;0;False;0;False;0.0002;0.0002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-945.5544,1282.298;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-928.8285,1745.151;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-705.2977,1005.314;Inherit;False;Y;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-743.1429,561.5159;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-944.4347,1429.903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;-735.8416,1499.547;Inherit;False;48;Y;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-593.1248,560.8156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;-862.774,835.7324;Inherit;False;VertexPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-770.7513,1661.357;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-767.3642,1351.092;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-551.448,1383.323;Inherit;False;55;VertexPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-409.7204,558.8107;Inherit;False;Limite;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-502.4895,1483.622;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-315.8723,1561.155;Inherit;False;60;Limite;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-319.0194,1461.838;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-110.4919,1463.092;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;40;-143.8127,1180.958;Inherit;False;Constant;_Color0;Color 0;5;0;Create;True;0;0;0;False;0;False;0.3867925,0.1587989,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;76.87469,1185.479;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Boat;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;True;17;False;-1;255;False;-1;255;False;-1;2;False;-1;3;False;-1;3;False;-1;3;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;0
WireConnection;2;1;3;0
WireConnection;4;0;2;0
WireConnection;14;0;4;0
WireConnection;14;1;22;0
WireConnection;26;0;25;0
WireConnection;24;0;14;0
WireConnection;23;0;14;0
WireConnection;42;0;24;0
WireConnection;41;0;23;0
WireConnection;47;0;26;0
WireConnection;49;0;26;2
WireConnection;29;0;44;0
WireConnection;29;1;53;0
WireConnection;27;0;46;0
WireConnection;27;1;51;0
WireConnection;30;0;45;0
WireConnection;30;1;54;0
WireConnection;48;0;26;1
WireConnection;35;0;4;0
WireConnection;35;1;19;1
WireConnection;28;0;43;0
WireConnection;28;1;52;0
WireConnection;36;0;35;0
WireConnection;36;1;37;0
WireConnection;55;0;25;0
WireConnection;32;0;29;0
WireConnection;32;1;30;0
WireConnection;31;0;27;0
WireConnection;31;1;28;0
WireConnection;60;0;36;0
WireConnection;33;0;31;0
WireConnection;33;1;50;0
WireConnection;33;2;32;0
WireConnection;34;0;56;0
WireConnection;34;1;33;0
WireConnection;39;0;34;0
WireConnection;39;1;61;0
WireConnection;0;0;40;0
WireConnection;0;11;39;0
ASEEND*/
//CHKSM=F14CEB2D8717B8E52E43F5E8EAF7CCD0AF28D8F5