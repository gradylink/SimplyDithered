#version 130

varying vec4 glColor;
varying vec3 normal;

void main() {
    glColor = gl_Color;

    normal = gl_Normal;

    gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
}
