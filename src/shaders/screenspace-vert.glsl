#version 300 es

// A vertex shader used by all post-process shaders to simply pass UV data
// to the fragment shader, and to position the vertices of the screen-space quad 

precision highp float;

in vec4 vs_Pos;
in vec4 vs_Nor;
in vec4 vs_Col;
in vec2 vs_UV;

out vec2 fs_UV;
out vec4 fs_Pos;

void main() {
	fs_UV = vs_UV;
	gl_Position = vs_Pos;
	fs_Pos = vs_Pos; 
}
