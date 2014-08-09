*
* ECRIT.ASM / ROUTINE SAVE
*
* GESTION D'IMAGES (C) A. PUKALL
* MICRONEWS No 46 page 28
*

PRC    EQU    $E7C3   Données port C
EXTRA  EQU    $EC0C   Appel extramonit.
DKDRV  EQU    $6049   No du disk choisi
FILMOD EQU    $624B   Mode fichier(OPEN)
FILTYP EQU    $624C   Type de fichier:
*                     0=BASIC programme
*                     1=BASIC data file
*                     2=Langage machine
ASCFLG EQU    $624D   Flag ASCI:
*                     00=fichier BIN
*                     FF=fichier ASCI
FILNAM EQU    $624F   Buf nom de fichier
*                     8 car H624F->H6256
FILEXT EQU    $6257   Buf ext nom fic.
*                     3 car H6257->H6259
OPTBUF EQU    $625A   Buf commentaire
*                     8 car H625A->H6261

       ORG    $71BA

       JSR    INIT
       LDB    #3
       JSR    EXTRA
       JSR    DEBUT
       RTS
INIT   LDA    #0      No lecteur:"0:"
       STA    DKDRV
       LDA    #$20    Mode d'accès:"H20"
       STA    FILMOD  (ouvre en output)
       LDA    #$41
       STA    FILNAM  Nom de fichier:"A"
       LDX    #$2020
       STX    $6250   "Esp+Esp"
       STX    $6252   "Esp+Esp"
       STX    $6254   "Esp+Esp"
       LDA    #$20
       STA    $6256   "Esp"
       LDA    #$42
       STA    FILEXT  Extension:"B"
       LDA    #$49
       STA    $6258   "I"
       LDA    #$4E
       STA    $6259   "N"
       LDX    #$4765
       STX    OPTBUF  Commentaire:"Ge"
       LDX    #$7374
       STX    $625C   "st"
       LDX    #$696D
       STX    $625E   "im"
       LDX    #$6167
       STX    $6260   "ag"
       LDA    #2
       STA    FILTYP  2=fic en lang mach
       LDA    #0
       STA    ASCFLG  0=fichier binaire
       RTS
DEBUT  LDA    #5
       STA    PRC
       LDX    #$4000
BOUC1  LDA    ,X
       LDB    #4
       JSR    EXTRA
       LEAX   1,X
       CMPX   #$5F4F
       BNE    BOUC1
       LDB    #6
       JSR    EXTRA
       JSR    INIT
       LDA    #$42
       STA    FILNAM  Nom du fichier:"B"
       LDB    #3
       JSR    EXTRA
       LDA    #4
       STA    PRC
       LDX    #$4000
BOUC2  LDA    ,X
       LDB    #4
       JSR    EXTRA
       LEAX   1,X
       CMPX   #$5F4F
       BNE    BOUC2
       LDB    #6
       JSR    EXTRA
       RTS
       FCC    /(C)ALEXANDRE PUKALL/
       END
