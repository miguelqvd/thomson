.SECONDARY:
all: obj/main.K5

CC=m6809-thomson-none-gcc
CFLAGS=-O2 -fomit-frame-pointer -save-temps=obj -Wall -Werror -std=gnu99

obj/main.bin:: obj/plasma_asm.o obj/plasma.o obj/twister.o obj/trig.o obj/picture.o obj/greetings.o obj/text.o obj/font_hs2.o obj/poiscaie.o obj/waves.o

obj/BIGTHOM.PIC: BGCOLOR = 0

obj/%.bin: obj/%.o
	lwlink --decb --output=$@ --map=$@.map --script=MO5.script $^

obj/trig.o: ../libdemo/trig.c
	$(CC) $(CFLAGS) -I../F14 -c -o $@ $^

###

obj/%.PIC : %.png
	png2mo5 $< $@ $(BGCOLOR)

obj/%.o : %.c
	$(CC) $(CFLAGS) -I. -c -o $@ $^

obj/%.o: %.s
	lwasm -9 -fobj -o$@ $^

obj/%.K5: obj/%.bin
	f2k5 $<
	mv FILE.K5 $@

