#version 130

/* RENDERTARGETS: 0,2,1 */

#include "settings.glsl"

varying vec4 glColor;
out vec4 fragColor;
out vec4 fragMaskColor;
out vec4 fragMask;

void main() {
#if defined(CLEAR_LINES) || defined(IGNORE_TERRAIN)
    fragColor = vec4(0.0);
    fragMaskColor = glColor;
    fragMask = vec4(0.0, 1.0, 0.0, 1.0); // Green channel for lines
#else
    fragColor = glColor;
    fragMaskColor = vec4(0.0);
    fragMask = vec4(0.0);
#endif
}
