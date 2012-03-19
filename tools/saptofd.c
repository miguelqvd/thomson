#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
	FILE *sap, *fd;
	int c, k, j;
	puts("sap2fd - Thomson diskimage converter\nPulkoMandy / Shinra - 2010\n"
		"wtfpl Licance\n");

	if (argc != 2) {
		printf("%s file.sap\n",argv[0]);
		exit(1);
	}

	if (strcasecmp(argv[1] + strlen(argv[1]) - 4,".sap")) {
		printf("%s is no sap\n",argv[1]);
		exit(2);
	}

	printf("Infile : %s\n",argv[1]);

	sap = fopen(argv[1], "rb");
	strcpy((argv[1] + strlen(argv[1]) - 4),".fd");
	fd = fopen(argv[1], "wb");

	printf("Outfile : %s\n",argv[1]);

	for (c = 0; c < 0x40; c++)
		getc(sap);

	k = 0;
	while((c=getc(sap)) != EOF) {
		if (k % 256 == 0)
			for (j = 0; j <= 5; j++) c = getc(sap);
		if (c == EOF) break;
		putc(c^0xB3,fd);	
		k++;
	}
	

	fclose(sap);
	fclose(fd);
}
