Shader "Unlit/MatcapBump"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv_bump : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed3 tSpace0 : TEXCOORD1;
				fixed3 tSpace1 : TEXCOORD2;
				fixed3 tSpace2 : TEXCOORD3;
            };

            uniform sampler2D _MainTex;
            uniform sampler2D _BumpMap;
            uniform float4 _BumpMap_ST;

            v2f vert (appdata_tan v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv_bump = TRANSFORM_TEX(v.texcoord,_BumpMap);
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                fixed3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;
                o.tSpace0 = fixed3(worldTangent.x, worldBinormal.x, worldNormal.x);
                o.tSpace1 = fixed3(worldTangent.y, worldBinormal.y, worldNormal.y);
                o.tSpace2 = fixed3(worldTangent.z, worldBinormal.z, worldNormal.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normals = UnpackNormal(tex2D(_BumpMap, i.uv_bump));
                float3 worldNorm;
                worldNorm.x = dot(i.tSpace0.xyz, normals);
                worldNorm.y = dot(i.tSpace1.xyz, normals);
                worldNorm.z = dot(i.tSpace2.xyz, normals);
                worldNorm = mul((float3x3)UNITY_MATRIX_V, worldNorm);
                fixed4 col = tex2D(_MainTex, worldNorm.xy * 0.5 + 0.5);
                return col;
            }
            ENDCG
        }
    }
}
