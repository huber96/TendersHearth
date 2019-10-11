Shader "Custom/Toon"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "gray" {}
		_Color("Color", Color) = (0.5,0.5,0.5,1)
		_ShadowColor("Shadow color", Color) = (0,0,0,1)
		[HDR] _Emission("Emission", Color) = (0,0,0,1)
		_SpecularSize("Specular size", Range(0,1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Toon fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;

		fixed4 _Color;
		fixed4 _Emission;
		fixed4 _ShadowColor;
		float _SpecularSize;

        struct Input
        {
            float2 uv_MainTex;
        };

		float4 LightingToon(SurfaceOutput s, float3 lightDir, float3 viewDir, float shadowAtten)
		{
			float NdotL = dot(s.Normal, lightDir);
			float lightChange = fwidth(NdotL);
			float lightVal = smoothstep(0.5 - lightChange, 0.5 + lightChange, NdotL);

			float3 shadowColor = s.Albedo.rgb * _ShadowColor;

			float rim = 1 - dot(s.Normal, viewDir);
			float rimOutline = smoothstep(0.5, 0.55, rim * NdotL) * 0.9;

			fixed4 color;
			color.rgb = lerp(shadowColor, s.Albedo.rgb, lightVal) * _Color + rimOutline * _LightColor0.rgb;
			color.a = 1;

			return color * _LightColor0;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;


            o.Albedo = c.rgb;
            o.Alpha = c.a;

			o.Emission = _Emission;
        }
        ENDCG
    }
    FallBack "Standard"
}
