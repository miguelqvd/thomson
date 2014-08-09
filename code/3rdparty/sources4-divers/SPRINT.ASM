       TITLE  SPRINT
*    V1.0  du 10.11.91
*    Guyot daniel 73 83 09 43
* Machine TO et imprimante Citizen 120D+
ECRIT  EQU    $0800
CLOSE  EQU    $10
OPEN   EQU    $40
STAD   EQU    $4000
ENDAD  EQU    $5F40
*                         basic 1.0
LECVIR EQU    $08F3
SNERRO EQU    $0900       $07F3
LECVAR EQU    $1108       $0EB8
LEVAR1 EQU    $111A       $0EF1
INTERP EQU    $201D       $2B38
*
RSOPC  EQU    $602B
SCRMOD EQU    $605F
NBSUP  EQU    $6773
TABSUP EQU    $6774
ADRSUP EQU    $6776
*
PRC    EQU    $E7C3
RSCO   EQU    $E812

       ORG    $9000

EXEC   LDA    #1
       STA    NBSUP
       TFR    PC,D
       ADDD   #$0014
       STD    TABSUP      D -> TABFON
       ADDD   #$0006
       STD    ADRSUP      D -> INTFON
       ADDD   #$001E
       STD    ADRFON,PCR  D -> SPRINT
       RTS

TABFON FCC    "SPRIN"
       FCB    $80+'T

ADRFON RMB    2

INTFON SUBA   #$F9        $F9=$80+$79
       CMPA   #$00        fonction non
       BLO    INT2        implantée
       LDD    #$0F00
       LEAX   TAB5,PCR
INT1   STB    ,X+         mise à 0 des
       DECA               buffeurs
       BNE    INT1
       LEAX   ADRFON,PCR
       JMP    INTERP
INT2   JMP    SNERRO

SPRINT CMPA   #$00        Copie simple
       BEQ    START
       CMPA   #$2C        , -> var suite
       BEQ    SPR1
       CMPA   #$3A        : -> fin instr
       BEQ    START
       JSR    LECVAR
       CMPB   #$01        copie simple
       BLO    INT2
       CMPB   #$03        copie triple
       BHI    INT2        à venir
       DECB
       STB    TAB5,PCR    mode copie
       CMPA   #$2C
       BNE    START
SPR1   JSR    LECVIR
       BEQ    SPR2
       JSR    LECVAR
       CMPB   #$00        0  colonne
       BLO    INT2
       CMPB   #$20        32 colonnes
       BHI    INT2
       STB    TAB5+2,PCR  nb colonnes
       CMPA   #$2C
       BNE    START
SPR2   JSR    LEVAR1
       CMPB   #$00        0 ligne
       LBLO   INT2
       CMPB   #$2F        47 lignes
       LBHI   INT2
       STB    TAB5+3,PCR  nb lignes

START  PSHS   U,Y,X,DP,B,A,CC
       LEAX   TAB0,PCR    initialisation
       LBSR   FOR0
       LDA    #OPEN       ouverture //
       STA    RSOPC
       LBSR   IMP0
       LDD    #ECRIT      écrit caracter
       STA    RSOPC
       LBSR   IMP0
       LDB    SCRMOD
       CMPB   #$80        mode 80/40 col
       BNE    STA0        0 -> 40 col
       INC    TAB5+5,PCR  1 -> 80 col
STA0   TST    TAB5,PCR
       BEQ    SCOP        copie simple

       LBRA   DCOP        copie double

TAB0   FCB    23
       FCB    $48,$1B          dblfp off
       FCB    $46,$1B          gras  off
       FCB    $00,$78,$1B      nql   off
       FCB    $01,$55,$1B      undir  on
       FCB    $42,$43,$1B      lpag   66
       FCB    $50,$1B          pica
       FCB    $39,$1B
       FCB    $00,$35,$7E,$1B  epson
       FCB    $40,$1B          raz
*    interligne 24/216 pouce
TAB1   FCB    3
       FCB    $18,$33,$1B
*    lg ligne 256+231=2*200+87(marge)
TAB2   FCB    5
       FCB    $01,$E7,$05,$2A,$1B
*    lg ligne 256+64=320 (marge=0)
TAB3   FCB    5
       FCB    $01,$40,$05,$2A,$1B
TAB4   FCB    13
       FCB    $0A,$0D          LF CR
       FCB    $40,$1B
       FCB    $00,$55,$1B      undir off
*    pica espacement normal
       FCB    $00,$33,$7E,$1B
       FCB    $32,$1B          1/6 pouce
TAB5   RMB    15

SCOP   LDX    #$0000
       LDA    #$05        72p/p  max 576
       STA    TAB3+3,PCR
       TST    TAB5+5,PCR
       BEQ    SCO1

       LDA    #$07        144p/p max1152
       STA    TAB3+3,PCR
       LEAX   $140,X      320 pts

SCO1   LEAX   $140,X      320 pts
       LDB    #$08
       LDA    TAB5+2,PCR  nb colonnes
       TST    TAB5+5,PCR
       BEQ    SCO2

       ASLA
SCO2   MUL
       LEAX   D,X
       STX    TAB3+1,PCR
       STD    TAB5+1,PCR

       LDA    #$0A
       STA    TAB5+4,PCR

       LDX    #STAD
       STX    TAB5+7,PCR
       LDD    TAB5+3,PCR  nb ligne
       TSTA
       BEQ    SDE1
       LBSR   FOR2
SDE1   PSHS   X
       LEAX   TAB1,PCR    interligne
       LBSR   FOR0
       LEAX   TAB3,PCR    longueur lg
       LBSR   FOR0
       PULS   X

       LDD    TAB5+1,PCR  nb colonnes
       PSHS   A
       TFR    B,A
       TSTA
       BEQ    SDE2
       CLRB
       LBSR   FOR2
SDE2   PULS   A
       TSTA
       BEQ    SDE3
       DECA
       PSHS   A
       LDA    #$FF
       LBSR   FOR2
       LBSR   IMP0
       BRA    SDE2

SDE3   CLR    TAB5+10,PCR

SDE4   LDA    #$08
       STA    TAB5+11,PCR
SDE5   CLR    TAB5+12,PCR
       CLR    TAB5+13,PCR
       LDB    TAB5+10,PCR
       LDX    TAB5+7,PCR
       LEAX   B,X
SDE6   LDA    TAB5+11,PCR
       STA    TAB5+14,PCR

       TST    TAB5+6,PCR
       BNE    SDE7
       LBSR   RAMA        0 -> ramA
       BRA    SDE8
SDE7   LBSR   RAMB        1 -> ramB

SDE8   LDB    ,X

SDE9   RORB
       TFR    CC,A
       DEC    TAB5+14,PCR
       BNE    SDE9
       TFR    A,CC

SDE10  ROL    TAB5+13,PCR
       INC    TAB5+12,PCR
       LDA    TAB5+12,PCR
       CMPA   #$08        fin col caract
       BEQ    SDE11
       LEAX   $28,X       ligne suivante
       BRA    SDE6

SDE11  DEC    TAB5+11,PCR  -1 col caract
       LDB    TAB5+13,PCR bits col carac

       BSR    IMP0        ecrit col car

       LDA    TAB5+11,PCR
       BNE    SDE5        si>0 continuer


       TST    TAB5+5,PCR  flag scrmod
       BEQ    COL0
       TST    TAB5+6,PCR  flag ram ecran
       BNE    COL0
       INC    TAB5+6,PCR
       BRA    SDE4

COL0   CLR    TAB5+6,PCR

       INC    TAB5+10,PCR
       LDA    TAB5+10,PCR
       CMPA   #$28        nb colonnes
       LBNE   SDE4

       INC    TAB5+9,PCR

       LDB    #$0D        fin de ligne
       BSR    IMP0
       PSHS   X
       LEAX   TAB1,PCR    interligne
       BSR    FOR0
       PULS   X
       LDB    #$0A
       BSR    IMP0

       LDA    TAB5+9,PCR
       CMPA   #$19        nb lignes
       LBEQ   FIN2        fin ecran

       LDD    #$0140
       LDX    TAB5+7,PCR
       LEAX   D,X
       STX    TAB5+7,PCR
       LBRA   SDE1

FOR0   LDA    ,X          transf tab(s)
FOR1   LDB    A,X
       BSR    IMP0
       DECA
       BNE    FOR1
       RTS
FOR2   BSR    IMP0
       DECA
       BNE    FOR2
       RTS

RAMA   LDA    PRC         ecran forme
       ORA    #$01
       STA    PRC
       RTS

RAMB   LDA    PRC         ecran fond
       ANDA   #$FE
       STA    PRC
       RTS

IMP0   JMP    RSCO

DCOP   LDD    #$060A
       STD    TAB5+3,PCR
       LDD    #$5700
       STD    TAB5+1,PCR
DDE0   LDX    #STAD
       LEAX   -40,X
       STX    TAB5+7,PCR flag limite ecr
       LDY    #ENDAD
       LEAY   -40,Y
       LDD    TAB5+3,PCR
       BSR    FOR2
DDE2   CLR    TAB5+9,PCR 4bits poid fort
DDE3   PSHS   X
       LEAX   TAB1,PCR    interligne
       BSR    FOR0
       LEAX   TAB2,PCR    longueur lg
       BSR    FOR0
       PULS   X

       LDD    TAB5+1,PCR
       BSR    FOR2
       TFR    Y,X        Y->X  adr octet

GPL0   TST    TAB5+6,PCR  flag ram ecran
       BNE    GPL1
       BSR    RAMA        0 -> ramA
       BRA    GPL2
GPL1   BSR    RAMB        1 -> ramB
GPL2   LDA    ,X
       TST    TAB5+5,PCR  flag scrmod
       BEQ    GPL3
       TFR    A,B
       BRA    IMP1
GPL3   CLRB
       TST    TAB5+9,PCR  flag passe
       BEQ    GPL4
       ROLA
       ROLA
       ROLA
       ROLA
GPL4   ROLA
       BCS    GPL8
GPL5   ROLA
       BCS    GPL9
GPL6   ROLA
       BCS    GPL10
GPL7   ROLA
       BCS    GPL11
       BRA    IMP1
GPL8   LDB    #$C0
       BRA    GPL5
GPL9   ADDB   #$30
       BRA    GPL6
GPL10  ADDB   #$0C
       BRA    GPL7
GPL11  ADDB   #$03

IMP1   LBSR   IMP0        copie
       LBSR   IMP0
       LEAX   -40,X      on remonte 1 lg
       CMPX   TAB5+7,PCR borne 3FD8/4000
       BNE    GPL2        2eme passe
       LDB    #$0D        FIN2 de lg
       LBSR   IMP0
       PSHS   X
       LEAX   TAB1,PCR    interlg
       LBSR   FOR0
       PULS   X
       LDB    #$0A
       LBSR   IMP0
       TST    TAB5+5,PCR
       BEQ    IMP2
       INC    TAB5+9,PCR
IMP2   TST    TAB5+9,PCR
       BNE    COL1       si S=1 -> COL 0
       INC    TAB5+9,PCR 4 b poid faible
       LBRA   DDE3

COL1   TST    TAB5+5,PCR  flag scrmod
       BEQ    COL3
       TST    TAB5+6,PCR  flag ram ecran
       BNE    COL2        si  1 -> RAMA
       INC    TAB5+6,PCR
       LBRA   DDE2
COL2   CLR    TAB5+6,PCR
COL3   LEAY   1,Y
       CMPY   #ENDAD
       BEQ    FIN2
       INC    TAB5+8,PCR
       LBRA   DDE2

FIN2   LEAX   TAB4,PCR
       LBSR   FOR0
       LDA    CLOSE
       STA    RSOPC
       LBSR   IMP0
       PULS   U,Y,X,DP,B,A,CC,PC
       END
