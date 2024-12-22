Shader "Fiochi/NPR_Toon_Cutout_Transparent"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _MainColor("Main Color", Color) = (0.5, 0.5, 0.5, 1)
        _MainColorEmission("Main Color Emission", Color) = (0, 0, 0, 0)
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        _OutlineThickness("Outline Thickness", Range(0, 0.1)) = 0.01
        _ShadingLevels("Shading Levels", Range(1, 1024)) = 3
        _OutlineDistanceScale("Outline Distance Scale", Float) = 0.01
        [Toggle(_UseOutlineDistanceScale)] _UseOutlineDistanceScale("Use Outline Distance Scale", Float) = 0
        _MinOutlineScale("Min Outline Scale", Float) = 0.5
        _MaxOutlineScale("Max Outline Scale", Float) = 1.5
        _NormalMap("Normal Map", 2D) = "bump" {}
        _NormalMapIntensity("Normal Map Intensity", Float) = 1
        [KeywordEnum(None, Box, Gaussian)] _NormalBlurMethod("Normal Blur Method", Int) = 0
        _NormalBlurRadius("Normal Blur Radius", Range(1, 10)) = 1
        _PackedTexture("Packed Texture", 2D) = "white" {}
        _OcclusionChannel("Occlusion Channel", Range(0, 3)) = 0
        _RoughnessChannel("Roughness Channel", Range(0, 3)) = 1
        _MetalnessChannel("MetalnessChannel", Range(0, 3)) = 2
        _Cutoff("Alpha Cutoff", Range(0, 1)) = 0.5
		
		[Toggle(_USEFLATTENING)] _USEFLATTENING ("Use Lighting Flattening", Float) = 0
        _FlatteningIntensity("Flattening Intensity", Range(0, 1)) = 1.0
        _FlatteningColor("Flattening Color", Color) = (0, 0, 0, 1)
        _FlatteningLevel("Flattening Level", Range(1, 20)) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" }
        LOD 100

        Pass // Main Rendering Pass
        {
            Cull Off
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase noshadow
            #include "UnityCG.cginc"
            #pragma multi_compile _NORMALBLURMETHOD_NONE _NORMALBLURMETHOD_BOX _NORMALBLURMETHOD_GAUSSIAN
            #pragma shader_feature _USEFLATTENING

            #include "NormalBlur.cginc"
            #include "PackedTexture.cginc"
			#include "TBN.cginc"
			#include "LightingFlattening.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float3 worldTangent : TEXCOORD3;
                float3 worldBinormal : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;
            fixed4 _MainColorEmission;
            float _NPRLightIntensity;

            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float _NormalMapIntensity;
            float _ShadingLevels;
            int _NormalBlurRadius;

            sampler2D _PackedTexture;
            int _OcclusionChannel;
            int _RoughnessChannel;
            int _MetalnessChannel;
            float _Cutoff;
				
			float _FlatteningIntensity;
			fixed4 _FlatteningColor;
			float _FlatteningLevel;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.worldBinormal = cross(o.normal, o.worldTangent) * v.tangent.w;
                return o;
            }

             fixed4 frag(v2f i) : SV_Target
            {
                fixed4 baseColor = _MainColor * 0.2;
                fixed4 col = tex2D(_MainTex, i.uv) * _MainColor;

                // Use a lower frequency sample for light calculation. This may reduce artifacts
                float2 lowFreqUV = floor(i.uv * 20) / 20;
                float3x3 tbn = CreateTBN(i.worldTangent, i.worldBinormal, i.normal);
                float3 normalMap = UnpackNormal(tex2D(_NormalMap, lowFreqUV));

                #if _NORMALBLURMETHOD_BOX
                     normalMap = ApplyNormalBlurBox(_NormalMap, lowFreqUV, _NormalBlurRadius, _ScreenParams);
                 #elif _NORMALBLURMETHOD_GAUSSIAN
                     normalMap = ApplyNormalBlurGaussian(_NormalMap, lowFreqUV, _NormalBlurRadius, _ScreenParams);
                  #endif

                 float3 normal = normalize(mul(tbn, normalMap).xyz) * _NormalMapIntensity;
                  float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
					
                col *= lerp(1, _MainColor, 0.2) * baseColor;

                 float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                 float facing = max(0, dot(normal, viewDir));
                 float diffuse = max(0, dot(normal, lightDir));
                int shadingLevels = (int)_ShadingLevels;
                 float stepSize = 1.0 / shadingLevels;
                float discreteDiffuse = floor(diffuse / stepSize) * stepSize;

                 fixed4 litColor = fixed4(tex2D(_MainTex, i.uv).rgb * facing * step(0.001, discreteDiffuse) * _NPRLightIntensity, 1.0);

                // --- MODIFIED EMISSION START ---
                // Use the main texture color directly for emission but multiplied by _MainColorEmission
                fixed4 emissionColor = tex2D(_MainTex, i.uv) * _MainColorEmission;
                 // --- MODIFIED EMISSION END ---

                float textureAlpha = tex2D(_MainTex, i.uv).a;
				
				// Ambient light calculation (using unity ambient)
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
                fixed4 ambientColor = fixed4(ambient, 1.0);

				fixed4 finalColor = (col + litColor + emissionColor);
                finalColor.rgb += ambientColor.rgb;
				   
				#if _USEFLATTENING
					finalColor = ApplyLightingFlattening(_MainTex, i.uv, _FlatteningColor, _FlatteningIntensity, _FlatteningLevel, emissionColor, baseColor, col, litColor);
				#endif

                 if (textureAlpha < _Cutoff)
                        discard;

                 return fixed4(finalColor.rgb, textureAlpha * _MainColor.a);
              }
              ENDCG
           }

           Pass // Outline Pass
           {
                Cull Front
                ZWrite Off
                Blend SrcAlpha OneMinusSrcAlpha
                AlphaTest Greater 0

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
                   float4 vertex : SV_POSITION;
                    float3 worldPos : TEXCOORD0;
                    float3 normal : TEXCOORD1;
                };

                fixed4 _OutlineColor;
                float _OutlineThickness;
                float _OutlineDistanceScale;
                float _UseOutlineDistanceScale;
                float _MinOutlineScale;
                float _MaxOutlineScale;

                v2f vert(appdata v)
                {
                   v2f o;
                    o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                    float distance = length(o.worldPos - _WorldSpaceCameraPos);
                    float distanceScale = (1 - saturate(distance * _OutlineDistanceScale));
                    float scale = lerp(_MinOutlineScale, _MaxOutlineScale, distanceScale);

                   o.vertex = UnityObjectToClipPos(v.vertex + v.normal * (_OutlineThickness * lerp(1, scale, _UseOutlineDistanceScale)));
                    o.normal = UnityObjectToWorldNormal(v.normal);
                    return o;
               }

                fixed4 frag(v2f i) : SV_Target
                {
                    return _OutlineColor;
                }
                ENDCG
            }
        }
        Fallback "Unlit/Color"
    }