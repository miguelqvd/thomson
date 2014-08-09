/* GFX2mo5 - raw2mo5.c 
 * CloudStrife - 20080921
 * Diffusé sous licence libre CeCILL v2
 * Voire LICENCE
 */

#include <stdio.h>
#include <stdlib.h>
#include "libraw2mo5.h"

int main(int argc, char **argv)
{
  FILE *inFile, *outFile;
  unsigned char *inBuffer, *outBuffer;
  unsigned long inSize;

  unsigned short width;
  unsigned short height;
  unsigned char mode;

  if((argc != 6) && (argc != 7))
  {
    printf("Utilisation : %s input_filename output_filename width height mode [registre9]\n",argv[0]);
    printf("Exemple : Convertir une image en 176 sur 224 en mode 0 :\n");
    printf("%s image.raw image.scr 176 224 0\n",argv[0]);
    printf("Exemple : Convertir une image en 256 sur 128 en mode 1 avec R9 = 3 :\n");
    printf("%s image.raw image.scr 256 128 1 3\n",argv[0]);
    exit(0);
  }

  inFile = fopen(argv[1],"rb");

  sscanf(argv[3],"%hud",&width);
  sscanf(argv[4],"%hud",&height);
  sscanf(argv[5],"%hhud",&mode);
  if(mode > 3) printf("mode doit être compris entre 0 et 3");
  mode = mode & 3;

  if (inFile == NULL)
  {
    printf("Fichier Inexistant\n");
    exit(1);
  }

  fseek(inFile, 0, SEEK_END);
  inSize = ftell(inFile);
  rewind(inFile);

  if (inSize != (unsigned long)(width*height))
  {
    printf("Attention ! Mauvaise taille du fichier d'entré\n");
  }

  inBuffer = (unsigned char*)malloc(inSize);
  if (inBuffer == NULL)
  {
    printf("Allocation inBuffer raté\n");
    exit(3);
  }

  fread(inBuffer, 1, inSize, inFile);
  fclose(inFile);

  outBuffer = raw2mo5(inBuffer, 200, true, false);

  outFile = fopen(argv[2], "wb");
  fwrite(outBuffer, 1, 0x4000, outFile);
  fclose(outFile);

  free(inBuffer);
  inBuffer = NULL;

  free(outBuffer);
  outBuffer = NULL;

  return 0;
}
