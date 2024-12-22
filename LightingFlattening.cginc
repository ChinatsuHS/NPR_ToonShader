// LightingFlattening.cginc

#ifndef LIGHTING_FLATTENING_CGINC
#define LIGHTING_FLATTENING_CGINC

fixed4 ApplyLightingFlattening(sampler2D mainTex, float2 uv, fixed4 flatteningColor, float flatteningIntensity, float flatteningLevel, fixed4 emissionColor, fixed4 baseColor, fixed4 col, fixed4 litColor)
{
    fixed4 baseTexColor = tex2D(mainTex, uv);

    // Flatten lighting
    float intensity = floor(baseTexColor.r * flatteningLevel) / flatteningLevel * flatteningIntensity;
    fixed4 flattenedBaseColor = lerp(baseTexColor, flatteningColor, intensity);

	
    // Add emission back in
	fixed4 finalColor = (col + litColor + emissionColor);
	finalColor.rgb = lerp(finalColor.rgb, flattenedBaseColor.rgb, intensity);
	finalColor.a = (col + litColor + emissionColor).a;

	return finalColor;
}

#endif