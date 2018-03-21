# Project settings ----------------------------------------------
OBJECTS=obj/$(TARGET)/main.o obj/$(TARGET)/pff.o obj/$(TARGET)/diskio.o
CFLAGS= -std=gnu99 -Wall

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
PREFIX=m6809-unknown
CC=$(PREFIX)-gcc
AS=$(PREFIX)-as
LIBPATH=/system/lib/x86/gcc/m6809-unknown/4.6.3/

# Generic rules -------------------------------------------------
# HFE  disk image (for HxC FE)
AUTOBOOT.HFE: out.sap
	saptofd out.sap
	hxcfe-x86 -finput:out.sap -conv:HXC_HFE -foutput:AUTOBOOT.HFE

# Disk Image
out.sap: TEST.BIN
ifeq ($(TARGET),MO5)
	cp DOS-MO.SAP $@
else
	cp AUTOBATO.SAP $@
endif
	sapfs -a $@ $<

# Linking
TEST.BIN TEST.map: $(OBJECTS) $(TARGET).script
	#$(CC) -v -Os $(OBJECTS) -o TEST.BIN -Wl,--map -Wl,-m -Wl,-Ttext,0x6100 -nostdlib
	lwlink --decb $(OBJECTS) --output=TEST.BIN --map=TEST.map --script=$(TARGET).script --library-path=$(LIBPATH) -lgcc

#Compiling
obj/$(TARGET)/%.o: %.c obj/$(TARGET)
	$(CC) -save-temps $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: pff/%.c obj/$(TARGET)
	$(CC) -save-temps $(CFLAGS) -c $< -o $@

obj/$(TARGET)/%.o: %.s obj/$(TARGET)
	$(AS) $< -o $@

# init
obj/$(TARGET):
	mkdir -p obj/$(TARGET)
