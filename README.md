![image](https://github.com/user-attachments/assets/3a1f13dd-d44c-498c-ac6b-4a3da892352c)
# NPR_ToonShader
NPR Toon Shader for Build-in RenderPipeline in Unity

Consists of two Shaders.. a Opaque and Transparent Shader.
All logic is separated in .CGinc files and included into the shadercode

Features:

-Various methods to turn Unity's PBR lighting to NPR and completely create a flat Lighting without sacrificing Depth.
-Control of how many on Level the NPR conversion is done.
-Support for ORM Textures for control of Roughness,Occlussion and Metalic.
-Control of an extra pass of Flattening the PBR lighting further using a extra pass.

Very lightweight for fast compiling on build by limiting the amount of textures needed.

- Same Look with and without scene lighting due to the unlit nature of the shader with some passes being lit.

No Scene Lighting: 
![image](https://github.com/user-attachments/assets/29beee14-03bf-4dfd-9434-7e2e4fbb5cca) 

With Scene Lighting: 
![image](https://github.com/user-attachments/assets/058a8e73-a560-4116-bb90-7acee591ab52)

