#version 300 es
precision highp float;

in vec2 fs_UV;
in vec4 fs_Pos;

out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;

const float focus = 50.0f;

//based on http://www.geeks3d.com/20100909/shader-library-gaussian-blur-post-processing-filter-in-glsl/
const float offset[3] = float[]( 0.0, 1.3846153846, 3.2307692308 );
const float weight[3] = float[]( 1.0, 0.3162162162, 0.0702702703 );//0.2270270270, 0.3162162162, 0.0702702703 );

// Render R, G, and B channels individually
void main() {
    vec4 test = fs_Pos;
    float s = focus - fs_Pos.z;
    float scale = 1.0f / (s * s);
    //vec3 why = fs_Pos;//vec3(scale);
	// out_Col = vec4(texture(u_frame, fs_UV + vec2(0.33, 0.0)).r,
	// 							 texture(u_frame, fs_UV + vec2(0.0, -0.33)).g,
	// 							 texture(u_frame, fs_UV + vec2(-0.33, 0.0)).b,
	// 							 1.0);

//    vec3 tc = vec3(1.0f, 0.0f, 0.0f);

//     tc = texture(u_frame, fs_UV).xyz * weight[0];
//     for (int i=1; i<3; i++) 
//     {
//       tc += texture(u_frame, fs_UV + vec2(0.0, offset[i])/1.0).rgb \
//               * weight[i] * scale;
//       tc += texture(u_frame, fs_UV - vec2(0.0, offset[i])/1.0).rgb \
//              * weight[i] * scale;
//     }

  vec2 direction = vec2(0,0) - vec2(fs_Pos);
  vec2 resolution = vec2(400,200);

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


    out_Col = vec4(color, 1.0f);//vec4(texture(u_frame, fs_UV).xyz,1.0);
}