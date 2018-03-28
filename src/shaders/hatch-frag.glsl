#version 300 es
precision highp float;

in vec2 fs_UV;
in vec4 fs_Pos;

out vec4 out_Col;

uniform sampler2D u_frame;
uniform float u_Time;
uniform vec2 u_Size;
uniform int u_PaintSamples;

const int radius = 5;

//oil paint effect based on Kuwahara filter method, written up in GPU Pro 3
//found here: https://www.reddit.com/r/shaders/comments/5e7026/help_making_an_oil_paint_post_processing_shader/

void main() {
  float n = float (( u_PaintSamples + 1) * ( u_PaintSamples + 1));
  vec3 m [4];
  vec3 s [4];
  for (int k = 0; k < 4; ++ k) {
        m[k] = vec3 (0.0);
        s[k] = vec3 (0.0);
  }
  vec3 col = texture(u_frame, fs_UV).rgb;

  
  struct Window { int x1 , y1 , x2 , y2; };
  Window W[4] = Window [4](
        Window ( -u_PaintSamples , -u_PaintSamples , 0, 0 ),
        Window ( 0, -u_PaintSamples , u_PaintSamples , 0 ),
        Window ( 0, 0, u_PaintSamples , u_PaintSamples ),
        Window ( -u_PaintSamples , 0, 0, u_PaintSamples )
  );
  for (int k = 0; k < 4; ++ k) {
       for (int j = W[k]. y1; j <= W[k].y2; ++ j) {
            for (int i = W[k].x1; i <= W[k]. x2; ++ i) {
                vec3 c = texture(u_frame , fs_UV + vec2(i ,j) / u_Size ).rgb ;
                m[k] += c;
                s[k] += c * c;
            }
        }
  }
  float min_sigma2 = 1e+2;
  for (int k = 0; k < 4; ++ k) {
        m[k] /= n;
        s[k] = abs (s[k] / n - m[k] * m[k]);
        float sigma2 = s[k].r + s[k].g + s[k].b;
        if ( sigma2 < min_sigma2 ) {
            min_sigma2 = sigma2 ;
            out_Col = vec4 (m[k], 1.0);
        }
  }
}