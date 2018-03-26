#version 300 es
precision highp float;

in vec2 fs_UV;
in vec4 fs_Pos;

out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;

const float focus = 10.0f;

const float maxDist = 20.0f;

// Render R, G, and B channels individually
void main() {
    vec4 test = fs_Pos;
    float s = abs(focus - fs_Pos.z);
    float t = clamp(s / maxDist, 0.0,1.0);

//gaussian blur based on https://github.com/Jam3/glsl-fast-gaussian-blur/blob/master/13.glsl

  vec2 direction = vec2(0,0) - vec2(fs_Pos);
  vec2 resolution = vec2(400,200);//vec2(1400,700) * scale; //how should i apply scale

  vec3 originalColor = texture(u_frame, fs_UV).xyz;

  vec3 color = vec3(0.0);
  vec2 off1 = vec2(1.411764705882353) * direction;
  vec2 off2 = vec2(3.2941176470588234) * direction;
  vec2 off3 = vec2(5.176470588235294) * direction;
  color += texture(u_frame, fs_UV).xyz * 0.1964825501511404;
  color += texture(u_frame, fs_UV + (off1 / resolution)).xyz * 0.2969069646728344;
  color += texture(u_frame, fs_UV - (off1 / resolution)).xyz * 0.2969069646728344;
  color += texture(u_frame, fs_UV + (off2 / resolution)).xyz * 0.09447039785044732;
  color += texture(u_frame, fs_UV - (off2 / resolution)).xyz * 0.09447039785044732;
  color += texture(u_frame, fs_UV + (off3 / resolution)).xyz * 0.010381362401148057;
  color += texture(u_frame, fs_UV - (off3 / resolution)).xyz * 0.010381362401148057;

  vec3 res = originalColor * (1.0-t) + color * t;
  out_Col = vec4(res, 1.0f);//vec4(texture(u_frame, fs_UV).xyz,1.0);
}