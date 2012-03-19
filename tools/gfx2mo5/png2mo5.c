/* GFX2mo5 - png2mo5.c
 * CloudStrife - 20080921
 * Diffusé sous licence libre CeCILL v2
 * Voir LICENCE
 */

#include <stdio.h>
#include <stdlib.h>
#include <png.h>
#include "libraw2mo5.h"

#include <assert.h>

#define ERROR 1

int main(int argc, char **argv)
{
  FILE *inFile, *outFile;
  unsigned char *inBuffer, *outBuffer;

  png_uint_32 width;
  png_uint_32 height;
  int bitdepth;
  int colorType;

  unsigned char header[8];
  unsigned char is_png;

  unsigned int y;
  png_structp png_ptr;
  png_infop info_ptr;
  png_infop end_info;

  png_bytep * ptrRow;
  unsigned char thomheader[] = {
  	// Block 1 : address A7C0, 1 byte, select FORME
	  0x00, 0x00, 0x01, 0xA7, 0xC0, 0x51,
	// Block 2 : address 0000, 1F40 bytes, FORME data
	  0x00, 0x1F, 0x40, 0x00, 0x00
  };


  // End marker block : type=255, size and address=0
  const unsigned char end[]={255,0,0,0,0};

  if(argc != 3) 
  {
    printf("Utilisation : %s input_filename output_filename\n",argv[0]);
    exit(0);
  }

  inFile = fopen(argv[1],"rb");

  if (inFile == NULL)
  {
    printf("Fichier Inexistant\n");
    exit(1);
  }

  fread(header, 1, 8, inFile);
  is_png = !png_sig_cmp(header, 0, 8);
  if (!is_png)
  {
    printf("Ce n'est pas un png\n");
    exit(2);
  }

  png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, (png_voidp)NULL, NULL, NULL);
  if (!png_ptr) return (ERROR);

  info_ptr = png_create_info_struct(png_ptr);
  if (!info_ptr)
  {
    png_destroy_read_struct(&png_ptr, (png_infopp)NULL, (png_infopp)NULL);
    return (ERROR);
  }

  end_info = png_create_info_struct(png_ptr);
  if (!end_info)
  {
    png_destroy_read_struct(&png_ptr, &info_ptr, (png_infopp)NULL);
    return (ERROR);
  }

  if (setjmp(png_jmpbuf(png_ptr)))
  {
    png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);
    fclose(inFile);
    return (ERROR);
  }

  png_init_io(png_ptr, inFile);
  png_set_sig_bytes(png_ptr, 8);

  png_read_info(png_ptr, info_ptr);

  png_get_IHDR(png_ptr, info_ptr, &width, &height, &bitdepth, &colorType, NULL, NULL, NULL);

  if(!((colorType == PNG_COLOR_TYPE_GRAY) || (colorType == PNG_COLOR_TYPE_PALETTE)))
  {
    puts("Ce PNG n'est pas dans un format exploitable (niveaux de gris ou palette)");
    return (ERROR);
  }

  if (bitdepth > 8)
      {
        puts("Ce PNG n'est pas dans un format exploitable (bitdepth = 1, 2 ou 4)");
        return (ERROR);
      }

  png_set_packing(png_ptr); /* Convertir en mode 1 pixel par octets */
  png_read_update_info(png_ptr, info_ptr);

  inBuffer = (unsigned char*)malloc(width*height);
  if (inBuffer == NULL)
  {
    printf("Allocation inBuffer raté\n");
    exit(3);
  }

  ptrRow = (png_bytep*)malloc(sizeof(png_bytep)*height);
  for(y = 0; y < height; y++)
  {
    ptrRow[y] = (inBuffer + width*y);
  }

  png_read_image(png_ptr, ptrRow);

  outBuffer = raw2mo5(inBuffer);

  int pxsize = width * height / 8;
  thomheader[7] = pxsize >> 8;
  thomheader[8] = pxsize;

  outFile = fopen(argv[2], "wb");
  fwrite(thomheader, 1, sizeof(thomheader), outFile);
  //write forme data
  fwrite(outBuffer, 1, pxsize, outFile);
  thomheader[5] = 0x50;
  fwrite(thomheader, 1, sizeof(thomheader), outFile);
  // write color data
  fwrite(outBuffer+0x2000, 1, pxsize, outFile);
  fwrite(end, 1, sizeof(end), outFile);


  fclose(outFile);

  png_read_end(png_ptr, end_info);
  png_destroy_read_struct(&png_ptr, &info_ptr, &end_info);

  free(inBuffer);
  inBuffer = NULL;

  free(outBuffer);
  outBuffer = NULL;

  return 0;
}
