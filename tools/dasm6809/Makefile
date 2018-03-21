##########################################################################
# targets:                                                               #
########################################################################## 


################
# object files #
################ 

OBJ_DIR =
OBJ_DASM = $(OBJ_DIR)6809dasm.o


##################
# compiler flags #
##################

CC = gcc

WFLAGS = -Wall -W

OFLAGS = -O2 

CFLAGS = $(WFLAGS) $(OFLAGS)


################
# target rules #
################

.PHONY: all install clean

all: 6809dasm

clean:
	rm -f 6809dasm $(OBJ_DIR)*.o

6809dasm: $(OBJ_DASM) 
	$(CC) -s -o 6809dasm $(OBJ_DASM)

$(OBJ_DIR)%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

