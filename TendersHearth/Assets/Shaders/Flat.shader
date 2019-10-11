Shader "Custom/Flat"
{
    Properties
    {
		_Color ("Main color", Color) = (1,1,1,1)
		_ShadowColor ("Shadow color", Color) = (0,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
			#include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 worldNormal : NORMAL;
				float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;
			fixed4 _ShadowColor;

            v2f vert (appdata v)
            {
                v2f o;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				float3 derx = ddx(i.worldPos);
				float3 dery = ddy(i.worldPos);
				float3 crossRes = -normalize(cross(derx, dery));

				float l = saturate(dot(crossRes, _WorldSpaceLightPos0));

				float3 normal = normalize(i.worldNormal);
				float NdotL = dot(normal, _WorldSpaceLightPos0);

                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                UNITY_APPLY_FOG(i.fogCoord, col);

				fixed4 c;
				c.rgb = lerp(_ShadowColor.rgb, col.rgb, l) * _LightColor0.rgb;
				c.a = 1;

                return c;
            }
            ENDCG
        }

    }
}
