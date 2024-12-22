// PackedTexture.cginc
#ifndef PACKED_TEXTURE_CGINC
#define PACKED_TEXTURE_CGINC

float GetChannel(fixed4 packedTex, int channel)
{
    return channel == 0 ? packedTex.r : channel == 1 ? packedTex.g : channel == 2 ? packedTex.b : packedTex.a;
}

#endif