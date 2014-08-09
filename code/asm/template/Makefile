LWTOOLS=/boot/apps/lwtools/bin/
ASM=$(LWTOOLS)lwasm -9 -b
SAPTOFD=$(LWTOOLS)saptofd
SAPFS=$(LWTOOLS)sapfs
PNG=$(LWTOOLS)png2mo5
F2K5=$(LWTTOLS)f2k5

all: floppy.sap FILE.K5
	$(SAPTOFD) floppy.sap
	cp floppy.fd FILE.K5 ../../dcmo5/software/
	cd ../../dcmo5 && ./dcmo5

FILE.K5: AUTO.BIN
	$(F2K5) $^

floppy.sap: AUTO.BIN TEST.PIC
	$(SAPFS) -c floppy.sap
	$(SAPFS) -a floppy.sap AUTO.BIN
	$(SAPFS) -a floppy.sap TEST.PIC

AUTO.BIN: main.asm
	$(ASM) main.asm -o AUTO.BIN

TEST.PIC: test.png
	$(PNG) test.png TEST.PIC
