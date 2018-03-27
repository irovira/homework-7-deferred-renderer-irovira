#version 300 es
precision highp float;

#define EPS 0.0001
#define PI 3.1415962

in vec2 fs_UV;
out vec4 out_Col;

uniform sampler2D u_gb0;
uniform sampler2D u_gb1;
uniform sampler2D u_gb2;

uniform float u_Time;

uniform mat4 u_View;
uniform vec3 u_CamPos;   

const vec3 lightPos = vec3(100, 1000, 0);

void main() { 
	// read from GBuffers

	vec4 gb0 = texture(u_gb0, fs_UV);
	vec4 gb2 = texture(u_gb2, fs_UV);

	vec3 col = gb2.xyz;
	//col = gb2.xyz;
	vec3 nor = gb0.rgb;

	// Given the UV coordinates of a fragment, map them to [-1, 1] NDC space, 
    //then apply the ray casting algorithm found on page 18 of these slides to 
    //project the point into camera space 

    float ndc_x = (fs_UV.x - 0.5f) * 2.0f;
    float ndc_y = (fs_UV.y- 0.5f) * 2.0f;
	
    //get vectors from view matrix
	vec3 cPos = vec3(u_CamPos);
    float a = (45.0 * 3.1415962 / 180.0) * 0.5;
    vec3 ref = cPos + gb0.a * vec3(0,0,1);
    float len = length(ref - cPos);

    vec3 v = vec3(0,1,0) * len * tan(a);
    vec3 h = vec3(1,0,0) * len * tan(a); //aspect = 1;

    vec3 p = ref + (ndc_x * h) + (ndc_y * v);
	vec3 lightVec = lightPos - p;

	float diffuseTerm = clamp(dot(normalize(nor), normalize(lightVec)), 0.0, 1.0);

	float ambientTerm = 0.1;

	float lightIntensity = diffuseTerm + ambientTerm;

	out_Col = vec4(col * lightIntensity, 1.0);
	//out_Col = vec4(col,1.0);

	//how do procedural backgroud pls HALP

}