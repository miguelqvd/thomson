FONTE  EQU    $A000
TEXTE  EQU    $A5D0
ECRAN  EQU    $5E00
DIR    EQU    $D5
Z      EQU    $40
DEBDEM EQU    $630C
FINDEM EQU    $6370
SHELL  EQU    $637D

       ORG    $D690
       FCB    $B8,$B0,$A8,$A0
       FCB    $98,$90,$88,$80
       ORG    DIR*256+Z
       FDB    $100,$0201,TEXTE,0,0,0,0
       ORG    $A328

G      ORCC   #80
       LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDD    #0
       STD    $E7DC
       LDX    #ECRAN
       LDU    #$D550
       PULU   D
       STD    ,X++
       CMPX   #$5F40
       BNE    *-7
       DEC    $E7C3
       LDA    #40
       LDB    ,U+
       STB    ,-X
       DECA
       BNE    *-3
       CMPU   #$D698
       BNE    *-13
       LDD    #$C0C0
       STD    ,--X
       CMPX   #$4000
       BNE    *-5
       INC    $E7C3
       LDX    #COLORS
       LDA    #255
       JSR    $EC00
       LDB    #DIR
       TFR    B,DP
       LDY    <Z+4

SYNCRO LDA    $E7E7
       BPL    *-3
       LDA    $E7E7
       BMI    *-3

       LDB    <Z+3
       BEQ    *+6
       DEC    <Z+3
       BRA    FINJOY+2
       LDA    #4
       STA    <Z+3
       LDB    <Z
       LDA    $E7CC
       BITA   #4
       BNE    EST
       DECB
       BMI    FINJOY+2
       BRA    FINJOY
EST    BITA   #8
       BNE    FINJOY+2
       INCB
       CMPB   #8
       BEQ    FINJOY+2
FINJOY STB    <Z

       LDA    $E7CD
       BITA   #64
       LBEQ   SORTIE

       LDB    <Z
BOUCLE STB    <Z+1
       BEQ    FINSCR
       JSR    SCROLL
       LDB    <Z+1
       DECB
       BRA    BOUCLE

FINSCR JSR    $E806
       CMPB   #87
       BNE    PAWARP
       LDA    #$25
       STA    PAWARP+2
PAWARP CMPB   #$90
       BRA    SYNCRO
       SUBB   #$90
       LDU    #COLORS+2
       LDB    B,U
       LDA    #$63
       STD    FINDEM
       JMP    SORTIE

SCROLL LDX    #ECRAN+20
       LDU    #DIR*256+Z+6
       LDA    #8
       ASL    ,U+
       ROL    19,X
       ROL    18,X
       ROL    17,X
       ROL    16,X
       ROL    15,X
       ROL    14,X
       ROL    13,X
       ROL    12,X
       ROL    11,X
       ROL    10,X
       ROL    9,X
       ROL    8,X
       ROL    7,X
       ROL    6,X
       ROL    5,X
       ROL    4,X
       ROL    3,X
       ROL    2,X
       ROL    1,X
       ROL    ,X
       ROL    -1,X
       ROL    -2,X
       ROL    -3,X
       ROL    -4,X
       ROL    -5,X
       ROL    -6,X
       ROL    -7,X
       ROL    -8,X
       ROL    -9,X
       ROL    -10,X
       ROL    -11,X
       ROL    -12,X
       ROL    -13,X
       ROL    -14,X
       ROL    -15,X
       ROL    -16,X
       ROL    -17,X
       ROL    -18,X
       ROL    -19,X
       ROL    -20,X
       LEAX   40,X
       DECA
       BNE    SCROLL+8
       DEC    <Z+2
       BEQ    *+3
       RTS
       LDB    ,Y+
       BNE    *+8
       LDY    #TEXTE
       LDB    #2
       ANDB   #254
       LSRB
       LDA    #8
       STA    <Z+2
       MUL
       LDU    #FONTE-8
       LEAU   D,U
       PULU   D,X
       STD    <Z+6
       STX    <Z+8
       PULU   D,X
       STD    <Z+10
       STX    <Z+12
       RTS

SORTIE STY    <Z+4
       LDX    #ECRAN
       LDU    #$D550
       LDD    ,X++
       STD    ,U++
       CMPX   #$5F40
       BNE    *-7
       LDU    FINDEM
       JMP    SHELL

ERROR  LDA    $E7C3
       ORA    #1
       STA    $E7C3
       LDD    #0
       STD    $E7DC
       LDX    #COLORS+32
       LDU    #PHRASE+25
       LDB    <$4E
       LSRB
       LSRB
       LSRB
       LSRB
       LDA    B,X
       LDB    <$4E
       ANDB   #15
       LDB    B,X
       STD    ,U++
       LDB    <$48
       LDA    B,X
       LDB    <$49
       LDB    B,X
       STD    ,U++
       LDB    <$4B
       LSRB
       LSRB
       LSRB
       LSRB
       LDA    B,X
       LDB    <$4B
       ANDB   #15
       LDB    B,X
       STD    ,U++
       LDB    <$4C
       LSRB
       LSRB
       LSRB
       LSRB
       LDA    B,X
       LDB    <$4C
       ANDB   #15
       LDB    B,X
       STD    ,U

       LDX    #$4078
       LDY    #PHRASE
       LDB    ,Y+
       JSR    PRINT
       CMPX   #$40A0
       BNE    *-8
       LDX    #$41B8
       LDB    ,Y+
       JSR    PRINT
       CMPX   #$41E0
       BNE    *-8

       DEC    $E7C3
       LDX    #$4140
       LDU    #$D698
       LDA    #40
       LDB    ,-U
       STB    -320,X
       STB    ,X+
       DECA
       BNE    *-7
       CMPU   #$D690
       BNE    *-17
       LDD    #$C0C0
       STD    ,X++
       CMPX   #$5F40
       BNE    *-5
       LDX    #COLORS
       LDA    #255
       JSR    $EC00
       TST    $E7C8
       BEQ    *-3
       JMP    G
PRINT  LDA    #8
       SUBB   #32
       MUL
       LDU    #FONTE
       LEAU   D,U
       PULU   D
       STA    -120,X
       STB    -80,X
       PULU   D
       STA    -40,X
       STB    ,X+
       PULU   D
       STA    39,X
       STB    79,X
       PULU   D
       STA    119,X
       STB    159,X
       RTS

COLORS FDB    0,$0C12,$181E,$4C52,$585E
       FDB    $646A,4080,4095
       FDB    $EE,$CE,$AE,$8E
       FDB    $6E,$4E,$2E,$0E
       FCC    /0123456789ABCDEF/
PHRASE FCC    /       Erreur disque/
       FCC    /tte #00000000       /
       FCC    /         Appuyez sur/
       FCC    / une touche         /

       END
