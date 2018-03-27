#version 300 es
precision highp float;

uniform mat4 u_Model;
uniform mat4 u_ModelInvTr;  

uniform mat4 u_View;   
uniform mat4 u_Proj; 

uniform float u_Time;
uniform mat4 u_PrevVPM;

in vec4 vs_Pos;
in vec4 vs_Nor;
in vec4 vs_Col;
in vec2 vs_UV;

out vec4 fs_Pos;
out vec4 fs_Nor;            
out vec4 fs_Col;           
out vec2 fs_UV;
out vec2 fs_Blur;

void main()
{
    fs_Col = vs_Col;
    fs_UV = vs_UV;
    fs_UV.y = 1.0 - fs_UV.y;
    vec4 pos = vs_Pos;

    // fragment info is in view space
    mat3 invTranspose = mat3(u_ModelInvTr);
    mat3 view = mat3(u_View);
    fs_Nor = vec4(view * invTranspose * vec3(vs_Nor), 0);
    fs_Pos = u_View * u_Model * pos;

    //calculate velocity vector for motion blur pass
    //based on GPU Gems found here: https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch27.html
    // Current viewport position
    // Use the world position, and transform by the previous view-
   // projection matrix.
//    vec4 previousPos = u_PrevVPM * pos;
// // Convert to nonhomogeneous points [-1,1] by dividing by w.
//    previousPos /= previousPos.w;
// // Use this frame's position and last frame's to compute the pixel
//    // velocity.
//    vec4 vel = (pos - previousPos)/2.f;
//    fs_Vel = vec3(vel);

// get previous screen space position:

//     float4 P = mul(modelView, in.coord);
// float4 Pprev = mul(prevModelView, in.prevCoord);
      vec4 previous = u_PrevVPM * u_Model * vs_Pos;
      previous /= previous.w;
      //previous.xy = previous.xy * 0.5 + 0.5;

      vec2 vel = vec2((fs_Pos- previous)/ 2.0f);// - vs_UV;
      fs_Blur = vel;


    
    
    gl_Position = u_Proj * u_View * u_Model * pos;
}
