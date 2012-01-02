# Project settings ----------------------------------------------
OBJECTS=obj/$(TARGET)/main.o obj/$(TARGET)/pff.o obj/$(TARGET)/diskio.o
CFLAGS=-Os -std=gnu99 -Wall

ifeq ($(TARGET),TO8)
  CFLAGS += -DPLATFORM=8
endif

ifeq ($(TARGET),MO5)
  CFLAGS += -DPLATFORM=5
endif

# System settings -----------------------------------------------
CC=m6809-thomson-none-gcc
AS=m6809-thomson-none-as

# Generic rules -------------------------------------------------
# HFE  disk image (for HxC FE)
out_sap.hfe: out.sap
	hxcfloppyemulator_convert out.sap -HFE

# Disk Image
out.sap: TEST.BIN
	sapfs -c $@
	sapfs -a $@ $<

# Linking
TEST.BIN: $(OBJECTS)
	$(CC) -Os $(OBJECTS) -o TEST.BIN -Wl,--map -Wl,-Ttext,0x7100 -nostdlib -lgcc

#Compiling
obj/$(TARGET)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: pff/%.c
	$(CC) $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: %.s
	$(AS) $< -o $@
