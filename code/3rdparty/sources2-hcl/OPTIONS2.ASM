SIDTXT  * choisit quelle face du disque
       FCC    "SIDE @"
       FCB    0
OPSIDE LDA    <DKDRV  choisit la face
       ADDA   #'0
       STA    ,U
       LDX    #CHKBOL
       STX    <INPCHK
       LDX    #VALASC
       STX    <INPVAL
       LDA    #1
       JSR    INPUT   choix de la face
       JSR    IPIHEX
       BEQ    EOPSID
       LDB    ,U
       SUBB   #'0
       STB    <DKDRV
       CLRA
EOPSID JMP    HWINDW

FILTXT  * option: remplit zone mémoire
       FCC    "FILL $@"
       FDB    0,0
       FCC    " TO $"
       FDB    0,0
       FCC    ">PATTERN $"
       FDB    0,0,0,0,0,0,0,0
OPFILL LDA    #4
       LEAY   4,U
       JSR    INPUT   lit adresse début
       BEQ    EOPFIL
       STU    <FILBEG
       LDA    #4
       JSR    DIPUT2  lit adresse de fin
       BEQ    EOPFIL
       STU    <FILEND
       JSR    CLRBAR
       LDX    #CHKSOP
       STX    <INPCHK
       LDX    #VALSOP
       STX    <INPVAL
       LDA    #16     16 digits maximum
       JSR    DIPUT2  motif remplissage
       TSTB           chaîne " ?
       BEQ    *+3
       LSRA
       JSR    IPIHEX
       BEQ    EOPFIL
       CLR    <CLIGNO
       LDB    #32     efface le curseur
       JSR    PUTC
       LDX    <FILEND
       LEAY   ,U
       LDB    ,U
       CMPA   #1
       BEQ    SIGPAT
       STX    >SPIDF1+1    motif long
       LDX    <FILBEG
       CMPX   <FILEND
       BEQ    EOPFIL-2
       STA    <FILBEG
HUGPAT LDB    ,U+
       STB    ,X+
       DECA
       BNE    *+6
       LEAU   ,Y
       LDA    <FILBEG
SPIDF1 CMPX   #0
       BNE    HUGPAT
       LDB    ,U
       BRA    EOPFIL-2

SIGPAT STX    >SPIDF2+1  motif à 1 octet
       LDX    <FILBEG
       CMPX   <FILEND
       BEQ    EOPFIL-2   on remplit la
FILL   STB    ,X+      zone avec l'octet
SPIDF2 CMPX   #0          spécifié...
       BNE    FILL
       STB    ,X
EOPFIL CLRA
       JMP    HWINDW

COPTXT  * option: copie une zone mémoire
       FCC    "COPY $@"
       FDB    0,0
       FCC    " - $"
       FDB    0,0
       FCC    " TO $"
       FDB    0,0
OPCOPY LDA    #4
       LEAY   4,U
       JSR    INPUT   lit adresse début
       BEQ    EOPCOP     zone source
       STU    <COPBEG
       LDA    #4
       JSR    DIPUT2  lit adresse de fin
       BEQ    EOPCOP     zone source
       STU    <COPEND
       LDA    #4
       JSR    DIPUT2  lit adresse début
       BEQ    EOPCOP   zone destination
       CLR    <CLIGNO
       LDB    #32     efface le curseur
       JSR    PUTC
       CMPU   <COPBEG
       BLS    ASCECP    mode ascending
       LDX    <COPEND   mode descending
       LDD    <COPEND
       SUBD   <COPBEG  longueur zone - 1
       BEQ    EOPCOP-4
       LEAU   D,U
       LEAX   1,X
       LEAU   1,U
       LDD    <COPBEG
       STD    SPIDC1+1
       LDB    ,-X
       STB    ,-U
SPIDC1 CMPX   #0
       BNE    *-7
       CLRA
       JMP    HWINDW

ASCECP LDD    <COPEND    copie en mode
       STD    >SPIDC2+1    ascending
       LDX    <COPBEG
       CMPX   <COPEND
       BEQ    EOPCOP-4
       LDB    ,X+      copie de la zone
       STB    ,U+       source vers la
SPIDC2 CMPX   #0      zone destination
       BNE    *-7
       LDB    ,X
       STB    ,U
EOPCOP CLRA
       JMP    HWINDW

ABOTXT  * option: au sujet de FAB-Mon
       FCC    "ABOUT@"
       FCC    "                        "
       FCC    "    FAB-Monitor v3.1    "
       FCC    " Copyright (c) 1992 by  "
       FCC    "    Laurent  Hiriart    "
       FCC    "                        "
       FCC    " Published by  A.S.C.I. "
       FCC    "365, Chemin des montants"
       FCC    "     54690 EULMONT      "
       FCC    "                        "
       FCC    "Comments,suggestions and"
       FCC    "bug reports are welcome."
       FCC    "                        "
OPABOU CLRA
       JSR    GETC
       CMPB   #2      touche Stop ?
       LBEQ   HWINDW
       CMPB   #13     touche Entrée ?
       BNE    OPABOU+1
       JSR    HWINDW
       LDA    #12     lignes à afficher
       STA    <CMPT
OPABOD LDA    #5        marge à gauche
       LDB    #32
       JSR    PUTC
       DECA
       BNE    *-4
       LDA    #24     affiche une ligne
       LDB    ,U+         de texte
       JSR    PUTC
       DECA
       BNE    *-6
       LDA    #11     tabulation droite
       LDB    #32
       JSR    PUTC
       DECA
       BNE    *-4
       DEC    <CMPT
       BNE    OPABOD
       RTS

VIWTXT  * option: affiche le répertoire
       FCC    "VIEW@"
VIWLIN FCC    "   0:DiskName     F:"
       FCC    "316  O:  0  R:  4   "
OPVIEW CLRA
       JSR    GETC
       CMPB   #2
       LBEQ   HWINDW
       CMPB   #13
       BNE    OPVIEW+1
       JSR    HWINDW
       LDY    #VIWLIN+3
       LDB    <DKDRV
       ADDB   #'0
       STB    ,Y++
       CLR    <DKOPC  opération READ
       LDX    #IOZONE
       STX    <DKBUF
       LDD    #$1401
       STD    <DKTRK
       JSR    DISK
       LDB    #8
       LDA    ,X+     copie du nom de la
       STA    ,Y+          disquette
       DECB
       BNE    *-5
       INC    <DKSEC
       LDX    #FAT
       STX    <DKBUF
       JSR    DISK      charge la FAT
       LEAX   1,X        et l'analyse
       STB    <CMPT
DSKF   LDA    ,X+
       CMPA   #$FF       bloc libre ?
       BNE    *+3
       INCB           FREE++
       CMPA   #$FE
       BNE    *+4
       INC    <CMPT   RESERVED++
       CMPX   #FAT+161
       BLO    DSKF
       STB    <VIWTMP
       LEAU   7,Y     Nb(Ko)=2*Nb(Blocs)
       JSR    BB2DEC       FREE
       LEAU   4,U
       LDB    #160
       SUBB   <VIWTMP blocs libres
       SUBB   <CMPT    ""  réservés
       JSR    BB2DEC     OCCUPIED
       LEAU   4,U
       LDB    <CMPT
       JSR    BB2DEC     RESERVED
       LDX    #VIWLIN affiche le header
       JSR    DISLIN+3  du catalogue
       LDU    #LINE
       LDD    #$2820   efface la zone
       STB    ,U+     qui va servir aux
       DECA           lignes de fichiers
       BNE    *-3
       LDY    #VFITYP
       LDX    #CATALG
       STX    <DKBUF
       LDD    #$317
       STB    <CMPT
VIWDIR STA    <DKSEC
       JSR    DISK    charge directory
       LDX    #CATALG
DIRAFF LDB    ,X
       BEQ    VESCAT  oui:stop recherche
       CMPB   #$FF     fin du catalogue
       BEQ    EOPVIW
       BSR    VAFFIL
       BEQ    EOPVIW  DIR interrompu
VESCAT LEAX   32,X
       CMPX   #CATALG+256
       BLO    DIRAFF
       INCA
       CMPA   #17
       BLO    VIWDIR
EOPVIW CLRA
       RTS

VAFFIL PSHS   X,A
       CLRA
       STA    <VIWTMP
       STA    <FILEN
       DECA
       LDB    13,X    1er bloc ds la FAT
       LDX    #FAT+1
       ABX
       INC    <FILEN  nbre blocs ++
       LDB    ,X
       STA    ,X      code=-1
       CMPB   #$A0
       BLO    *-12      détruit chaînage
       SUBB   #$C1
       CMPB   #8
       BLO    *+7
        LDA   #9      Bad File Structure
        JMP   ERROR
       LDX    1,S     retrouve pointeur
       STB    <VIWTMP+1
       LDA    <FILEN    nombre de blocs
       DECA
       LDB    #8
       MUL
       ADDD   <VIWTMP  calcule la taille
       STD    <VIWTMP  précise,en octets
       LDA    #255
       MUL            T=255*((Nblocks-1)
       STD    <VWTMP2 *8+(Nsecteurs dans
       LDA    <VIWTMP dernier block)-1)+
       LDB    #255    Noctets dans le
       MUL             dernier secteur.
       ADDB   <VWTMP2
       BCC    *+3
       INCA
       STD    <VIWTMP+1
       LDD    14,X    octets utilisés ds
       ADDD   <VWTMP2 le dernier secteur
       BCC    *+4
       INC    <VIWTMP+1
       STB    <VWTMP2+1
       LDB    <VIWTMP+1
       ADDB   #'0
       LDU    #LINE
       STB    ,U+
       JSR    ATOHEX   affiche la taille
       LDA    <VWTMP2+1
       JSR    ATOHEX   précise,en octets
       LDA    #8
       LEAU   1,U
       LDB    ,X+
       STB    ,U+     copie du nom
       DECA
       BNE    *-5
       LDA    #3
       LEAU   1,U
       LDB    ,X+
       STB    ,U+     copie du suffixe
       DECA
       BNE    *-5
       LDD    ,X
       STD    <VIWTMP
       LDA    #8      copie commentaire
       LEAU   4,U
       LEAX   5,X
       LDB    ,X+
       BNE    *+4
       LDB    #32     -> espace si $00
       STB    ,U+
       DECA
       BNE    *-9
       LEAU   1,U
       LDB    <FILEN
       JSR    BB2DEC  longueur 2*Nblocks
       LEAU   1,U
       LDB    #'?
       LDA    <VIWTMP
       CMPA   #3
       BHI    *+4
       LDB    A,Y
       STB    ,U++    type du fichier
       LDB    #'B
       LDA    <VIWTMP+1
       BEQ    *+4
       LDB    #'A
       STB    ,U      Sémaphore Asc/Bin
       JSR    DISLIN
       JSR    GETC
       CMPB   #2
       BEQ    VFITYP-2  DIR interrompu
       DEC    <CMPT
       BNE    VFITYP-2
       JSR    GETC
       BCC    *-3
       CMPB   #2
       BEQ    VFITYP-2
       LDA    #24
       STA    <CMPT
       PULS   A,X,PC
VFITYP FCC    "BDMA"

HLPTXT  * option: affiche les commandes
       FCC    "HELP@"
       FCC    "    T  TRANSFER ROM     "
       FCC    "                "
OPHELP CLRA
       JSR    GETC
       CMPB   #2
       LBEQ   HWINDW
       CMPB   #13
       BNE    OPHELP+1
       JSR    HWINDW
       LDY    #OPTION
       LDA    #24
       STA    <CMPT

HLPDSP LDU    #OPHELP-40+7
       LDB    ,Y+
       CMPB   #13
       BNE    HLPART
       LDA    #'E     copie ENT
       STA    -5,U
       LDD    #$4E54
       BRA    HLPJN1
HLPART CMPB   #12
       BNE    HLPNOR
       LDA    #'R     copie RAZ
       STA    -5,U
       LDD    #$415A
       BRA    HLPJN1
HLPNOR LDA    #32
       STA    -5,U
HLPJN1 STD    -4,U
       LDX    ,Y
       LDB    ,X+
       CMPB   #'@
       BEQ    *+6
       STB    ,U+
       BRA    *-8
       LDA    -1,U
       CMPA   #32
       BEQ    *+8
       CMPA   #'$
       BNE    *+6
       LEAU   -1,U
       LEAU   -1,U
       LDB    #32
       STB    ,U+
       CMPU   #OPHELP-9
       BLO    *-6
       LDU    #OPHELP-40
       LDA    #40
       LDB    ,U+
       JSR    PUTC
       DECA
       BNE    *-6
       DEC    <CMPT
       BNE    HLPGON
       JSR    GETC
       BEQ    *-3
       CMPB   #2
       BEQ    EOHELP
HLPGON LEAY   4,Y
       CMPY   #ENDOPT
       BNE    HLPDSP
EOHELP CLRA
       RTS

IMATXT  * option: sauvegarde d'écran PPM
       FCC    "IMAGE @"
       FCB    0
       FCC    "ILENAME."
       FCB    0
       FCC    "AP ; "
       FCB    0
       FCC    "omments"
OPIMAG JSR    FILRQT  saisie du nom
       BEQ    *+5
       JSR    COMRQT  saisie commentaire
       JSR    IPIHEX
       JSR    HWINDW
       LBEQ   EOPIMA
       LDX    #NULL
       JSR    SETPAL  palettes en noir
       LDA    $E7E5
       STA    <IMABNK
       LDD    <CODCDD+1 mode d'affichage
       STA    $E7DC
       CLRA
       ASLB
       ROLA
       ASLB
       ROLA
       BNE    *+5
       LDA    >ZZZBK1+1
       STA    $E7E5
       DEC    $E7C3
       JSR    BNK2VW    copie l'écran
       LDX    #COLORS+32
       JSR    SETPAL

       LDA    #39     largeur - 1
       LDB    $605F
       ANDB   #$C0
       STB    <IS4080
       BEQ    *+4
       ADDA   #40
       LDY    #$A000  adresse début code
       STY    <BEGADR
       STB    ,Y+     code colonnes
       LDB    #$18    taille de l'écran
       STD    ,Y++
       BSR    PLANE
       LDA    <IS4080
       BNE    FINCOD
       DEC    $E7C3
       BSR    PLANE

FINCOD TFR    Y,D
       ANDB   #1      alignement sur une
       BEQ    *+4       adresse paire
       CLR    ,Y+
       LDX    #COLORS+64
KOPIPA LDD    ,--X
       BITA   #$10
       BEQ    *+5
       ADDD   #1
       ANDA   #15
       STD    ,Y++
       CMPX   #COLORS+32
       BNE    KOPIPA
       CLRA
       LDB    <CODCDD
       STD    ,Y++
       LDD    #$484C
       STD    ,Y++
       LEAX   -$A000,Y
       STX    <FILSIZ
       LDD    #0
       STD    <EXEADR
       LDA    #12     Picture Too Large
       CMPX   #$4000
       LBHI   ERROR
       LDD    #$200   FILE/DATA types
       STD    <FILETY
       JSR    SAVEM

       LDX    #NULL
       JSR    SETPAL
       CLR    $E7DC
       LDA    $E7C3
       ANDA   #254
       STA    $E7C3
       JSR    VW2BNK
       LDA    <IMABNK
       STA    $E7E5
       JSR    FABSCR
EOPIMA CLRA
       RTS


PLANE  LDU    #$4000   compacte un plan
       STU    <HIGADR
       LDD    #$28C8  40 cols / 200 ligs
       TST    <IS4080
       BEQ    *+4
       ADDA   #40
       STD    <CMPTLH
GROUP  CLRA           nombre occurences
       LDB    ,U
       BSR    SEGBAS  segment courant et
       BNE    SINGLE  + bas identiques ?


MMSEG  BSR    NXLINE
       INCA
       CMPA   #$FF
       BEQ    EOLIST
       CMPB   ,U
       BNE    EOLIST
       TST    <CMPTLH
       BNE    MMSEG
EOLIST STD    ,Y++
       BRA    NGROUP

SINGLE STA    ,Y++
       PSHS   Y
ALLDIF BSR    NXLINE
       STB    ,Y+
       INCA
       CMPA   #$FF
       BEQ    EOSING
       LDB    ,U
       BSR    SEGBAS
       BEQ    EOSING
       TST    <CMPTLH
       BNE    ALLDIF
EOSING PULS   X
       STA    -1,X


NGROUP LDA    <CMPTLH
       BNE    GROUP
       CLRA
       CLRB
       STD    ,Y++
       RTS

SEGBAS PSHS   B,A
       LDB    40,U
       LDA    <CMPTLH+1
       DECA
       BNE    CMPSGB
       BSR    NXTCOL  fin de la ligne
       LDB    ,X
       BSR    NXCOL2
CMPSGB CMPB   1,S
       PULS   A,B,PC

NXLINE LEAU   40,U
       DEC    <CMPTLH+1  1ligne de moins
       BNE    EONXLN

       PSHS   A
       DEC    <CMPTLH  1colonne de moins
       LDA    #200
       STA    <CMPTLH+1
       BSR    NXTCOL
       STX    <HIGADR
       LEAU   ,X
       PULS   A,PC

NXTCOL LDX    <HIGADR
NXCOL2 LDA    <IS4080
       BEQ    INCCOL
       LDA    $E7C3
       EORA   #1
       STA    $E7C3
       LSRA
       BHS    EONXLN
INCCOL LEAX   1,X
EONXLN RTS
