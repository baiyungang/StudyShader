Shader "test/DepthOfField"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DepthValue("Depth",Range(0,1)) = 0.5
			_FoucseWidth("_FoucseWidth",Float) = 1
	}
	SubShader
	{
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
			float _DepthValue;
			sampler2D _BlureTex;
			sampler2D _CameraDepthTexture;
			float _FoucseWidth;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 blurCol = tex2D(_BlureTex, i.uv);
				float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				float depth = Linear01Depth(d);
				float diff = saturate(abs(_DepthValue - depth) * _FoucseWidth);
				return  lerp(col, blurCol, diff);
			}
			ENDCG
		}
	}
}
