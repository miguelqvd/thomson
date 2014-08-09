****************************************
*                                      *
*   SHELL = INTERFACE LOADER / DEMOS   *
*                                      *
****************************************


RETURN EQU    $A328
ERROR  EQU    $A483
       ORG    $6300

DEMOS  FDB    $DA5,$010A,$3BFF
       FDB    $FA9,$0505,$37FF
       FDB    $FB9,$3501,$27FF
       FDB    $FC2,$080C,$1EFF
       FDB    $FB0,$2507,$30FF
       FDB    $3A0,$A0A,$2904,$A00D,$329
       FDB    $5A0,$F0C,$2906,$A012,$529
       FDB    $7A0,$140E,$2908,$A017
       FDB    $729
       FDB    $9A0,$1910,$290A,$A01C
       FDB    $929,$FC1,$1F02,$1FFF
       FDB    $FA0,$2107,$40FF
       FDB    $FDA,$2101,$06FF
       FDB    $F7B,$2807,$4D00
       FDB    $FC3,$2D04,$1DFF
       FDB    $FA7,$2F01,$39FF
       FDB    $FB9,$320A,$27FF
FINDEM FDB    DEMOS

G      ORCC   #80
       LDS    #$60CC
       LDB    #1
       JSR    $EC0C

       LDD    #32
       STA    $E7DB
       STA    $E7DA
       DECB
       BNE    *-4
       LDD    #0
       STD    $E7DC

INTRO  LDD    #$6002
       TFR    A,DP
       STB    <$48
       CLR    <$49
       CLR    <$50
       LDU    FINDEM

KOILIR LDB    ,U
       STB    $E7E5
       LDB    2,U
       LDX    #0
       ABX
       LDB    4,U
       LDY    #0
       LEAY   B,Y
       LDB    3,U
       LDA    1,U
       JSR    DISK
       LDX    #$DFA2
       LEAU   5,U
       TST    ,U
       BMI    *+9
       BEQ    *+4
       BRA    KOILIR
       LDX    #$9695
       LEAU   1,U
       CMPU   #FINDEM
       BNE    *+5
       LDU    #DEMOS+12
       STU    FINDEM
       JSR    ,X
       LDD    #$E7
       TFR    B,DP
       LDB    #32
       STA    <$DB
       STA    <$DA
       DECB
       BNE    *-3
       LDX    FINDEM
       CMPX   #DEMOS+6
       BEQ    INTRO
       LDA    #13
       STA    $E7E5
       JMP    RETURN

DISK   STX    <$4A
       STB    <$4C
       STA    <$4F
CHARGE JSR    $E004
       BCC    *+10
       LDA    #13
       STA    $E7E5
       JMP    ERROR
       INCB
       CMPB   #17
       BNE    GOON
       LDB    #1
       LEAX   1,X
       STX    <$4A
GOON   STB    <$4C
       INCA
       STA    <$4F
       LEAY   -1,Y
       BNE    CHARGE
       RTS
RESET  ORCC   #80
       LDD    #32
       STA    $E7DB
       STA    $E7DA
       DECB
       BNE    *-4
       STD    $E7DC
       LDA    #15
       STA    $E7E5
       LDU    #COLORS-6
       PULU   D,X,Y,S
       LDU    #$E000
ERASE  FDB    $3676,$3676,$3676,$3676
       FDB    $3676,$3676,$3676,$3676
       FDB    $3676,$3676,$3676,$3676
       FDB    $3676,$3676,$3676,$3676
       CMPU   #$A000
       BNE    ERASE
       DEC    $E7E5
       BRA    ERASE-3

       FDB    0,0,0
COLORS FDB    0,15,240,255,3840,3855
       FDB    4080,4095,1911,826,931
       FDB    938,2611,2618,3815,123
       END
