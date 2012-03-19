# Project settings ----------------------------------------------
OBJECTS=obj/$(TARGET)/main.o obj/$(TARGET)/pff.o obj/$(TARGET)/diskio.o
CFLAGS=-Os -std=gnu99 -Wall

ifeq ($(TARGET),TO8)
  CFLAGS += -DPLATFORM=8
else
ifeq ($(TARGET),MO5)
  CFLAGS += -DPLATFORM=5
else
# No target defined. Fail.
all: 
	echo "make TARGET=MO5 or make TARGET=TO8"
	false
endif
endif

# System settings -----------------------------------------------
PREFIX=m6809-thomson
CC=$(PREFIX)-gcc
AS=$(PREFIX)-as

# Generic rules -------------------------------------------------
# HFE  disk image (for HxC FE)
out_sap.hfe: out.sap
	hxcfloppyemulator_convert out.sap -HFE
	cp out_sap.hfe /mo5/MO5/
	unmount /mo5
	rm -r /mo5

# Disk Image
out.sap: TEST.BIN
	sapfs -c $@
	sapfs -a $@ $<

# Linking
TEST.BIN TEST.map: $(OBJECTS) TEST.script
	#$(CC) -v -Os $(OBJECTS) -o TEST.BIN -Wl,--map -Wl,-m -Wl,-Ttext,0x6100 -nostdlib -lgcc
	lwlink --decb $(OBJECTS) --output=TEST.BIN --map=TEST.map --script=TEST.script --library-path=/boot/home/config/lib/gcc/m6809-thomson/4.6.1 --library-path=/boot/home/config/m6809-thomson/lib -lgcc

#Compiling
obj/$(TARGET)/%.o: %.c obj/$(TARGET)
	$(CC) -save-temps $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: pff/%.c obj/$(TARGET)
	$(CC) $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: %.s obj/$(TARGET)
	$(AS) $< -o $@

# init
obj/$(TARGET):
	mkdir -p obj/$(TARGET)
