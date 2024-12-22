// TBN.cginc
#ifndef TBN_CGINC
#define TBN_CGINC

float3x3 CreateTBN(float3 worldTangent, float3 worldBinormal, float3 normal) {
     return float3x3(normalize(worldTangent), normalize(worldBinormal), normalize(normal));
}

#endif