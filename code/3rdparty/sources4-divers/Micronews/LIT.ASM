*
* LIT.ASM / ROUTINE READ
*
* GESTION D'IMAGES (C) A. PUKALL
* MICRONEWS No 46 page 28
*

PRC    EQU    $E7C3   Données port C
EXTRA  EQU    $EC0C   Appel extramonit.
DKDRV  EQU    $6049   No du disk choisi
CARCOU EQU    $6196   Car. que DFCHRI
*                     vient de lire
FILMOD EQU    $624B   Mode fichier(OPEN)
FILTYP EQU    $624C   Type de fichier:
*                     0=BASIC programme
*                     1=BASIC data file
*                     2=Machine lang.fil
ASCFLG EQU    $624D   Flag ASCI:
*                     00=fichier BIN
*                     FF=fichier ASCI
FILNAM EQU    $624F   Buf nom de fichier
*                     8 car.H624F->H6256
FILEXT EQU    $6257   Buf ext nom fic.
*                     3 car.H6257->H6259

       ORG    $B000

       JSR    INIT
       LDB    #3
       JSR    EXTRA
       JSR    DEBUT
       RTS
INIT   LDA    #0      No lecteur: "0:"
       STA    DKDRV
       LDA    #$10    Type d'accès:"H10"
       STA    FILMOD  (ouvre en input)
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
       LDA    #2
       STA    FILTYP  2=fic en lang mach
       LDA    #0
       STA    ASCFLG  0=fichier binaire
       RTS
DEBUT  LDA    #5
       STA    PRC
       LDX    #$4000
BOUC1  LDB    #5
       JSR    EXTRA
       LDA    CARCOU
       STA    ,X
       LEAX   1,X
       CMPX   #$5F4F
       BNE    BOUC1
       LDB    #6
       JSR    EXTRA
       JSR    INIT
       LDA    #$42    Nom du fichier:"B"
       STA    FILNAM  (1er car.)
       LDB    #3
       JSR    EXTRA
       LDA    #4
       STA    PRC
       LDX    #$4000
BOUC2  LDB    #5
       JSR    EXTRA
       LDA    CARCOU
       STA    ,X
       LEAX   1,X
       CMPX   #$5F4F
       BNE    BOUC2
       LDB    #6
       JSR    EXTRA
       RTS
       FCC    /(C)ALEXANDRE PUKALL/
       END
