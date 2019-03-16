# Project settings ----------------------------------------------
OBJECTS=obj/$(TARGET)/main.o
CFLAGS= -std=gnu99 -Wall
CFLAGS += -DPLATFORM=8
TARGET=TO8

# System settings -----------------------------------------------
PREFIX=m6809-unknown
CC=$(PREFIX)-gcc-x86
AS=$(PREFIX)-as
LIBPATH=/system/lib/x86/gcc/m6809-unknown/4.6.4/

all: out.fd

# Generic rules -------------------------------------------------
# HFE  disk image (for HxC FE)
AUTOBOOT.HFE: out.fd
	hxcfe-x86 -finput:out.sap -conv:HXC_HFE -foutput:AUTOBOOT.HFE

# Disk Image
out.fd: out.sap
	saptofd out.sap
	cp out.fd /Git/Thomson/dcto8d/

out.sap: TEST.BIN
	sapfs -c $@
	sapfs -f $@
	sapfs -a $@ AUTO.BAT
	sapfs -a $@ E.BIN
	sapfs -a $@ $<

# Linking
TEST.BIN TEST.map: $(OBJECTS) $(TARGET).script
	#$(CC) -v -Os $(OBJECTS) -o TEST.BIN -Wl,--map -Wl,-m -Wl,-Ttext,0x6100 -nostdlib
	lwlink --decb $(OBJECTS) --output=TEST.BIN --map=TEST.map --script=$(TARGET).script --library-path=$(LIBPATH) -lgcc

#Compiling
obj/$(TARGET)/%.o: %.c obj/$(TARGET)
	$(CC) -save-temps $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: %.s obj/$(TARGET)
	$(AS) $< -o $@

# init
obj/$(TARGET):
	mkdir -p obj/$(TARGET)

