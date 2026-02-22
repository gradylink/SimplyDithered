#version 130

varying vec4 color;

void main() {
    gl_Position = ftransform();
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    color = gl_Color;
}
