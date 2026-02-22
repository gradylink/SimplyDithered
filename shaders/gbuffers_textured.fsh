#version 130

/* RENDERTARGETS: 0,1,2 */

#include "settings.glsl"

uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 texcoord;
varying vec2 lmcoord;
varying vec4 glColor;
varying vec3 normal;

uniform float blindness;
uniform int isEyeInWater;

out vec4 fragColor;
out vec4 fragMask;
out vec4 fragMaskColor;

#ifdef ENTITY
uniform vec4 entityColor;
#endif

uniform int renderStage;

varying float blockID;

void main() {
    vec4 albedo = texture2D(texture, texcoord) * glColor;

#ifdef ENTITY
    albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);
#endif

    if (albedo.a < 0.1) {
        discard;
    }

    float normalShading = 1.0;

#ifdef TERRAIN
    if (blockID != 1) {
#else
    if (true) {
#endif
        vec3 absN = abs(normal);
        float sideShading = absN.x * 0.6 + absN.z * 0.8;
        float verticalShading = (normal.y > 0.0) ? absN.y * 1.0 : absN.y * 0.5;
        normalShading = sideShading + verticalShading;
    }

    vec2 adjusted_lm = lmcoord * 0.9375 + 0.03125;
    vec3 light = texture2D(lightmap, adjusted_lm).rgb;

    float fog = (isEyeInWater>0) ? 1.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    if (isEyeInWater > 0){
        albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, fog);
    }

    vec4 color = vec4(albedo.rgb * light * normalShading, albedo.a);

    bool pixelate = true;

#ifdef NO_PIXELATE
    pixelate = false;
#endif

#ifdef IGNORE_PARTICLES
    if (renderStage == MC_RENDER_STAGE_PARTICLES) {
        pixelate = false;
    }
#endif

    if (pixelate) {
        fragColor = color;
        fragMaskColor = vec4(0.0);
        fragMask = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        fragColor = vec4(0.0);
        fragMaskColor = color;
        fragMask = vec4(0.0, 0.0, 1.0, 1.0);
    }

#ifdef HAND
    gl_FragDepth = 0;
#endif
}
