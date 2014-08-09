ALL=	raw2mo5 png2mo5


CC=gcc
CCFLAGS=-Os -W -Wall -g
#CCFLAGS=-O3 -W -Wall -pedantic -ansi

all: $(ALL)

clean :
	rm -f a.out *.o core $(ALL)
raw2mo5 : raw2mo5.o libraw2mo5.o
	$(CC) $(CCFLAGS) raw2mo5.o libraw2mo5.o -o raw2mo5
png2mo5 : png2mo5.o libraw2mo5.o
	$(CC) $(CCFLAGS) png2mo5.o libraw2mo5.o -o png2mo5 -lpng -lz
.c.o :
	$(CC) $(CCFLAGS) -c $<
