﻿Shader "Unlit/LoadingEffectCenterTy"
{
    Properties
    {
		[PerRendererData]
        _MainTex("Texture", 2D) = "white" {}

		[MaterialToggle]
		_Inverse("Inverse", float) = 0

		[KeywordEnum(Circle, Rhombus, Heart, Star, Ring)]
		_Type("Type", float) = 0
		
		_Scale("Scale", Range(0, 100)) = 10
		
		_Value("Value", Range(-0.1, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }

		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

			#pragma shader_feature _TYPE_CIRCLE _TYPE_RHOMBUS _TYPE_HEART _TYPE_STAR _TYPE_RING

            #include "UnityCG.cginc"
			#include "ShapeAndMathG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				fixed4 color : COLOR;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
            };

            sampler2D _MainTex;

			fixed _Scale, _Value, _Inverse;

            v2f vert(appdata v)
            {
                v2f o;
                
				o.vertex = UnityObjectToClipPos(v.vertex);

                o.uv = v.uv;

				o.color = v.color;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
				
				fixed2 uv = i.uv;
				
				fixed2 st_uv = uv * _Scale + 0.5;

				fixed asp = _ScreenParams.y / _ScreenParams.x;

				fixed h_s = _Scale * 0.5;

				//比率対応
				st_uv.y *= asp;

				st_uv.y += (1 - frac(asp)) * (0.5 + h_s);

				fixed2 i_st = floor(st_uv) - h_s;

				fixed2 f_st = frac(st_uv) * 2 - 1;

				fixed a = 1;

				fixed2 sm;

				sm.x = floor(_Scale * 0.5);

				sm.y = floor(_Scale * asp * 0.5 + 0.5);

				float val = _Value * (length(sm) + 2);

				for(int i = -1; i <= 1; i++) 
				{
					for(int j = -1; j <= 1; j++)
					{
						float v = val - length(i_st + float2(i, j));

						float c = 0;

						#ifdef _TYPE_CIRCLE

						c = circle(f_st - fixed2(2 * i, 2 * j));

						#elif _TYPE_RHOMBUS

						c = rhombus(f_st - fixed2(2 * i, 2 * j), 0.25);

						#elif _TYPE_HEART

						c = heart(f_st - fixed2(2 * i, 2 * j), 0.25);

						#elif _TYPE_STAR

						fixed2 p = f_st - fixed2(2 * i, 2 * j);

						//まっすぐに表示するように角度を直す
						p = rotation2D(p, 55);

						c = star(p, 5, 0.5, 0.25);

						#elif _TYPE_RING

						c = ring(f_st - fixed2(2 * i, 2 * j), 0.5, 0.2);

						#endif

						a = min(a, step(v, c));
					}
				}

                fixed4 col = tex2D(_MainTex, uv);

				col.a = _Inverse - a * (_Inverse * 2 - 1);

                return col;
            }
            ENDCG
        }
    }
}
