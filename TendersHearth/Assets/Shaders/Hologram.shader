Shader "Custom/Hologram"
{
    Properties
    {
		_Color ("Main color", Color) = (0,0,0,1)
		_Transparency ("Transparency", Range(0,1)) = 0.5
        _MainTex ("Main texture", 2D) = "gray" {}
		_TextureBlend("Texture blend", Range(0,1)) = 0.75
		_ScanlineTex ("Scanline texture", 2D) = "gray" {}
		_ScanlineSpeed ("Scanline speed", Range(0,5)) = 0.7
		_RimColor ("Rim color", Color) = (1,1,1,1)
		_RimPower ("Rim power", Range(0,1)) = 0.75
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask RGB
        LOD 100

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
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
                UNITY_FOG_COORDS(1)
				float4 screenPosition : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _ScanlineTex;
			float4 _ScanlineTex_ST;
			float _ScanlineSpeed;
			fixed4 _Color;
			float _Transparency;
			float _TextureBlend;
			fixed4 _RimColor;
			float _RimPower;

            v2f vert (appdata v)
            {
                v2f o;
				v.vertex.x += step(0.9999, _SinTime.w) * v.normal * _SinTime.x * 0.005;
				v.vertex.y += step(0.99, _SinTime.w) * v.normal * _SinTime.y * 0.005;
				v.vertex.z += step(0.999, _SinTime.w) * v.normal * _SinTime.z * 0.005;

                o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPosition = ComputeScreenPos(o.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.normal = v.normal;
				o.viewDir = ObjSpaceViewDir(v.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 textureCoordinates = i.screenPosition.xy / i.screenPosition.w;
				float ratio = _ScreenParams.x / _ScreenParams.y;
				textureCoordinates.x *= ratio;
				textureCoordinates = TRANSFORM_TEX(textureCoordinates, _ScanlineTex);

				float rim = 1 - dot(normalize(i.normal), normalize(i.viewDir));
				float rimOutline = rim * _RimPower;

				textureCoordinates.y += _Time.x * _ScanlineSpeed;

				fixed4 col1 = tex2D(_MainTex, i.uv);
				fixed4 col2 = tex2D(_ScanlineTex, textureCoordinates);

				fixed4 col;
				col = _TextureBlend * col1 *_Color + (1 - _TextureBlend) * col2;
                UNITY_APPLY_FOG(i.fogCoord, col);

				col.rgb += rimOutline * _RimColor.rgb;
				col.a = col.a * _Transparency;
                return col;
            }
            ENDCG
        }
    }
}
