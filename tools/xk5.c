/*
 *  xk5 :
 *  Extraction des fichiers à partir d'un fichier K7 (format MO)
 *
 *  Copyright (c) 2011 Puls
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */


#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>

typedef enum { FALSE, TRUE } bool_t;

enum {
    E_CANT_READ_FILE = -100,
    E_CANT_WRITE_FILE,
    E_CHECKSUM,
    E_END_OF_CASSETTE ,
    E_READ_ERROR,
    E_MEMORY
};


static const struct {
    int   err;
    char  str[33];
  } elist [] = {
    { E_CANT_READ_FILE  ,"Cannot read file"        },
    { E_CANT_WRITE_FILE ,"Cannot write file"       },
    { E_CHECKSUM        ,"Checksum error"          },
    { E_END_OF_CASSETTE ,"End of cassette reached" },
    { E_READ_ERROR      ,"Read error"              },
    { E_MEMORY          ,"Memory error"            },
    { 0                 ,"Ok"                      }
};


static void
display_error (char *message, int err) {
    int i = 0;

    while ((err != elist[i].err) && (elist[i].err < 0))
        i++;
    (void)printf ("%s : %s\n", message, (char *)elist[i].str);
}


static void
clean_string (char *str) {
    int i;

    for (i=(int)strlen(str)-1; (i>=0)&&(str[i]<=' '); i--)
       str[i] = '\0';
}


static int
k5_read_byte (FILE *file, uint8_t *byte)
/*@globals errno@*/ {
    int err = 0;

    *byte = (uint8_t)fgetc (file);
    if (  feof (file) != 0) err = E_END_OF_CASSETTE;
    if (ferror (file) != 0) err = E_READ_ERROR;
    return err;
}


static int
k5_read_block (FILE *file, uint8_t *buf, uint8_t *size, uint8_t *type)
/*@globals errno@*/ {
    int err = 0;

    err = k5_read_byte (file, type);
    if (err == 0) {
        err = k5_read_byte (file, size);
        *size -= 2;
        if ((err == 0) && (*size != 0)) {
            if (fread (buf, 1, *size, file) != *size) {
                if (  feof (file) != 0) err = E_END_OF_CASSETTE;
                if (ferror (file) != 0) err = E_READ_ERROR;
            }
        }
    }
    return err;
}


static int
k5_search_gap (FILE *file)
/*@globals errno@*/ {
    int err = 0;
    uint8_t byte = 0;
    int count = 0;

    while ((count < 5) && (err == 0)) {
        err = k5_read_byte (file, &byte);
        if (byte == 0x01) count++; else count = 0;
    }
    return err;
}


static uint8_t
k5_checksum (uint8_t *buf, uint8_t size){
    uint8_t i;
    uint8_t checksum ;

    checksum = 0;
    for (i = 0; i < size; i++)
         checksum += buf[i];
    return -checksum;
}


static int
k5_find_block (FILE *file, uint8_t *buf, uint8_t *size, uint8_t *type, uint8_t *checksum)
/*@globals errno@*/ {
    int err = 0;
    uint8_t byte = 0;
    bool_t block_found = FALSE;
    
    while ((err == 0) && (block_found == FALSE)) {
        err = k5_search_gap (file);
        byte = 0x01;
        while ((err == 0) && (byte == 0x01))
            err = k5_read_byte (file, &byte);
        if ((err == 0) && (byte == 0x3c)) {
            err = k5_read_byte (file, &byte);
            if ((err == 0) && (byte == 0x5a)) {
                err = k5_read_block (file, buf, size, type);
           }
        }
        if (err == 0) {
            *checksum = (uint8_t)fgetc (file);
            if (ferror (file) != 0) err = E_READ_ERROR;
            else block_found = TRUE;
        }
    }
    return err;
}


static void
k5_pc_filename (uint8_t *buf, char *name) {
    char pc_name[9] = "";
    char pc_ext[4] = "";

    strncat (pc_name, (char *)buf, 8);
    strncat (pc_ext, (char *)buf+8, 3);
    clean_string (pc_name);
    clean_string (pc_ext);
    *name = '\0';
    (void)snprintf (name, 12, "%s.%s", pc_name, pc_ext);
}


static int
k5_searching (FILE *file, char *name)
/*@globals errno@*/ {
    int err = 0;
    uint8_t type = 0x01;
    uint8_t size = 0;
    uint8_t checksum = 0;
    uint8_t buf[255];

    memset (buf, 0x00, sizeof (&buf));
    while ((type != 0x00) && (err == 0)) {
        err = k5_find_block (file, buf, &size, &type, &checksum);
        if (err == 0) {
            if (checksum != k5_checksum (buf, size))
                err = E_CHECKSUM;
            k5_pc_filename (buf, name);
        }
    }
    return err;
}


static int
k5_fload (FILE *file, uint8_t *buf, size_t *index, char *name)
/*@globals errno@*/ {
    int err = 0;
    uint8_t type = 0x01;
    uint8_t size = 0;
    uint8_t checksum = 0;

    if ((file != NULL) && (buf != NULL)) {
        err = k5_searching (file, name);
        *index = 0;
        while ((type != 0xff) && (err == 0)) {
            err = k5_find_block (file, buf + *index, &size, &type, &checksum);
            *index += (size_t)size;
        }
    }
    return err;
}


static int
k5_extract (char *name)
/*@globals errno,stdout@*/ {
    static FILE /*@dependent@*//*@null@*/*file = NULL;
    static FILE /*@dependent@*//*@null@*/*fd_dest = NULL;
    uint8_t *buf = NULL;
    size_t size = 0;
    int err = 0;
    long int pos = 0;
    char dstName[20] = "";

    buf = (uint8_t*)calloc (1, 100000);
    if (buf != NULL) {
        file = fopen(name, "rb");
        if (file != NULL) {
            while (err == 0) {
                err = k5_fload (file, buf, &size, dstName);
                if (err == 0) {
                    pos = ftell (file);
                    (void)printf ("%07d '%s' (%d bytes)\n", (int)pos, dstName, (int)size);
                    fd_dest = fopen (dstName, "wb");
                    if (fd_dest != NULL) {
                        if (fwrite (buf, 1, size, fd_dest) != size)
                            err = E_READ_ERROR;
                        (void)fclose (fd_dest);
                    } else err = E_CANT_WRITE_FILE;
                }
            }
            (void)fclose (file);
        } else err = E_CANT_READ_FILE;
        free (buf);
    } else err = E_MEMORY;
    return err;
}


int
main(int argc, char *argv[])
/*@globals errno,stdout@*/ {
    char name[300+1] = "";

    if (argc != 2) {
        (void)printf ("   xk5 version 0.1 (c) oct 2011 Puls\n");
        (void)printf ("   Usage : xk5 <k5file>\n");
    } else {
        (void)snprintf (name, 300, "%s", argv[1]);
        clean_string (name);
        display_error (name, k5_extract (name));
    }
    return EXIT_SUCCESS;
}

