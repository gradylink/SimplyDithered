#version 130

#include "settings.glsl"

varying vec4 glColor;

uniform float viewWidth;
uniform float viewHeight;

void main() {
    glColor = gl_Color;

    float lineThickness = LINE_THICKNESS;
    if (lineThickness == -1.0) {
#if defined(CLEAR_LINES) || defined(IGNORE_TERRAIN)
        lineThickness = 3.0;
#elif PIXEL_SIZE <= 256
        lineThickness = 10.0;
#else
        lineThickness = 7.0;
#endif
    }


    vec4 linePosStart = gl_ModelViewMatrix * gl_Vertex;
    vec4 linePosEnd = gl_ModelViewMatrix * vec4(gl_Vertex.xyz + gl_Normal.xyz, 1.0);

    vec4 clip1 = gl_ProjectionMatrix * linePosStart;
    vec4 clip2 = gl_ProjectionMatrix * linePosEnd;

    vec3 ndc1 = clip1.xyz / clip1.w;
    vec3 ndc2 = clip2.xyz / clip2.w;

    vec2 lineDir = normalize(ndc2.xy - ndc1.xy);
    vec2 lineOffset = vec2(-lineDir.y, lineDir.x) * (1.0 / vec2(viewWidth, viewHeight)) * lineThickness;

    if (gl_VertexID % 2 == 0) {
        gl_Position = vec4((ndc1.xy + lineOffset) * clip1.w, clip1.z, clip1.w);
    } else {
        gl_Position = vec4((ndc1.xy - lineOffset) * clip1.w, clip1.z, clip1.w);
    }
}
