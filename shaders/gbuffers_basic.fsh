#version 130

/* RENDERTARGETS: 0,1,2 */

uniform float blindness;
uniform int isEyeInWater;
varying vec4 color;

out vec4 fragColor;
out vec4 fragMask;
out vec4 fragMaskColor;

void main() {
    vec4 col = color;
    float fog = (isEyeInWater > 0) ? 1.0 - exp(-gl_FogFragCoord * gl_Fog.density) :
    clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0);

    if (isEyeInWater > 0) {
        col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);
    }

    col *= vec4(vec3(1.0 - blindness), 1.0);

#ifdef NO_PIXELATE
    fragColor = vec4(0.0);
    fragMaskColor = col;
    fragMask = vec4(0.0, 0.0, 1.0, 1.0);
#else
    fragColor = col;
    fragMaskColor = vec4(0.0);
    fragMask = vec4(0.0, 0.0, 0.0, 1.0);
#endif
}
