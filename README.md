# NPR_ToonShader
**NPR Toon Shader** for Unity's Built-in Render Pipeline.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/3a1f13dd-d44c-498c-ac6b-4a3da892352c" alt="Preview 1" width="300"></td>
    <td><img src="https://github.com/user-attachments/assets/a048dd48-280e-42d6-97e3-791d94ca37f3" alt="Preview 2" width="300"></td>
    <td><img src="https://github.com/user-attachments/assets/66bccda0-357e-4c88-b20f-47968bc803e9" alt="Preview 3" width="300"></td>
  </tr>
</table>

---

## Overview
This shader package includes two shaders:
- **Opaque Shader**
- **Transparent Shader**

All logic is modularized into `.CGinc` files for clean and reusable code.

---

## Features
- **NPR Lighting Conversion**: Various methods to adapt Unity's PBR lighting into NPR while maintaining depth perception.
- **Adjustable NPR Levels**: Full control over the extent of NPR conversion.
- **ORM Texture Support**: Manage **Roughness**, **Occlusion**, and **Metallic** properties via ORM textures.
- **Flat Lighting Enhancements**: Additional pass to further flatten PBR lighting without losing details.
- **Lightweight Design**: Minimal texture requirements enable fast build compilation.
- **Consistent Appearance**: Delivers a uniform look with or without scene lighting thanks to its predominantly unlit nature.

---

### Example Comparisons

#### No Scene Lighting:
![No Scene Lighting](https://github.com/user-attachments/assets/29beee14-03bf-4dfd-9434-7e2e4fbb5cca)

#### With Scene Lighting:
![With Scene Lighting](https://github.com/user-attachments/assets/058a8e73-a560-4116-bb90-7acee591ab52)

---

## Notes
- **Limitations**:
  - Does not work properly with overlapping UVs.
  - Lacks proper culling support (currently a work in progress).
