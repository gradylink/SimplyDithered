#include "settings.glsl"

#ifdef IGNORE_WEATHER
#define NO_PIXELATE
#endif

#define WEATHER
#include "gbuffers_textured.fsh"
