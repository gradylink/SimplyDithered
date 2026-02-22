#include "settings.glsl"

#ifdef IGNORE_SKY
#define NO_PIXELATE
#endif

#define SKY
#include "gbuffers_basic.fsh"
