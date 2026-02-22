#version 130

/* RENDERTARGETS: 0,1,2 */

#include "settings.glsl"

uniform sampler2D texture;
varying vec4 glColor;
varying vec3 normal;

out vec4 fragColor;
out vec4 fragMask;
out vec4 fragMaskColor;

uniform float viewHeight;
uniform float viewWidth;

uniform sampler2D depthtex0;

void main() {
    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth,viewHeight);
    float depth = texture(depthtex0,texCoord).r;
    if (depth != 1.0) {
        discard;
    }

    vec4 albedo = texture2D(texture, texCoord) * glColor;

    if (albedo.a < 0.1) discard;

    float shadow = 1.0;
    vec3 absN = abs(normal);
    shadow *= (absN.x * 0.75 + absN.z * 0.9 + max(0.0, normal.y) * 1.0 + max(0.0, -normal.y) * 0.5);
    albedo.rgb *= shadow;

#ifdef IGNORE_TERRAIN
    fragColor = vec4(0.0);
    fragMaskColor = albedo;
    fragMask = vec4(0.0, 0.0, 1.0, 1.0);
#else
    fragColor = albedo;
    fragMaskColor = vec4(0.0);
    fragMask = vec4(0.0, 0.0, 0.0, 1.0);
#endif
}
