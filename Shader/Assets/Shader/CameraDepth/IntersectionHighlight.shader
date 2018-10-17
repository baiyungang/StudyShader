Shader "test/IntersectionHighlight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ColorLine("ColorLine",Color) = (1,1,1,1)
		_IntersectionWidth("lineWidth",Range(0,1)) = 0.3
		_RimPower("RimPower",Range(0,2)) = 1
	}
	SubShader
	{
			//Tags{ "Queue" = "Transparent" "RenderType" = "Transparent" }
		Pass
		{
			//Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenPos:TEXCOORD1;
				float eyeZ : TEXCOORD2;
			//	float3 viewDir:TEXCOORD3;
			//	float3 worldNormal:TEXCOORD4;
			

			};
			float4 _MainTex_ST;
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture;
			float4 _ColorLine;
			float _IntersectionWidth;
			float _RimPower;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
				o.uv = TRANSFORM_TEX(v.uv,_MainTex);
				COMPUTE_EYEDEPTH(o.eyeZ); 

			//	float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
			//	o.viewDir = UnityWorldSpaceViewDir(worldPos);
			//	o.worldNormal = UnityObjectToWorldDir(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{ 
				fixed4 col = fixed4(1,1,0,1.0);
				float screenZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
				float halfWidth = _IntersectionWidth / 2;
				float diff = (abs(i.eyeZ - screenZ)/halfWidth);

				


				fixed4 finalColor = lerp(_ColorLine, col, diff);
				return finalColor;

				//float3 worldNormal = normalize(i.worldNormal);
				//float3 worldViewDir = normalize(i.viewDir);
				//float rim = 1 - saturate(dot(worldNormal, worldViewDir)) * _RimPower;
				//float v = max(rim,1 - diff);

				//return _ColorLine * v;

			}
			ENDCG
		}
	}
}
