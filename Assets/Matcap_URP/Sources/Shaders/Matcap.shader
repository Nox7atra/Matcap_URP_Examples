Shader "Unlit/Matcap"
{
	Properties
	{
		_MainTex  ("MainTex", 2D) = "gray" {}
	}

	Subshader
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			uniform sampler2D _MainTex;
			
			struct appdata 
			{
			    float4 vertex    : POSITION;
			    float3 normal    : NORMAL;
			};

			struct v2f
			{
			    float4 pos	  : SV_POSITION;
			    float2 uv	  : TEXCOORD0;
			};
	
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				float3 worldNormal = normalize(unity_WorldToObject[0].xyz * v.normal.x + 
						                            unity_WorldToObject[1].xyz * v.normal.y + 
						                            unity_WorldToObject[2].xyz * v.normal.z);

				worldNormal = mul((float3x3)UNITY_MATRIX_V, worldNormal);
				o.uv.xy = worldNormal.xy * 0.5 + 0.5;

				return o;
			}
	
			float4 frag (v2f i) : COLOR
			{
			    
				float4 color = tex2D(_MainTex, i.uv);
				return color;
			}
			ENDCG
		}
	}
}