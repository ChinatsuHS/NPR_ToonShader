![image](https://github.com/user-attachments/assets/3a1f13dd-d44c-498c-ac6b-4a3da892352c) ![VRChat_2024-12-22_03-04-55 211_1920x1080](https://github.com/user-attachments/assets/a048dd48-280e-42d6-97e3-791d94ca37f3) 
![VRChat_2024-12-21_16-57-41 380_1920x1080](https://github.com/user-attachments/assets/66bccda0-357e-4c88-b20f-47968bc803e9)

# NPR_ToonShader
NPR Toon Shader for Build-in RenderPipeline in Unity

Consists of two Shaders.. a Opaque and Transparent Shader.
All logic is separated in .CGinc files and included into the shadercode

Features:

- Various methods to turn Unity's PBR lighting to NPR and completely create a flat Lighting without sacrificing Depth.

- Control of how many on Level the NPR conversion is done.

- Support for ORM Textures for control of Roughness,Occlussion and Metalic.

- Control of an extra pass of Flattening the PBR lighting further using a extra pass.

- Very lightweight for fast compiling on build by limiting the amount of textures needed.
  
- Same Look with and without scene lighting due to the unlit nature of the shader with some passes being lit.

No Scene Lighting: 
![image](https://github.com/user-attachments/assets/29beee14-03bf-4dfd-9434-7e2e4fbb5cca) 

With Scene Lighting: 
![image](https://github.com/user-attachments/assets/058a8e73-a560-4116-bb90-7acee591ab52)

