/* GFX2mo5 - libraw2mo5.h
 * CloudStrife - 20080921
 * Copyright 2019, Adrien Destugues <pulkomandy@pulkomandy.tk>
 * Diffusé sous licence libre CeCILL v2
 * Voir LICENCE
 */

#include <stdbool.h>

#ifndef LIBRAW2mo5_H
#define LIBRAW2mo5_H 1

/* Convert picture to MO5/TO7/"40 columns" format (320x200, 16 colors, 8x1 blocks) */
unsigned char * raw2mo5(unsigned char *input, int height, int fixup, bool to);

/* Convert picture to "direct bitmap 16" format (160x200, 16 colors) */
unsigned char * raw2bm16(unsigned char *input, int height);

/* Convert picture to "direct bitmap 4" format (320x200, 4 colors) */
unsigned char * raw2bm4(unsigned char *input, int height);

#endif
