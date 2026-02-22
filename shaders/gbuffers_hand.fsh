#include "settings.glsl"

#ifdef IGNORE_HAND
#define NO_PIXELATE
#endif

#define HAND
#include "gbuffers_textured.fsh"
