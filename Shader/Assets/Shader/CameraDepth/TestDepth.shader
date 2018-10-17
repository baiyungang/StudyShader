﻿Shader "test/testDepth"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			sampler2D _CameraDepthTexture;
			sampler2D _CameraDepthNormalsTexture;
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				float depth = Linear01Depth(d);
				return float4(depth, depth, depth, 1.0);

				//return tex2D(_CameraDepthTexture,i.uv);

			//	float d;
			//	float3 normal;
			//	DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv),d,normal);
			//	return float4(normal, 1.0);
				//float3 normal = DecodeViewNormalStereo(tex2D(_CameraDepthNormalsTexture, i.uv));
				//return tex2D(_CameraDepthNormalsTexture,i.uv);
			}
			ENDCG
		}
	}
}
