*********************
*                   *
*    SCREEN.ASM     *  DISQUE RESEAU 1
*                   *
*********************

       ORG    $A000
       PSHS   A,B,X,Y,U,DP
       LDB    CHOIX,PCR
       CLR    ADR,PCR
       CLR    ADR1,PCR
       CLR    ADR4,PCR
       CMPB   #$02
       BHI    SUIT1
       BRA    ROUT1
SUIT1  CMPB   #$0A
       BHI    SUIT2
       BRA    ROUT2
SUIT2  PULS   A,B,X,Y,U,DP
       RTS
*****************************
****SYMETRIE I (H VERS B)****
*****************************
ROUT1  LDD    #$4027
       STD    ADR2,PCR
       LDD    #$F78
       STD    ADR4,PCR
       LDX    #$4000
DEBUT1 TFR    X,D
       ADDD   ADR4,PCR
       ADDD   ADR4,PCR
       ADDD   #$28
       TFR    D,Y
       LBSR   RAMA
       LDA    ,X
       LDB    CHOIX,PCR
       CMPB   #$02
       BNE    SYMI11
       LDB    ,Y
       STB    ,X
SYMI11 STA    ,Y
       LBSR   RAMB
       LDA    ,X
       LDB    CHOIX,PCR
       CMPB   #$02
       BNE    SYMI12
       LDB    ,Y
       STB    ,X
SYMI12 STA    ,Y
       LEAX   1,X
       CMPX   ADR2,PCR
       BLS    ENCOR1
       LDD    ADR2,PCR
       ADDD   #$28
       STD    ADR2,PCR
       LDD    ADR4,PCR
       SUBD   #$28
       STD    ADR4,PCR
ENCOR1 CMPX   #$4FA0
       BNE    DEBUT1
       PULS   A,B,X,Y,U,DP
       RTS
******************************
****SYMETRIE II (D VERS G)****
******************************
ROUT2  LDX    #$4000
       CLR    ADR2,PCR
       LDA    #$27
       STA    ADR3,PCR
DEBUT2 TFR    X,D
       ADDD   ADR2,PCR
       TFR    D,Y
       BSR    SUB2
       LEAX   40,X
       CMPX   #$5F3F
       BLS    ENCOR2
       TFR    X,D
       SUBD   #$1F3F
       TFR    D,X
       LDA    ADR3,PCR
       SUBA   #$02
       STA    ADR3,PCR
ENCOR2 CMPX   #$4014
       BNE    DEBUT2
       PULS   A,B,X,Y,U,DP
       RTS
************
****SUB2****
************
SUB2   LDA    CHOIX,PCR
       CMPA   #$03
       BNE    CONT1
       BRA    SUB3
CONT1  CMPA   #$04
       BNE    CONT2
       BRA    SUB4
CONT2  CMPA   #$05
       BNE    CONT3
       BRA    SUB5
CONT3  CMPA   #$06
       BNE    CONT4
       BRA    SUB6
CONT4  CMPA   #$07
       BNE    CONT5
       LBRA   SUB7
CONT5  CMPA   #$08
       BNE    CONT6
       LBRA   SUB8
CONT6  CMPA   #$09
       BNE    CONT7
       LBRA   SUB9
CONT7  LBRA   SUB10
************
****SUB3****
************
SUB3   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA1
       STA    ,Y
       LBSR   RAMB
       LDA    ,X
       STA    ,Y
       RTS
************
****SUB4****
************
SUB4   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA1
       STA    ,Y
       LBSR   RAMB
       LDA    ,X
       LBSR   TRA1
       STA    ,Y
       RTS
************
****SUB5****
************
SUB5   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA2
       STA    ADR5,PCR
       LBSR   RAMB
       LDA    ADR5,PCR
       STA    ,Y
       LDA    ,X
       LBSR   TRA2
       STA    ADR5,PCR
       LBSR   RAMA
       LDA    ADR5,PCR
       STA    ,Y
       RTS
************
****SUB6****
************
SUB6   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA1
       STA    ADR5,PCR
       LBSR   RAMB
       LDA    ADR5,PCR
       STA    ,Y
       LDA    ,X
       LBSR   TRA1
       STA    ADR5,PCR
       LBSR   RAMA
       LDA    ADR5,PCR
       STA    ,Y
       RTS
************
****SUB7****
************
SUB7   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA1
       STA    ADR6,PCR
       LDA    ,Y
       LBSR   TRA1
       STA    ,X
       LDA    ADR6,PCR
       STA    ,Y
       LBSR   RAMB
       LDA    ,X
       LDB    ,Y
       STA    ,Y
       STB    ,X
       RTS
************
****SUB8****
************
SUB8   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA1
       STA    ADR6,PCR
       LDA    ,Y
       LBSR   TRA1
       STA    ,X
       LDA    ADR6,PCR
       STA    ,Y
       LBSR   RAMB
       LDA    ,X
       LBSR   TRA1
       STA    ADR6,PCR
       LDA    ,Y
       LBSR   TRA1
       STA    ,X
       LDA    ADR6,PCR
       STA    ,Y
       RTS
************
****SUB9****
************
SUB9   LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA2
       STA    ADR6,PCR
       LBSR   RAMB
       LDA    ,Y
       LBSR   TRA2
       TFR    A,B
       LDA    ADR6,PCR
       STA    ,Y
       LBSR   RAMA
       STB    ,X
       LBSR   RAMB
       LDA    ,X
       LBSR   TRA2
       STA    ADR6,PCR
       LBSR   RAMA
       LDA    ,Y
       LBSR   TRA2
       TFR    A,B
       LDA    ADR6,PCR
       STA    ,Y
       LBSR   RAMB
       STB    ,X
       RTS
*************
****SUB10****
*************
SUB10  LBSR   RAMA
       CLRA
       RORA
       LDA    ,X
       LBSR   TRA1
       STA    ADR6,PCR
       LBSR   RAMB
       LDA    ,Y
       BSR    TRA1
       TFR    A,B
       LDA    ADR6,PCR
       STA    ,Y
       BSR    RAMA
       STB    ,X
       BSR    RAMB
       LDA    ,X
       BSR    TRA1
       STA    ADR6,PCR
       BSR    RAMA
       LDA    ,Y
       BSR    TRA1
       TFR    A,B
       LDA    ADR6,PCR
       STA    ,Y
       BSR    RAMB
       STB    ,X
       RTS
************
****TRA1****
************
TRA1   TFR    A,B
       ANDA   #$F0
       ANDB   #$0F
       RORA
       RORA
       RORA
       RORA
       ROLB
       ROLB
       ROLB
       ROLB
       STB    ADR5,PCR
       ORA    ADR5,PCR
       TFR    A,B
       ANDA   #$CC
       ANDB   #$33
       RORA
       RORA
       ROLB
       ROLB
       STB    ADR5,PCR
       ORA    ADR5,PCR
       TFR    A,B
       ANDA   #$AA
       ANDB   #$55
       RORA
       ROLB
       STB    ADR5,PCR
       ORA    ADR5,PCR
       RTS
************
****TRA2****
************
TRA2   TFR    A,B
       ANDA   #$0F
       ANDB   #$F0
       ROLA
       ROLA
       ROLA
       ROLA
       RORB
       RORB
       RORB
       RORB
       STB    ADR5,PCR
       ORA    ADR5,PCR
       RTS
************
****RAMA****
************
RAMA   LDA    >$E7C3
       ORA    #$01
       STA    >$E7C3
       RTS
************
****RAMB****
************
RAMB   LDA    >$E7C3
       ANDA   #$FE
       STA    >$E7C3
       RTS
*****************
CHOIX  FCB    $00
ADR    FCB    00
ADR1   FCB    00
ADR2   FCB    00
ADR3   FCB    00
ADR4   FCB    00
ADR5   FCB    00
ADR6   FCB    00
       END
