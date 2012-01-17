# (likely) Needs GNU make

ifdef WINDIR
	# windows
USBFLAGS = -I/usr/local/mingw/include
USBLIBS = -L/usr/local/mingw/lib -lusb
EXE_SUFFIX = .exe
else
	# some unix
USBFLAGS = `libusb-config --cflags`
USBLIBS = `libusb-config --libs` #-framework CoreFoundation
EXE_SUFFIX =
endif

CC		= gcc
CFLAGS	= $(USBFLAGS) -O -Wall -std=c99
LIBS	= $(USBLIBS)

PROJECT = CrO2
PROGRAM = $(PROJECT)$(EXE_SUFFIX)


all: $(PROGRAM)

.c.o:
	$(CC) $(CFLAGS) -c $<

$(PROGRAM): $(PROJECT).o
	$(CC) -o $(PROGRAM) $^ $(LIBS)

strip: $(PROGRAM)
	strip $(PROGRAM)

clean:
	rm -f *.o $(PROGRAM)
