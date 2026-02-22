#version 130

uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glColor;
varying vec3 normal;

attribute vec4 mc_Entity;
varying float blockID;

void main() {
    gl_Position = ftransform();
    gl_FogFragCoord = length((gl_ModelViewMatrix * gl_Vertex).xyz);
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glColor  = gl_Color;
    normal = mat3(gbufferModelViewInverse) * normalize(gl_NormalMatrix * gl_Normal);
    blockID = mc_Entity.x;
}
