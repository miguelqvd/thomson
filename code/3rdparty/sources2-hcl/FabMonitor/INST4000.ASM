****************************************
*   Installation de FAB-Monitor v3.1   *
****************************************

E      EQU    27      code ESC
F      EQU    31      code US
G      EQU    22      code ACC
ISCHDC EQU    $002A   CMPB  #CHRDEC
ZZZAD1 EQU    $0003   LDX   #RESET+3
ZZZAD2 EQU    $000B   STB   >RESET+15
ZZZAD3 EQU    $0033   JMP   >RESET+16
ZZZBK1 EQU    $0162   LDB   #FABBNK+1
LEN    EQU    $D4

       ORG    $4000

BUFFER FCB    0,5,6,'Z-64,$5F,$EC
ZZZZA1
RSTMSG FCB    F,$4C,$49
       FCC    "Installation termin"
       FCB    G,$42
       FCC    "ee !"
       FCB    F,$4F,$49
       FCC    "Appuyez sur une touche"
       FCB    F,$50,$43
       FCC    "pour revenir "
       FCB    G,$41
       FCC    "a la page d'ent"
       FCB    G,$43
       FCC    "ete..."
ZZZZA2 FCB    0

COPY   LDU    BUFFER+4
       CMPU   #$6000
       BHS    ZONOK    installe simple
       LDA    $E7E5
       CLR    $E7E5    installe en RAM-A
       LEAU   $6000,U  et en RAM-B de la
       BSR    ZONOK      mémoire-écran
       LDU    BUFFER+4
       LEAU   $8000,U
       BSR    ZONOK
       STA    $E7E5
       RTS

ZONOK  LDX    #RESET  installe en RAM-B
       LDB    ,X+
       STB    ,U+
       CMPX   #ENDPRG
       BNE    *-7
       RTS

RESET  FCB    $6F,$8C,$0C CLR EXEC+2,PCR
MYGETC PSHS   DP,B,A,CC
       LDA    $E7E6    sauve cartouche
FABBNK LDB    #$60
       STB    $E7E6   FAB-Mon3.1 visible
EXEC   JMP    >$0020
       STA    <$E6
       PULS   CC,A,B,DP,PC
ENDPRG


       JSR    PRINTU
GETADR LDD    #$408
       JSR    $E803
       DECA
       BNE    *-4
       LDB    #$11
       JSR    $E803
       JSR    HDIGIT
       ASLB
       ASLB
       ASLB
       ASLB
       PSHS   B
       JSR    HDIGIT
       ADDB   ,S
       STB    ,S
       JSR    HDIGIT
       ASLB
       ASLB
       ASLB
       ASLB
       PSHS   B
       JSR    HDIGIT
       ADDB   ,S
       STB    ,S
       PULS   A,B
       EXG    A,B
       TFR    D,X
       CMPX   #$4000
       BLO    GETADR
       CMPX   #$DFEC
       BHI    GETADR
       LDB    #$14
       JMP    $E803

ZZZZB1
ISITOK FCB    F,$54,$47
       FCC    "Appuyez sur 'ENT' pour "
       FCC    "valider,    ou 'STOP' po"
       FCC    "ur changer les param"
       FCB    G,$41
       FCC    "etres."
       FCB    0,12,F,$4C,$49
       FCC    "Chargement en cours..."
ZZZZB2 FCB    0

RILBEG LDX    #$6200
       STU    ,X++
       CMPX   #$6A00
       BNE    *-5

       LDY    #BUFFER
       LDA    $607F   installation
       LBEQ   NOWLOD  automatique (opt1)
       LDA    $618C
       INCA
       STA    ,Y      bank maximum
       LDU    #MAXBK1
       JSR    ATOHEX
       LDU    #MAXBK2
       JSR    ATOHEX
START  LDU    #PGEONE
       JSR    PRINTU
       LDD    #$5FEC
       STD    4,Y
OPTION JSR    $E806
       CMPB   #'1
       BNE    *+13
       LDD    #$0506
       STD    1,Y
       LDA    #'Z-64
       STA    3,Y
       BRA    CNFIRM
       CMPB   #'2
       BNE    *+13
       LDD    #$090A
       STD    1,Y
       LDA    #'Z-64
       STA    3,Y
       BRA    CNFIRM
       CMPB   #'3
       BNE    OPTION
       LDD    #$2E2E+$A5A5
       STD    INDIRE
       STD    INDIRE+2
       STD    BANK1
       STD    BANK2
       LDB    #0+$A5
       STD    CHRDEC
       LDU    #ECRAN2
       JSR    GETADR-3
       STX    4,Y
       JSR    GETBNK-3
       STA    1,Y
       JSR    PRINTU
       JSR    GETBNK
       CMPA   1,Y
       BEQ    *-5
       STA    2,Y
       JSR    PRINTU
       JSR    $E806
       BEQ    *-3
       STB    3,Y
CNFIRM JSR    SHOVAL
       LDU    #ECRAN2
       LDX    #PRINTU
       JSR    ,X
       JSR    ,X
       JSR    ,X
       JSR    ,X
       LDU    #ISITOK
       JSR    PRINTU
GETOK  JSR    $E806
       CMPB   #2
       LBEQ   START
       CMPB   #13
       BNE    GETOK
       JSR    PRINTU
       JMP    NOWLOD

ZZZZC1
ECRAN2 FCB    12,F,$48,$41
       FCC    "Redirection [4000-DFEC]:"
L0     FCC    " ...."
       FCB    0,F,$4A,$41
       FCC    "BANK du code de FAB-Mon "
L1     FCC    "[02-1F]: .."
       FCB    0,F,$4C,$41
       FCC    "BANK de sauvegarde "
       FCB    G,$42
L2     FCC    "ecran [02-1F]: .."
       FCB    0,F,$4E,$41
       FCC    "Caract"
       FCB    G,$41
       FCC    "ere d"
       FCB    G,$42
L3     FCC    "eclencheur: CNT-Z"
ZZZZC2 FCB    0


NOWLOD ORCC   #80
       LDA    $E7E6
       PSHS   A
       LDB    #$60
       ADDB   1,Y
       STB    $E7E6
       STB    FABBNK+1

********************* début TRACKLOADER

       PSHS   CC,DP,A,B,X,Y,U
       JSR    $E09D
       LDD    #$0200  lecture face 0
       STD    <$48
       LDD    #$0101  piste 1, secteur 1
       STD    <$4B
       LDU    #$0000  buffer = 0

TRACK  JSR    $E452   positionne piste
       LDD    #$9F40
       STA    7,X             séparateur
       STB    1,X     taille,face,précom

       LDA    <$4C
SECTOR STA    5,X
       LDA    #$0A    config= ($FF/$0A)
       STA    4,X
       LDA    #$A1    on veut lire $A1
       STA    3,X
       LDB    #$1B    sync-détection ON
       STB    ,X      lecture secteur

       LDB    ,X      prêt pour cette
       BITB   #2      opération dite
       BEQ    *-4     "intelligente" ?
       LDB    3,X
GETSYN LDB    ,X      lecture des 4 mots
       BPL    *-2
       LDB    3,X     de synchro :
       CMPB   #$72
       BNE    GETSYN   A1/horloge/0A/72

       LDY    #512
READ   LDB    ,X
       BPL    *-2
       LDB    3,X     lecture du champ
       STB    ,U+
       LEAY   -1,Y    des SIZE données
       BNE    READ

       LDB    ,X
       BITB   #8      opération finie ?
       BEQ    *-4
       CLR    ,X
       CMPU   #$4000  fin lecture ?
       BEQ    THEEND

       LDA    <$4C    secteur suivant
       INCA
       STA    <$4C
       CMPA   #11
       BNE    SECTOR
       LDA    #1
       STA    <$4C
       INC    <$4B
       BRA    TRACK

THEEND JSR    $E0B9
       PULS   CC,DP,A,B,X,Y,U

*********************** fin TRACKLOADER

       LDD    BUFFER+2
       STA    >ZZZBK1+1
       STB    >ISCHDC+1
       LDX    BUFFER+4
       LEAX   3,X
       STX    >ZZZAD1+1
       LEAX   12,X
       STX    >ZZZAD2+1
       LEAX   1,X
       STX    >ZZZAD3+1
       LDD    >$600A
       LDY    #0
GOODGT LDX    ,Y+
       CMPX   #$4B55
       BNE    *+6
       LEAY   -1,Y
       STD    ,Y++
       CMPY   #$4000
       BLO    GOODGT
       PULS   A
       STA    $E7E6
FINFIN JSR    COPY
       LDX    BUFFER+4
       STX    $6089
       LDA    #$7E
       STA    $6088
       LDA    $607F
       BEQ    EXPLOD
       LDU    #RSTMSG
       JSR    PRINTU
       JSR    $E806
       BCC    *-3
EXPLOD JMP    $FDC8

       JSR    PRINTU
GETBNK LDB    #8
       JSR    $E803
       JSR    $E803
       LDB    #$11
       JSR    $E803
       JSR    HDIGIT
       ASLB
       ASLB
       ASLB
       ASLB
       PSHS   B
       JSR    HDIGIT
       ADDB   ,S
       STB    ,S
       PULS   A
       CMPA   #2
       BLO    GETBNK
       CMPA   ,Y
       BHI    GETBNK
       LDB    #$14
       JMP    $E803

HDIGIT JSR    $E806
       CMPB   #'0
       BLO    HDIGIT
       CMPB   #'F
       BHI    HDIGIT
       CMPB   #'9
       BHI    *+8
       JSR    $E803
       SUBB   #'0
       RTS
       CMPB   #'A
       BLO    HDIGIT
       JSR    $E803
       SUBB   #'0+7
       RTS

PRINTU LDB    ,U+
       SUBB   #$A5                     @
       JSR    $E803
       BNE    *-7
       RTS

SHOVAL LDA    4,Y
       LDU    #INDIRE
       JSR    ATOHEX
       LDA    5,Y
       JSR    ATOHEX
       LDA    1,Y
       LDU    #BANK1
       JSR    ATOHEX
       LDA    2,Y
       LDU    #BANK2
       JSR    ATOHEX
       LDA    3,Y
       LDU    #CHRDEC
       CMPA   #32
       BHS    IFCHD2
       LDD    #$434E+$A5A5   "CNT-"    @
       STD    ,U++
       LDD    #$542D+$A5A5             @
       STD    ,U++
       LDA    3,Y
       ADDA   #64
       BRA    PRTCHR
IFCHD2 CMPA   #$9A
       BLO    IFCHD3
       LDD    #$5041+$A5A5   "PAD-"    @
       STD    ,U++
       LDD    #$442D+$A5A5             @
       STD    ,U++
       LDA    3,Y
       SUBA   #$6A
       BRA    PRTCHR
IFCHD3 CMPA   #$80
       BLO    PRTCHR
       LDD    #$464E+$A5A5   "FNC-"    @
       STD    ,U++
       LDD    #$432D+$A5A5             @
       STD    ,U++
       LDA    3,Y
       SUBA   #$5F
       CMPA   #'9
       BLS    PRTCHR
       LDA    #'A
PRTCHR CLRB
       ADDD   #$A5A5                   @
       STD    ,U++
       RTS

ATOHEX PSHS   X,A
       LDX    #HEXA
       LSRA
       LSRA
       LSRA
       LSRA
       LDA    A,X
       ADDA   #$A5                     @
       STA    ,U+
       LDA    ,S
       ANDA   #15
       LDA    A,X
       ADDA   #$A5                     @
       STA    ,U+
       PULS   A,X,PC
HEXA   FCC    "0123456789ABCDEF"

ZZZZD1
PGEONE FCB    12,F,$49,$48
       FCC    "1.Installation en BANK 5"
       FCC    "/6"
       FCB    F,$4A,$4A
       FCC    "(BASIC, Applications...)"
       FCB    F,$4D,$48
       FCC    "2.Installation en BANK 9"
       FCC    "/A"
       FCB    F,$4E,$4A
       FCC    "(Jeux, D"
       FCB    G,$42
       FCC    "emos...)"
       FCB    F,$51,$48
       FCC    _3.Installation "manuelle_
       FCB    '"
ZZZZD2 FCB    0
ZZZEND

INDIRE EQU    L0+1
MAXBK1 EQU    L1+4
BANK1  EQU    L1+9
MAXBK2 EQU    L2+10
BANK2  EQU    L2+15
CHRDEC EQU    L3+12

       END
