Shader "Unlit/InnerGlow"
{
    Properties
    {
		_Color("Color", Color) = (0,0,0,1)
		_TransparencyModifier("Transparency modifier", Range(0,0.5)) = 0.075
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Overlay"}
        LOD 100

		ZWrite Off
		ZTest Off
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

			fixed4 _Color;
			float _TransparencyModifier;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;

				float alpha = _TransparencyModifier * exp(_SinTime.z);
				col.a = alpha;
                return col;
            }
            ENDCG
        }
    }
}
