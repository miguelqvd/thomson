# (likely) Needs GNU make

ifdef WINDIR
	# windows
USBFLAGS = -I/local/include
USBLIBS = -L/local/lib -lusb
EXE_SUFFIX = .exe
else
	# some unix
USBFLAGS = `libusb-config --cflags`
USBLIBS = `libusb-config --libs` #-framework CoreFoundation
EXE_SUFFIX =
endif

CC		= g++
CPPFLAGS = $(USBFLAGS) -Os -Wall -I/local/include -std=c++0x -mthreads
LIBS = $(USBLIBS) -Os -mwindows -liup -liupimglib -liupcontrols -liupcd -lcd \
	-lfreetype -lz -lcomctl32 -lole32 -mthreads

PROJECT = CrO2
PROGRAM = $(PROJECT)$(EXE_SUFFIX)


all: $(PROGRAM)

$(PROGRAM): $(PROJECT).o device.o gui.o k5.o Tape.o zxtape.o
	$(CC) -o $(PROGRAM) $^ $(LIBS)

strip: $(PROGRAM)
	strip $(PROGRAM)

clean:
	rm -f *.o $(PROGRAM)
