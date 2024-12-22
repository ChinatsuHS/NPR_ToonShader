// NormalBlur.cginc

#ifndef NORMAL_BLUR_CGINC
#define NORMAL_BLUR_CGINC

float3 ApplyNormalBlurBox(sampler2D normalMap, float2 uv, float blurRadius, float4 screenParams)
{
    float3 blurredNormal = 0;
    int samples = (blurRadius * 2 + 1) * (blurRadius * 2 + 1);
    float2 offset = float2(1 / screenParams.x, 1 / screenParams.y);

    for (int x = -blurRadius; x <= blurRadius; x++)
    {
        for (int y = -blurRadius; y <= blurRadius; y++)
        {
            float2 sampleUV = uv + float2(x, y) * offset;
            blurredNormal += UnpackNormal(tex2D(normalMap, sampleUV));
        }
    }
    return normalize(blurredNormal / samples);
}

float3 ApplyNormalBlurGaussian(sampler2D normalMap, float2 uv, float blurRadius, float4 screenParams)
{
    float3 blurredNormal = 0;
    float totalWeight = 0;
    float2 offset = float2(1 / screenParams.x, 1 / screenParams.y);
    float sigma = blurRadius / 3.0;

    for (int x = -blurRadius; x <= blurRadius; x++)
    {
        for (int y = -blurRadius; y <= blurRadius; y++)
        {
            float2 sampleUV = uv + float2(x, y) * offset;
            float weight = exp(-((x * x + y * y) / (2 * sigma * sigma))) / (sigma * sqrt(2 * UNITY_PI));
            blurredNormal += UnpackNormal(tex2D(normalMap, sampleUV)) * weight;
            totalWeight += weight;
        }
    }
    return normalize(blurredNormal / totalWeight);
}

#endif