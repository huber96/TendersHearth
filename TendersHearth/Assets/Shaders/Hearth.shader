Shader "Custom/Hearth"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}

		_Color("Color", Color) = (0.5,0.5,0.5,1)
		[HDR] _Emission("Emission", Color) = (0,0,0,1)
		_ShadowColor("Shadow color", Color) = (0,0,0,1)
		_RimPower("Rim power", Range(0, 1)) = 0
		_OutlinePower("Outline transparency", Range(0, 1)) = 0.4
		_OutlineSize("Outline size", Range(0, 1)) = 0.8
    }
    SubShader
    {
        Tags {"Queue" = "Transparent" "Queue" = "Transparent"}
        LOD 200

		Blend One One

		Pass
		{
			Name "GetDepth"
			ZWrite On
			ColorMask 0
		}

        CGPROGRAM
        #pragma surface surf Tender fullforwardshadows alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _ShadowColor;
		fixed4 _Emission;
		float _RimPower;
		float _OutlinePower;
		float _OutlineSize;

        struct Input
        {
            float2 uv_MainTex;
        };

		float4 LightingTender(SurfaceOutput s, float3 lightDir, float3 viewDir, float shadowAtten)
		{
			float NdotL = dot(s.Normal, lightDir);
			float lightChange = fwidth(NdotL);
			float lightIntensity = smoothstep(0, 0.1 + lightChange, NdotL * shadowAtten);

			float4 rimDot = (1 - dot(viewDir, s.Normal)) * _RimPower;

			float4 rimOutline = (1 - dot(viewDir, s.Normal)) * _OutlineSize;
			float outline = step(0.5, rimOutline) * _OutlinePower;

			float3 shadowColor = s.Albedo * _ShadowColor;
			fixed4 color;
			color.rgb = lerp(shadowColor, s.Albedo, lightIntensity) * rimDot.rgb * _LightColor0.rgb + outline;
			color.a = exp(_SinTime.z) * 0.2;

			return color;
		}

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
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
    FallBack "Diffuse"
}
