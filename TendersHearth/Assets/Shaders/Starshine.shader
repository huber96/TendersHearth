Shader "Unlit/Starshine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (0,0,0,1)
		_RimPower("Rim power", Range(0, 4)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry"}
        LOD 100

		Blend One OneMinusSrcAlpha

		Pass
		{
			ZWrite On
			ColorMask 0
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 screenPosition : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 viewDir : POSITION1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float _RimPower;

			fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPosition = ComputeScreenPos(o.vertex);
				o.normal = v.normal;
				o.viewDir = ObjSpaceViewDir(v.vertex);
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				float2 textureCoordinates = i.screenPosition.xy / i.screenPosition.w;
				float ratio = _ScreenParams.x / _ScreenParams.y;
				textureCoordinates.x *= ratio;
				textureCoordinates = TRANSFORM_TEX(textureCoordinates, _MainTex);

				float rim = (1 - dot(normalize(i.normal), normalize(i.viewDir))) * _RimPower;
				float rimOutline = smoothstep(0, 0.5, rim);
				float hardOutline = smoothstep(0.25, 1, rim);

                fixed4 col = tex2D(_MainTex, textureCoordinates);
				col.rgb += rimOutline * _Color.rgb + hardOutline;

                return col;
            }
            ENDCG
        }
    }
}
