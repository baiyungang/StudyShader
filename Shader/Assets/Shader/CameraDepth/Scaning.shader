Shader "test/Scaning"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Scaning("ScaningValue",Range(0,1)) = 0
		_LineColor("LineColor", Color) = (1, 0, 0, 0)
			_LineWidth("Width",Float) = 0.05
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
			float _Scaning;
			float4 _LineColor;
				sampler2D _CameraDepthTexture;
				float _LineWidth;
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

				float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
				float depth = Linear01Depth(d);
				float linewidth = _LineWidth / 2;
				float diff = saturate(abs(depth - _Scaning)/ linewidth);
				return lerp(_LineColor,col,diff);
			}
			ENDCG
		}
	}
}
