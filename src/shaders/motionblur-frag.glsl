#version 300 es
precision highp float;

in vec2 fs_UV;
in vec4 fs_Pos;

out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;
uniform vec2 u_Size;
//uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
//uniform sampler2D u_gb2;
//uniform sampler2D u_gb2;

const int numSamples = 32;

//based on : https://developer.nvidia.com/gpugems/GPUGems3/gpugems3_ch27.html and


void main() {
  // Get the initial color at this pixel.
  vec2 blurVec = texture(u_gb1,fs_UV).xy;
  // perform blur:
   vec4 result = texture(u_frame, fs_UV);
   for (int i = 1; i < numSamples; ++i) {
      vec2 offset = blurVec * (float(i) / float(numSamples - 1) - 0.5);
  
   // sample & add to result:
      result += texture(u_frame, fs_UV + offset);
   }
 
   result /= float(numSamples);
    out_Col = result;//vec4(blurVec,0.0,1.0);//vec4(result,0.0,1.0);

}