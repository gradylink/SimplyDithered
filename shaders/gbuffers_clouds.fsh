#version 130

/* RENDERTARGETS: 0,1,2 */

#include "settings.glsl"

out vec4 fragColor;
out vec4 fragMask;
out vec4 fragMaskColor;

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 glColor;

void main() {
    vec4 color = texture2D(texture, texcoord) * glColor;

    if (color.a < 0.1) discard;

#ifdef IGNORE_CLOUDS
    fragColor = vec4(0.0);
    fragMaskColor = color;
    fragMask = vec4(0.0, 0.0, 1.0, 1.0);
#else
    fragColor = color;
    fragMaskColor = vec4(0.0);
    fragMask = vec4(0.0, 0.0, 0.0, 1.0);
#endif
}
