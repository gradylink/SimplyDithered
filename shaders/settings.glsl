#define PIXEL_SIZE 256.0 // [16.0 32.0 64.0 128.0 192.0 256.0 384.0 512.0]
#define SAMPLING_MODE 1 // [0 1] // Sampling Mode: Single Pixel, Average
#define SAMPLE_STEP 6.0 // [1.0 2.0 4.0 6.0 8.0]
#define DITHER_STRENGTH 1.0 // [0.0 0.1 0.2 0.5 0.75 1.0]
#define COLOR_LEVELS 8.0 // [-1.0 2.0 4.0 8.0 16.0 32.0 64.0 128.0 256.0]
#define MONO_THRESHOLD 0.7 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]
#define SQUARE_PIXELS
#define PIXEL_ROUNDNESS 0.0 // [0.0 0.2 0.4 0.6 0.8 1.0]
// #define CLEAR_LINES
#define LINE_THICKNESS -1.0 // [-1.0 1.0 1.5 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0]
#define GRID_GAP 0.00 // [0.00 0.05 0.10 0.15 0.20 0.25 0.30 0.35 0.40 0.45 0.50]
#define DITHER_MODE 0 // [0 1] // Dither Mode: Bayer, Noise
#define CONTRAST 1.0 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define SATURATION 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

// #define CRT_SCANLINES
#define CRT_STRENGTH 0.3 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// #define VIGNETTE
#define VIGNETTE_STRENGTH 0.5 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

// #define IGNORE_HAND
// #define IGNORE_ENTITIES
// #define IGNORE_CLOUDS
// #define IGNORE_PARTICLES
// #define IGNORE_WATER
// #define IGNORE_TERRAIN
// #define IGNORE_SKY
// #define IGNORE_WEATHER

// Because I always use defined(CLEAR_LINES) || defined(IGNORE_TERRAIN) and Iris doesn't know how to handle that.
#ifdef CLEAR_LINES
#endif
