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

CC		= g++
CPPFLAGS	= $(USBFLAGS) -O -Wall -I/usr/include/IUP/ -g
LIBS	= $(USBLIBS) -L/usr/lib/ -mwindows -liup -lcomctl32 -lole32

PROJECT = CrO2
PROGRAM = $(PROJECT)$(EXE_SUFFIX)


all: $(PROGRAM)

$(PROGRAM): $(PROJECT).o device.o gui.o k5.o
	$(CC) -o $(PROGRAM) $^ $(LIBS)

strip: $(PROGRAM)
	strip $(PROGRAM)

clean:
	rm -f *.o $(PROGRAM)
