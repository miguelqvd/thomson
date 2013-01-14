# (likely) Needs GNU make

ifdef WINDIR
  # windows
  USBFLAGS = -I/local/include
  USBLIBS = -L/local/lib -lusb
  USBOBJS = device_libusb.o
  IUPFLAGS = -mthreads
  IUPLIBS = -lcomctl32 -lole32 -mthreads -mwindows
  EXE_SUFFIX = .exe
else
  ifdef BE_HOST_CPU
    # Haiku
    IUPFLAGS = -I/FileMate/Dev/tecgraf/iup/include/
    IUPLIBS=-L/FileMate/Dev/tecgraf/iup/lib/Haiku11/
    USBOBJS = device_bekit.o
    USBLIBS = -ldevice
  else
    # some unix
    USBFLAGS = $(shell libusb-config --cflags)
    USBLIBS = $(shell libusb-config --libs)
    USBOBJS = device_libusb.o
    IUPFLAGS = -I/usr/include/IUP/
  endif
  EXE_SUFFIX =
endif

CC		= g++
CPPFLAGS = $(USBFLAGS) -Os -Wall $(IUPFLAGS) -I/local/include -std=c++0x
LIBS = $(USBLIBS) -Os $(IUPLIBS) -liup -liupcontrols -liupcd -lcd -lfreetype -lz

PROJECT = CrO2
PROGRAM = $(PROJECT)$(EXE_SUFFIX)


all: $(PROGRAM)

$(PROGRAM): cro2.o device.o gui.o k5.o Tape.o zxtape.o $(USBOBJS)
	$(CC) -o $(PROGRAM) $^ $(LIBS)

strip: $(PROGRAM)
	strip $(PROGRAM)

clean:
	rm -f *.o $(PROGRAM)
