Shader "Custom/SoftToon"
{
    Properties
    {
		_Color ("Color", Color) = (0,0,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "gray" {}
		_ShadowColor("Shadow color", Color) = (0,0,0,1)
		_ShadowSoftness("Shadow softness", Range(0.005,0.2)) = 0.1
		_RimSize("Rim size", Range(0,1)) = 1
		[HDR] _Emission("Emission", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf SoftToon fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _ShadowColor;
		fixed4 _Emission;
		float _ShadowSoftness;
		float _RimSize;

        struct Input
        {
            float2 uv_MainTex;
        };

		float4 LightingSoftToon(SurfaceOutput s, half3 lightDir, half3 viewDir, float shadowAtten)
		{
			float NdotL = dot(s.Normal, lightDir);
			float lightChange = fwidth(NdotL);

			// PAMTI!!!
			// smoothstep(a,b,x) -> vraća 0 ako je x < a, vraća 1 ako je x > b, vraća vr od 0 do 1 iz [a,b]  ako je a < x < b!
			float mainLight = smoothstep(0, _ShadowSoftness, NdotL * shadowAtten);
			float secondaryLight = smoothstep(0.5, 0.9, NdotL * shadowAtten);

			float3 shadowColor = s.Albedo.rgb * _ShadowColor;

			float rim = 1 - dot(s.Normal, viewDir) * (1 - _RimSize);
			float rimOutline = smoothstep(0.5, 0.55, rim * NdotL) * 0.9;


			float4 color;
			color.rgb = lerp(shadowColor, s.Albedo.rgb, mainLight) * _LightColor0.rgb;
			color.rgb += secondaryLight * _LightColor0.rgb;
			color.rgb += rimOutline * _LightColor0.rgb;
			color.a = s.Alpha;

			return color * _Color;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)	
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;

			o.Emission = _Emission;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
