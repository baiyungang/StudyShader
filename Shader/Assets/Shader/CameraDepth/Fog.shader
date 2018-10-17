Shader "test/Fog"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_FogColor("FogColor",Color) = (1,1,1,1)
		_FogDensity("Density", Range(0,5)) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

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
			float4 _FogColor;
			float _FogDensity;
			sampler2D _CameraDepthTexture;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex,i.uv);
				float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				float depth = Linear01Depth(d);
				float fogDensity = saturate(depth* _FogDensity);
				fixed4 finalCol = lerp(col, _FogColor, fogDensity);
				return finalCol;
			}
			ENDCG
		}
	}
}
