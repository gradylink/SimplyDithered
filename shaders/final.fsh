#version 130

/* RENDERTARGETS: 0 */

varying vec2 texCoord;
uniform sampler2D gcolor;
uniform sampler2D colortex1;
uniform sampler2D colortex2;

#include "settings.glsl"

// #define DEBUG_DEPTH
// #define DEBUG_COLORTEX1

uniform float viewWidth;
uniform float viewHeight;

uniform sampler2D depthtex0;

float getDither(vec2 pos) {
    int x = int(mod(pos.x, 4.0));
    int y = int(mod(pos.y, 4.0));
    int index = x + y * 4;

    if (index == 0) return 0.0625; if (index == 1) return 0.5625; if (index == 2) return 0.1875; if (index == 3) return 0.6875;
    if (index == 4) return 0.8125; if (index == 5) return 0.3125; if (index == 6) return 0.9375; if (index == 7) return 0.4375;
    if (index == 8) return 0.25;   if (index == 9) return 0.75;   if (index == 10) return 0.125; if (index == 11) return 0.625;
    if (index == 12) return 1.0;   if (index == 13) return 0.5;   if (index == 14) return 0.875; if (index == 15) return 0.375;
    return 0.0;
}

float getNoise(vec2 pos) {
    return fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    float depth = texture2D(depthtex0, texCoord).r;

#ifdef DEBUG_COLORTEX1
    gl_FragData[0] = texture2D(colortex1, texCoord);
    return;
#endif

#ifdef DEBUG_DEPTH
    gl_FragData[0] = vec4((vec3(depth) - 0.9) * 100, 0.0);
    return;
#endif

    vec3 mask = texture2D(colortex1, texCoord).rgb;

#ifndef SQUARE_PIXELS
    vec2 size = vec2(PIXEL_SIZE);
#else
    float aspect = viewWidth / viewHeight;
    vec2 size = vec2(PIXEL_SIZE * aspect, PIXEL_SIZE);
#endif

    vec2 customTexCoord = texCoord * size;
    vec2 localCoord = fract(customTexCoord) - 0.5;
    vec2 startCoord = floor(customTexCoord) / size;

#if SAMPLING_MODE == 0
    vec3 color = texture2D(gcolor, startCoord).rgb;
#else
    vec2 endCoord = ceil(texCoord * size) / size;

    float realPixelsX = viewWidth / size.x;
    float realPixelsY = viewHeight / size.y;

    vec3 sum = vec3(0.0);
    float samples = 0.0;

    for(float x = 0.0; x < realPixelsX; x += SAMPLE_STEP) {
        for(float y = 0.0; y < realPixelsY; y += SAMPLE_STEP) {
            vec2 offset = vec2(x / viewWidth, y / viewHeight);
            sum += texture2D(gcolor, startCoord + offset).rgb;
            samples++;
        }
    }

    vec3 color = sum / max(samples, 1.0);
#endif

    float squareDist = max(abs(localCoord.x), abs(localCoord.y)) * 2.0;
    float circleDist = length(localCoord) * 2.0;
    float shapeDict = mix(squareDist, circleDist, PIXEL_ROUNDNESS);

    float levels = max(COLOR_LEVELS, 2.0);
    float offset = 0.5;

    if (COLOR_LEVELS == -1.0) {
        float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
        color = vec3(luminance);
        levels = 2.0;
        offset = 1.0 - MONO_THRESHOLD;
    }

    float range = levels - 1.0;
    float stepSize = 1.0 / range;

    color = (color - 0.5) * CONTRAST + 0.5;

    float gray = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(gray), color, SATURATION);

#if DITHER_MODE == 0
    float dither = getDither(floor(customTexCoord));
#else
    float dither = getNoise(floor(customTexCoord));
#endif

    color += (dither - 0.5) * stepSize * DITHER_STRENGTH;

    color = floor(color * range + offset) / range;

    if (shapeDict > 1.0 - GRID_GAP) {
        color = vec3(0.0); // TODO: Make customizable somehow
    }

    if (mask.g > 0.5 || mask.b > 0.5) {
        vec4 maskColor = texture2D(colortex2, texCoord);

        vec3 srcColor = maskColor.rgb;
        if (maskColor.a > 0.0) srcColor /= maskColor.a;

        color = mix(color, srcColor, maskColor.a);
    }

#ifdef CRT_SCANLINES
    float scanline = sin(gl_FragCoord.y * 1.5) * CRT_STRENGTH;
    color.rgb *= (1.0 - abs(scanline));
#endif

#ifdef VIGNETTE
    vec2 vTexCoord = (texCoord - 0.5) * 2.0;
    float dist = dot(vTexCoord, vTexCoord);
    float vignette = 1.0 - (dist * VIGNETTE_STRENGTH * 0.5);

    color.rgb *= clamp(vignette, 0.0, 1.0);
#endif

    gl_FragData[0] = vec4(color, 1.0);
}
