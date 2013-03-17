.SECONDARY:
all: obj/tracker.K5
	cp obj/tracker.K5 ../../../../mo5/dcmo5/software/tracker.K7

obj/tracker.bin:: obj/main.o obj/display.o obj/text.o obj/font_hs2.o obj/input.o

###############################################################################
CC=m6809-thomson-none-gcc
CFLAGS=-O3 -save-temps=obj -Wall -std=gnu99

obj/%.K5: obj/%.bin
	f2k5 $<
	mv FILE.K5 $@

obj/%.bin:
	lwlink --decb --output=$@ --map=$@.map --script=MO5.script $^

obj/%.o : %.c
	$(CC) $(CFLAGS) -I. -c -o $@ $^

obj/%.o: %.s
	lwasm -9 -fobj -o$@ $^
