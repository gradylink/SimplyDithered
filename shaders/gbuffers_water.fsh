#include "settings.glsl"

#ifdef IGNORE_WATER
#define NO_PIXELATE
#endif

#define WATER
#include "gbuffers_textured.fsh"
