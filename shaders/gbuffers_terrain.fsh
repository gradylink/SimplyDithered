#include "settings.glsl"

#ifdef IGNORE_TERRAIN
#define NO_PIXELATE
#endif

#define TERRAIN
#include "gbuffers_textured.fsh"
