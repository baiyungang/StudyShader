Shader "test/EdgeDepthAndNormals"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_sampleDistance("Distance",Float) = 1
		_Sensitivity("Sensitivity",Vector) = (1,1,1,1)
			_EdgeColor("EdgeColor",Color) = (0,0,0,1)
			_BackgroundColor("BackgroundColor",Color) = (0,0,0,1)
			_EdgeOnly("EdgeOnly",Float) = 0
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
				float2 uv[5] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half4 _MainTex_TexelSize;
			sampler2D _CameraDepthTexture;
			float _sampleDistance;
			float4 _Sensitivity;
			sampler2D _CameraDepthNormalsTexture;
			float4 _EdgeColor;
			float4 _BackgroundColor;
			float _EdgeOnly;
			half CheckSame(half4 center, half4 sample1)
			{
				half2 centerNormal = center.xy;
				float centerDepth = DecodeFloatRG(center.zw);
				half2 sampleNormal = sample1.xy;
				float sampleDepth = DecodeFloatRG(sample1.zw);

				half2 diffNormal = abs(centerNormal - sampleNormal) * _Sensitivity.x;
				int isSameNormal = (diffNormal.x + diffNormal.y) < 0.1;

				float diffDepth = abs(centerDepth - sampleDepth)*_Sensitivity.y;
				int isSameDepth = diffDepth < 0.1 * centerDepth;

				return isSameNormal * isSameDepth ? 1.0 : 0.0;
			}

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv[0] = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv[1] = v.uv + _MainTex_TexelSize * half2(1, 1) * _sampleDistance;
				o.uv[2] = v.uv + _MainTex_TexelSize * half2(-1, -1) * _sampleDistance;
				o.uv[3] = v.uv + _MainTex_TexelSize * half2(-1, 1) * _sampleDistance;
				o.uv[4] = v.uv + _MainTex_TexelSize * half2(1, -1) * _sampleDistance;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv[0]);

				half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[1]);
				half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[2]);
				half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[3]);
				half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[4]);

				half edge = 1.0;
				edge *= CheckSame(sample1, sample2);
				edge *= CheckSame(sample3, sample4);

				fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, i.uv[0]), edge);
				fixed4 onlyEdgeColor = lerp(_EdgeColor,_BackgroundColor, edge);

				return lerp(withEdgeColor, onlyEdgeColor,_EdgeOnly);
			}


			ENDCG
		}
	}
}
