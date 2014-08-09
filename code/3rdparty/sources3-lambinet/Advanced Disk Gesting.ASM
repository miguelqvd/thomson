***************************************
******* Advenced Disks Gesting ********
******** Micromédia  Systèmes *********
***************************************


************** EQUATES ****************

PUTC   EQU    $E803
GETC   EQU    $E806
KTST   EQU    $E809
DKCO   EQU    $E82A
COMS   EQU    $EC03
EXTR   EQU    $EC0C
DIRR   EQU    $3FC1
SAISIE EQU    $3FC4
INDGET EQU    $600A
DEFTXT EQU    $61E0
TYPDSK EQU    $6219
FILNAM EQU    $624F
FILCOM EQU    $628E
IWTFLG EQU    $62A9

************** PROGRAM ****************

       ORG    $9000
DEBUT  PSHS   U,Y,X,DP,A,CC
       LEAX   ADGGET,PCR
       CMPX   INDGET
       BEQ    FINDEB
       LDX    INDGET
       STX    ADGGET+3,PCR
       LEAX   TXT0,PCR
       BSR    AFFICH
       BRA    SOR
REARM  LDB    #$0C
       JSR    PUTC
SOR    CLRB
       LEAX   ADGGET,PCR
       STX    INDGET
FINDEB PULS   CC,A,DP,X,Y,U,PC
AFFICH LDB    ,X+
       CMPB   #00
       BEQ    FINAFF
       JSR    PUTC
       BRA    AFFICH
FINAFF RTS
SORTIE LDX    ADGGET+3,PCR
       STX    INDGET
       LEAX   TXT1,PCR
       BSR    AFFICH
FINSOR PULS   CC,A,DP,X,Y,U,PC
ADGGET PSHS   U,Y,X,DP,A,CC
       JSR    $FF92
F0     CMPB   #$90
       BNE    F1
       LEAX   TXT2,PCR
       BRA    COMDIR  COMMANDE DIRECTE
F1     CMPB   #$91
       BNE    F3
       LEAX   TXT3,PCR
COMDIR STX    DEFTXT
       CLR    IWTFLG
       CLRB
       PULS   CC,A,DP,X,Y,U,PC
EXIT   LEAX   TXT2-7,PCR
       BSR    AFFICH
       CLRB
       PULS   CC,A,DP,X,Y,U,PC
F3     CMPB   #$92
       BNE    F5
       LBSR   CONT3P
       BRA    EXIT
F5     CMPB   #$94
       BNE    F6
       LBSR   CONT5P
       BRA    EXIT
F6     CMPB   #$95
       BEQ    SORTIE
F4     CMPB   #$93
       BEQ    COPY
       PULS   CC,A,DP,X,Y,U,PC
COPY   LDX    ADGGET+3,PCR
       STX    INDGET
       LEAX   TXT4,PCR
       BSR    AFFICH
INPUTT JSR    GETC
       CMPB   #$33
       BNE    T5
       JSR    PUTC
       LBSR   CONT3P
       BRA    L1
T5     CMPB   #$35
       BNE    INPUTT
       JSR    PUTC
       LBSR   CONT5P
L1     LEAX   TXT5,PCR
       LBSR   AFFICH
INPUTL JSR    GETC
       CMPB   #$30
       BLO    INPUTL
       CMPB   #$34
       BHI    INPUTL
       BNE    PRINTL
       LDA    TYPDSK
       CMPA   #$02
       BNE    INPUTL
PRINTL JSR    PUTC
       STB    TAMPON+6,PCR
       SUBB   #$30
       STB    $6049
       LDX    #FILNAM
       LDA    #$0C
INIFI1 CLR    ,X+
       DECA
       BNE    INIFI1
       LDD    #$0820
INIFI2 STB    ,X+
       DECA
       BNE    INIFI2
       LDA    #$7E
       STA    ,X+
       LEAU   CATRED,PCR
       STU    ,X
       LEAX   ADGGET,PCR
       STX    INDGET
       LEAX   TXT9,PCR
       LBRA   COMDIR

*************************
*                       *
*   Catalogue  réduit   *
*                       *
*************************

CATRED PSHS   U,Y,X,DP,A,CC
       LEAX   TXT7,PCR
       LBSR   AFFICH
       LDA    $618C
       DECA
       STA    $E7E5
       LDA    $603B
       ANDA   #$78
       LSRA
       LSRA
       LSRA
       BITA   #$08
       BNE    SAT
       ORA    #$08
       BRA    COLOR
SAT    ANDA   #$07
COLOR  STA    $619F
       LDA    #$FF
       STA    $6288
       LDA    #$00
       STA    $61A0
       LDX    #$A000
       LDY    #$1700
       LDA    #$03
       LDU    #DIRR
       JSR    COMS
       TSTB
       LBNE   REARM
RTCOP  LEAY   TAMPON,PCR
       LDX    #$0C43
       STX    ,Y++
       LDX    #$4F50
       STX    ,Y++
       LDX    #$5922
       STX    ,Y++
       LEAY   1,Y
       LDX    #FILNAM
       LDD    #$3A08
       STA    ,Y+
COPNOM LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COPNOM
       LDD    #$2E03
       STA    ,Y+
COPSUF LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COPSUF
       LDA    #$22
       STA    ,Y+
       LDX    #$0D00
       STX    ,Y
       LEAX   AUTO,PCR
       STX    INDGET
       PULS   CC,A,DP,X,Y,U,PC

********************************
*                              *
*  AUTO (Reprise automatique   *
*  en fin de Catalogue réduit  *
*                              *
********************************

AUTO   PSHS   U,Y,X,DP,A,CC
       LEAX   AUTO2,PCR
       STX    INDGET
       LEAX   TAMPON,PCR
       LBRA   COMDIR

********************************
*                              *
*  AUTO2 (Reprise automatique  *
*  lors de l'Insert a disk ... *
*                              *
********************************

AUTO2  PSHS   U,Y,X,DP,A,CC
       LDX    $09,S
       CMPX   #$3D19
       BEQ    CONT
       LEAS   $1D,S
       LBRA   REARM
CONT   LDX    ADGGET+3,PCR
       STX    INDGET
       LEAX   TXT4,PCR
       LBSR   AFFICH
       LEAX   TXT6,PCR
       LBSR   AFFICH
INPU2T JSR    GETC
       CMPB   #$33
       BNE    T52
       JSR    PUTC
       LBSR   CONT3P
       BRA    L2
T52    CMPB   #$35
       BNE    INPU2T
       JSR    PUTC
       LBSR   CONT5P
L2     LEAX   TXT5,PCR
       LBSR   AFFICH
INPU2L JSR    GETC
       CMPB   #$30
       BLO    INPU2L
       CMPB   #$34
       BHI    INPU2L
       BNE    PRIN2L
       LDA    TYPDSK
       CMPA   #$02
       BNE    INPU2L
PRIN2L JSR    PUTC
       SUBB   #$30
       STB    LECT+1,PCR
       STB    $6049
       LDX    #FILCOM
       LDY    #FILNAM+11
       LDB    #8
COMMEN LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COMMEN
       LEAX   TXT8,PCR
       LBSR   AFFICH
       LDA    $618C
       DECA
       STA    $E7E5
       LDX    #$A000
       LDY    #$1700
       LDA    #$03
       LDU    #SAISIE
       JSR    COMS
       TSTB
       LBNE   REARM
       LDX    #FILNAM
       LEAY   $11,S
       LDB    #$13
COPFIL LDA    ,X+
       STA    ,Y+
       DECB
       BNE    COPFIL
LECT   LDA    #0
       STA    ,Y
       LEAX   ADGGET,PCR
       STX    INDGET
       LEAX   TXT10,PCR
       LBSR   AFFICH
       LDB    #$0D
       PULS   CC,A,DP,X,Y,U,PC
CONT3P PSHS   U,Y,X,DP,B,A,CC
       LDA    TYPDSK
       CMPA   #$02
       BEQ    FINCON
       LDD    #$0254
       BRA    MODCON
CONT5P PSHS   U,Y,X,DP,B,A,CC
       LDA    TYPDSK
       CMPA   #$01
       BEQ    FINCON
       LDD    #$01D4
MODCON STA    TYPDSK
       STB    $E7E7
       LDD    #$0100
       STD    $6048
       JSR    DKCO
       LDA    #$02
       STA    $604D
ESSAI2 LDD    #$4014
       STA    $6048
       STB    $604B
       JSR    DKCO
       TST    $604E
       BEQ    FINCON
       DEC    $604D
       BEQ    FINCON
       LDA    #$20
       STA    $6048
       JSR    DKCO
       BRA    ESSAI2
FINCON PULS   CC,A,B,DP,X,Y,U,PC
TAMPON RMB    $20
TXT0   RMB    $69
TXT1   RMB    $28
TXT2   RMB    $A
TXT3   RMB    $A
TXT4   RMB    $4D
TXT5   RMB    $22
TXT6   RMB    $D
TXT7   RMB    $5
TXT8   RMB    $4
TXT9   RMB    $D
TXT10  RMB    $4
       END
