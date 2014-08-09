** Traitement des fichiers et du DISK **

       FCC    "Hunks  Exec   "
HUNKS  JSR    FILPOS
       LDA    #11     Bad File Mode
       LDB    11,X    Type du fichier:
       CMPB   #2      langage machine
       LBNE   ERROR
       LDB    12,X    Sémaphore:binaire
       LBNE   ERROR
       LDD    14,X    nb octets dans le
       STD    <BYLASE  dernier secteur
       LDB    13,X    1er bloc ds la FAT
       STB    <FATPTR
       LDX    #FAT+1  ce pointeur est-il
       LDB    B,X          cohérent
       CMPB   #$A0
       BLO    H1FTOK
       LDA    #9      Bad File Structure
       SUBB   #$C1
       CMPB   #7
       LBHI   ERROR
H1FTOK CLR    <LASTBK dernier bloc? FAUX
       CLR    <LASTSC   "" secteur? FAUX
       LDX    #IOZONE
       STX    <DKBUF
       JSR    LPOSFT   1er bloc fichier
       JSR    HNXSEC
       LDA    #40      affiche "Hunks  "
       LDU    #HUNKS-14
       LDB    ,U+
       JSR    PUTC
       DECA
       CMPA   #33
       BNE    *-8
       JSR    PUTC
       DECA
       BNE    *-4
       LDU    <CURSOR
       LEAU   -313,U
       STU    <CURSOR
       LDD    #$718
       STA    <XPOS
       STB    <CMPT+1

HDGON  LDU    #IODESC
       LDY    #5
       JSR    LVIDBF
       LDY    IODESC+1  nombre d'octets
       LDU    IODESC+3   adresse début
       LDA    IODESC
       BNE    EOHNK   code <>0 = EOfile
       TFR    U,D
       JSR    DA2HEX
       TFR    B,A
       JSR    DA2HEX
       LDB    #'-
       JSR    PUTC
       LDB    #'>
       JSR    PUTC
       TFR    Y,D
       SUBD   #1
       LEAU   D,U
       TFR    U,D
       JSR    DA2HEX
       TFR    B,A
       JSR    DA2HEX
       LDA    <XPOS
       CMPA   #20
       BLO    AFHNK2
       DEC    <CMPT+1
       BNE    HFPAUS
       JSR    GETC
       BCC    *-3
       CMPB   #2
       BEQ    HVIDBF-1
       LDA    #24
       STA    <CMPT+1
HFPAUS LDD    #$3320
       JSR    PUTC
       DECA
       BNE    *-4
       LDU    <CURSOR
       LEAU   -313,U
       STU    <CURSOR
       LDA    #7
       STA    <XPOS
       BRA    EOHNK-8
AFHNK2 LDB    #32
       JSR    PUTC
       JSR    PUTC
       LDU    IODESC+3
       BSR    HVIDBF
       JMP    HDGON
EOHNK  LDA    #9      Bad File Structure
       LEAX   -IOZONE,X nombre d'octets
       CMPX   <BYLASE   dans le dernier
       LBNE   ERROR        secteur
       LDA    <XPOS
       CMPA   #10
       BHI    EOHNK2
       LDU    <CURSOR
       LEAU   -7,U
       STU    <CURSOR
       CLR    <XPOS
       BRA    EOHNK3
EOHNK2 LDB    #32
       JSR    PUTC
       LDA    <XPOS
       BNE    *-5
EOHNK3 LDA    #7
       LDU    #HUNKS-7
       LDB    ,U+
       JSR    PUTC
       DECA
       BNE    *-6
       LDD    IODESC+3
       JSR    DA2HEX     d'exécution
       TFR    B,A
       JSR    DA2HEX
       LDB    #32
       JSR    PUTC
       LDA    <XPOS
       BNE    *-5
       RTS

HVIDBF LEAX   1,X     vide le buffer I/O
       CMPX   #IOZONE+255 fin buffer ?
       BNE    *+8
       LDB    <LASTSC fin dernier sector
       BNE    HNXSEC-1  -> fin fichier
       BSR    HNXSEC
       LEAY   -1,Y    fin transfert ?
       BNE    HVIDBF
       RTS

HNXSEC JSR    DISK
       INC    <DKSEC  secteur suivant
       DEC    <CMPT    fin du bloc ?
       LBNE   LNXSCF
       LDB    <LASTBK  dernier bloc lu
       LBEQ   LPOSFT  ->pas de suivant!
       STB    <LASTSC
       JMP    LNXSCF   dernier secteur

LOADM  JSR    FILPOS
       LDA    <FILETY
       BNE    IGFITY
       LDB    11,X    Type du fichier:
       CMPB   #2      langage machine
       BNE    *+6
       LDB    12,X    Sémaphore:binaire
       BEQ    *+7
        LDA   #11     Bad File Mode
        JMP   ERROR
IGFITY LDU    14,X    nb octets dans le
       STU    <BYLASE  dernier secteur
       LDB    13,X    1er bloc ds la FAT
       STB    <FATPTR
       LDX    #FAT+1  ce pointeur est-il
       LDB    B,X          cohérent
       CMPB   #$A0
       BLO    L1FTOK
       SUBB   #$C1
       CMPB   #8
       BLO    *+7
        LDA   #9      Bad File Structure
        JMP   ERROR
L1FTOK CLR    <LASTSC   "" secteur? FAUX
       CLR    <LASTBK dernier bloc? FAUX
       LDX    #IOZONE
       STX    <DKBUF
       BSR    LPOSFT   1er bloc fichier
       LDA    <FILETY
       BEQ    RILODM
       LDU    <LSHIFT début du buffer
       LDY    <FILSIZ taille+1 du buffer
       BSR    LNXSEC
       LEAY   -1,Y
       BRA    LVIDBF
RILODM BSR    LNXSEC

LDGON  LDU    #IODESC
       LDY    #5
       BSR    LVIDBF
       LDY    IODESC+1  nombre d'octets
       LDU    IODESC+3   adresse début
       LDD    <LSHIFT
       LEAU   D,U     +décalage
       LDA    IODESC
       BNE    EOLOD   code <>0 = EOfile
       BSR    LVIDBF
       BRA    LDGON
EOLOD  LDA    #9      Bad File Structure
       LEAX   -IOZONE,X nombre d'octets
       CMPX   <BYLASE   dans le dernier
       LBNE   ERROR        secteur
       LDD    IODESC+3
       LDU    #OPGJSR-4    adresse
       JSR    ATOHEX     d'exécution
       TFR    B,A
       JMP    ATOHEX

LVIDBF LDB    ,X+     vide le buffer I/O
       STB    ,U+       vers la mémoire
       CMPX   #IOZONE+255 fin buffer ?
       BNE    *+8
       LDB    <LASTSC fin dernier sector
       BNE    LNXSEC-1  -> fin fichier
       BSR    LNXSEC
       LEAY   -1,Y    fin transfert ?
       BNE    LVIDBF
       RTS

LNXSEC JSR    DISK
       INC    <DKSEC  secteur suivant
       DEC    <CMPT    fin du bloc ?
       BNE    LNXSCF
       LDB    <LASTBK  dernier bloc lu ?
       BEQ    LPOSFT  NON:prépare suivnt
       STB    <LASTSC OUI:c'est donc le
       LDB    <FILETY   dernier secteur
       BEQ    LNXSCF  que l'on vient de
       CMPY   <BYLASE
       BLS    LNXSCF
       LDY    <BYLASE    charger ...
       LEAY   1,Y
       BRA    LNXSCF  (->taille si !BIN)

LPOSFT LDX    #FAT+1
       LDB    <FATPTR
       ABX
       LDA    <FATPTR
       LDB    #1        Piste/Secteur
       LSRA           d'après No du bloc
       BCC    *+4
       ADDB   #8
       STD    <DKTRK
       LDB    ,X      "libère" le bloc
       LDA    #-1     que l'on va lire
       STA    ,X
       CMPB   #$A0    à quoi ressemble
       BHS    *+8     le bloc que l'on
       TFR    B,A     va lire ?
       LDB    #8      (nombre secteurs,
       BRA    LRBFTF  fin de chaîne...?)
       SUBB   #$C1
       CMPB   #7
       BHI    LDBKER
       INCB             on va lire le
       STA    <LASTBK   dernier bloc.
LRBFTF STB    <CMPT   nombre de secteurs
       STA    <FATPTR
LNXSCF LDX    #IOZONE
       RTS
LDBKER LDA    #9      Bad File Structure
       JMP    ERROR

KILLM  JSR    FILPOS  trouve le fichier
       JSR    KILFAT  modifie FAT et DIR
       LDB    #2
       STB    <DKOPC  commande WRITE
       JSR    DISK    ré-écriture du DIR
       LDX    #FAT
       STX    <DKBUF
       STB    <DKSEC
       JMP    DISK    écriture de la FAT

FILPOS CLR    <DKOPC  opération READ
       LDD    #$1402
       STD    <DKTRK
       LDX    #FAT
       STX    <DKBUF
       JSR    DISK    charge la FAT
       LDX    #CATALG
       STX    <DKBUF
       LDA    #3
READIR STA    <DKSEC
       JSR    DISK    charge directory
       LDX    #CATALG
DIRCMP PSHS   X,A
       LDU    #FILNAM
       LDA    #11
       LDB    ,X+
       CMPB   ,U+
       BNE    *+5
       DECA
       BNE    *-7
       PULS   A,X
       BEQ    EOSDIR  oui:stop recherche
       LDB    ,X
SRDIR1 CMPB   #$FF     fin du catalogue
       BEQ    FLNTFD
       LEAX   32,X
       CMPX   #CATALG+256
       BLO    DIRCMP
       INCA
       CMPA   #17
       BLO    READIR
FLNTFD  LDA   #10     File Not Found
        JMP   ERROR
EOSDIR RTS


SAVEM  LDA    <FILETY
       LDY    #1
       LDX    <FILSIZ
       CMPA   #2
       BNE    QTBLCK
       LEAX   10,X     nombre de blocs
QTBLCK CMPX   #255    requis au total =
       BLO    SVRDFT  (5+taille+5)/255
       LEAY   1,Y
       LEAX   -255,X
       BRA    QTBLCK
SVRDFT LDX    #$1402
       STX    <DKTRK
       LDX    #FAT
       STX    <DKBUF
       CLR    <DKOPC
       JSR    DISK    charge la FAT
       LDB    ,X+
       BNE    ANAFAT-5
       LDD    40,X
       CMPD   #$FEFE
       BEQ    *+7
        LDA   #6      bad FAT structure
        JMP   ERROR
ANAFAT LDB    ,X+
       CMPB   #$FF
       BNE    *+6
       LEAY   -1,Y    nombre de blocs --
       BEQ    PLAFOK
       CMPB   #$FE
       BHS    EANFAT
       CMPB   #$A0
       BLO    EANFAT
       SUBB   #$C1
       CMPB   #8
       BLO    EANFAT
        LDA   #6      bad FAT structure
        JMP   ERROR   [0-9F][C1-C8]FE,FF
EANFAT CMPX   #FAT+161
       BLO    ANAFAT
        LDA   #7      disk full
        JMP   ERROR
PLAFOK LDX    #CATALG
       STX    <DKBUF
       CLR    <DIRSEC
       LDA    #3
RDIRNX STA    <DKSEC
       LDX    <DKBUF
       LEAU   256,X
       STU    SRPLDF+4
       JSR    DISK    charge directory
SRPLDR PSHS   X,A        le fichier
       LDU    #FILNAM  à sauver existe
       LDA    #11          déjà ?
       LDB    ,X+
       CMPB   ,U+
       BNE    *+5
       DECA
       BNE    *-7
       PULS   A,X
       BNE    *+7     non:analyse suiv..
       JSR    KILFAT  oui: le détruit et
       BRA    PLADF1   arrête l'analyse
       LDB    ,X
       BNE    SRPLD1
       LDB    <DIRSEC entrée libre:1ère?
       BNE    SRPLDF
       STA    <DIRSEC
       STX    <DIRPTR
       LDU    #IOZONE
       STU    <DKBUF
       BRA    SRPLDF
SRPLD1 CMPB   #$FF    fin du catalogue
       BEQ    PLADFD
SRPLDF LEAX   32,X
       CMPX   #CATALG+256 !! est modifié
       BLO    SRPLDR
       INCA
       CMPA   #17
       BLO    RDIRNX
       LDB    <DIRSEC
       BNE    PLADF1
        LDA   #8      directory full
        JMP   ERROR
PLADFD LDB    <DIRSEC
       BEQ    PLADF1
       LDA    <DIRSEC
       LDX    <DIRPTR
PLADF1 STA    <DIRSEC
       CMPX   #IOZONE
       BLO    PLADF2
       LEAX   -256,X
       CLRA
       LDU    #CATALG
       LDY    #IOZONE
       LDB    ,Y+
       STB    ,U+
       DECA
       BNE    *-5
PLADF2 STX    <DIRPTR

       LDD    #1
       STD    <DKTRK
       LDA    #2      opération WRITE
       STA    <DKOPC
       LDD    <EXEADR
       STD    IODESC+3
       LDD    #$FF00
       STD    IODESC
       STB    IODESC+2
       LDA    #1        1er secteur
       STA    <FATPTR se positionne sur
       JSR    SPOSFT  le 1er bloc libre
       LDB    <FATPTR
       SUBB   #2      Numéro du 1er bloc
       STB    13,X    logique du fichier
       LDX    #IOZONE
       STX    <DKBUF

       LDY    <FILSIZ
       LDU    <BEGADR
       LDB    <FILETY
       CMPB   #2
       BNE    NOSHNK
       CLR    ,X+
       STY    ,X++    longueur à écrire
       STU    ,X++
       LDB    <IMABNK si c'est une image
       BMI    *+6     MAP, le début est
       CLR    -1,X    en fait $000 dans
       CLR    -2,X    le fichier !!!
NOSHNK CLR    IOZONE+255
       LDB    #8      secteurs par bloc
       STB    <CMPT

       BSR    CPNSAV  sauve le programme
       LDB    <FILETY
       CMPB   #2
       BNE    NOEHNK
       CMPX   #IOZONE+255
       BNE    *+4     si fin buffer I/O,
       BSR    SVNXTS  avance d'1 secteur
       LDU    #IODESC
       LDY    #5
       BSR    CPNSAV  sauve terminateur
NOEHNK CMPX   #IOZONE+255
       BEQ    *+5      si pas déja fait,
       JSR    DISK     sauve buffer I/O
       LEAY   -IOZONE,X    nombre octets
       LDX    #FAT        utilisés dans
       LDB    <FATPTR le dernier secteur
       ABX
       LDB    <DKSEC  nombre de secteurs
       CMPB   #9       utilisés dans le
       BLO    *+4        dernier bloc
       SUBB   #8
       ADDB   #$C0
       STB    -1,X
       BRA    BLKTRV+2
IODESC FCB    $FF,0,0,00,00

CPNSAV LDB    ,U+     remplit buffer I/O
       STB    ,X+
       CMPX   #IOZONE+255
       BLO    *+4
       BSR    SAVSEC
       LEAY   -1,Y
       BNE    CPNSAV
       RTS
SAVSEC JSR    DISK    écrit un secteur
       CMPY   #1
       BEQ    SNXTSF+3
SVNXTS INCA             passe au secteur
       CMPA   #17           suivant
       BLO    *+6
       INC    <DKTRK
       LDA    #1
       STA    <DKSEC
       DEC    <CMPT   8 secteurs / bloc
       BNE    SNXTSF
       LDB    #8
       STB    <CMPT
       LDX    #FAT
       LDB    <FATPTR Prec=Courant
       ABX
       BSR    SPOSFT  nouveau Courant
       LDB    <FATPTR
       SUBB   #2
       STB    -1,X    Prec->Suiv=Courant
SNXTSF LDX    #IOZONE
       RTS
SPOSFT PSHS   X
       LDX    #FAT
       LDB    <FATPTR
       ABX
SRBKFT LDB    ,X+     se positionne sur
       INC    <FATPTR  le bloc libre
       CMPB   #$FF        suivant
       BEQ    BLKTRV
       ADDA   #8
       CMPA   #17
       BLO    *+6
       INC    <DKTRK
       LDA    #1
       STA    <DKSEC
       BRA    SRBKFT
BLKTRV PULS   X,PC

       LDX    <DIRPTR  suite & fin de la
       LDU    #FILNAM     sauvegarde
       LDA    #11
       LDB    ,U+       copie du nom
       STB    ,X+      et du suffixe
       DECA
       BNE    *-5
       LDD    <FILETY Type du fichier:
       STA    ,X+      langage machine
       STB    ,X++    Sémaphore: binaire
       STY    ,X++    Nb octets dans le
       LDA    #8       dernier secteur
       LDB    ,U+
       STB    ,X+     copie commentaire
       DECA
       BNE    *-5
       LDD    #8
       STA    ,X+     18 à 1F : réservé
       DECB
       BNE    *-3

       LDD    #$1402
       STD    <DKTRK
       LDX    #FAT
       STX    <DKBUF
       JSR    DISK
       LDB    <DIRSEC
       STB    <DKSEC
       LDX    #CATALG
       STX    <DKBUF
       JMP    DISK

KILFAT PSHS   X,A
       CLR    ,X
       LDB    13,X    1er bloc ds la FAT
       LDX    #FAT+1
       ABX
       LDA    #$FF
       LDB    ,X
       STA    ,X
       CMPB   #$A0
       BLO    KILFAT+6  détruit chaînage
       SUBB   #$C1
       CMPB   #7
       BHI    *+4
       PULS   A,X,PC
        LDA   #9      Bad File Structure

ERROR  LDB    #24
       MUL
       LDU    #ERRTXT-24
       LEAU   D,U
       LDA    <IMABNK
       BMI    STDERR
       PSHS   U,A
       LDA    $E7C3
       ANDA   #254
       STA    $E7C3
       JSR    VW2BNK
       LDX    #NULL
       JSR    SETPAL
       CLR    >$E7DC
       JSR    FABSCR
       PULS   A,U
       STA    $E7E5
STDERR LDX    #$4000+192*40
       CLR    ,X+
       CMPX   #$5F40
       BNE    *-5
       LDX    #SCREEN+8+24*320
       STX    <CURSOR
       LDD    #$1808
       STB    <XPOS
       LDX    #SCREEN+25*320
       STX    <BOTTOM
       CLR    <CLIGNO
       LDB    ,U+
       JSR    PUTC     affiche l'erreur
       DECA
       BNE    *-6
       JSR    GETC
       TSTB
       BEQ    *-4      attente clavier
       LDX    ,S
       CMPX   #ERRET1   dépile tout et
       BEQ    *+6       retour au menu
       LEAS   1,S       (fin d'option)
       BRA    *-9
       CLRA
       JMP    HWINDW

ERRTXT FCC    "        No Disk         "
       FCC    "       Bad Sector       "
       FCC    "     Timing Failure     "
       FCC    "    Unreadable Datas    "
       FCC    "  Disk Write Protected  "
       FCC    "   Bad FAT Structure    "
       FCC    "       Disk Full        "
       FCC    "     Directory Full     "
       FCC    "   Bad File Structure   "
       FCC    "     File Not Found     "
       FCC    "     Bad File Type      "
       FCC    " Uncompressible Picture "
       FCC    "  No Gadget Installed   "

FILNAM FCC    "FILENAMEBINcomments"
DISK   PSHS   U,Y,X,B,A initialisations
       LDX    #$E7D0
       LDA    #$41
       TST    <DKDRV  sélection du drive
       BEQ    *+4
       LDA    #1
       STA    2,X
       STA    <DKTMP
       LDU    #DKOPER
       LDB    <DKOPC
       JSR    [B,U]
       PSHS   CC
       CLR    ,X
SORTIE LDB    #$40     sortie
       STB    2,X
       PULS   CC
       LBNE   ERROR
       PULS   A,B,X,Y,U,PC
DKOPER FDB    READ,WRITE

       RTS
READ   JSR    POSPIS
       BNE    READ-1  bad positionnement
       JSR    COMPEN
       LDB    #$1B
       JSR    POSSEC
       LDA    #4
       LDY    #$7500
RDTRY1 LEAY   -1,Y
       BNE    *+5
        LDA   #2        identificateur
        RTS               incorrect
       LDB    ,X
       BITB   #2
       BEQ    RDTRY1
       LDB    3,X
RDTRY2 DECA
       BNE    *+5
        LDA   #3
        RTS           problème de timing
       LDB    ,X
       BPL    *-2
       LDB    3,X
       CMPB   #$FB
       BNE    RDTRY2
       LDY    #256
LIT    LDB    ,X      lecteur prêt ?
       BPL    *-2
       LDB    3,X
       STB    ,U+
       LEAY   -1,Y
       BNE    LIT
       LDB    ,X
       BITB   #8      opération finie ?
       BEQ    *-4
       BITB   #4
       BEQ    *+4
        LDA   #4      checksum incorrect
       RTS

WRITE  JSR    POSPIS
       BNE    WRITE-1 pas positionné
       LDA    1,X
       BITA   #4
       BEQ    *+5
        LDA   #5      disquette protégée
        RTS
       JSR    COMPEN
       LDB    #$19
       BSR    POSSEC
       LDY    #$7500
WRTRY1 LEAY   -1,Y
       BNE    *+5
        LDA   #2        identificateur
        RTS               incorrect
       LDB    ,X
       BITB   #2
       BEQ    WRTRY1
       STA    3,X
       LDB    ,X
       BPL    *-2
       STA    3,X
       LDB    ,X
       BPL    *-2
       LDB    #$FB
       STB    3,X
       LDY    #256
ECRIT  LDB    ,X      lecteur prêt ?
       BPL    *-2
       LDB    ,U+
       STB    3,X
       LEAY   -1,Y
       BNE    ECRIT
       LDB    ,X
       BITB   #8      opération finie ?
       BEQ    *-4
       JMP    WAIT2-6

COMPEN LDB    <DKTRK  si pistes internes
       CMPB   #$39     pré-compensation
       BPL    *+7
       LDD    #$9F00+256/8
       BRA    *+5
INTERN LDD    #$1F02+256/8
       STA    7,X
       STB    1,X
       RTS

POSSEC LDA    <DKSEC
       STA    5,X
       LDA    #10
       STA    4,X
       LDA    #$A1
       STA    3,X
       LDU    <DKBUF
       STB    ,X
       RTS

POSPIS BSR    TSTDRV
       BNE    *+5     Lecteur non prêt
       BSR    MOVE
       CLRA
       RTS
TSTDRV LDY    #$8000    lance le drive
       LDB    <DKTMP    (s'il existe!)
       ORB    #4
       STB    2,X     active moteur
       ANDB   #$FB
       STB    2,X     inactive moteur
       LEAY   -1,Y
       BNE    *+5
        LDA   #1      la disquette
        RTS           ne répond pas
       LDB    1,X
       ANDB   #2
       BEQ    TSTDRV+4
       CLRA           le drive est prêt
       RTS
MOVE   JSR    WAIT3
       LDB    <TRACK  la piste où est la
       LDA    <DKTMP   tête présentement
       SUBB   <DKTRK
       BEQ    PISOK
       BPL    *+5
       ORA    #$20
       NEGB
       STA    2,X
MVTETE ORA    #$14    commande de pas ON
       STA    2,X
       ANDA   #$EB               pas OFF
       STA    2,X
       BSR    WAIT3
       DECB
       BNE    MVTETE
       BSR    WAIT2
PISOK  LDB    <DKTRK  la tête est sur la
       STB    6,X       bonne piste
       STB    <TRACK
       RTS

       LDY    #$6C
       BRA    WAIT3+4
WAIT2  LDY    #$750
       BRA    WAIT3+4
WAIT3  LDY    #$2EC
       LEAY   -1,Y
       BNE    *-2
       RTS
