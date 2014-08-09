***************************************
*                                     *
* ******  ****  **     ** **      **  *
*   **   **  ** ***   ***        ***  *
*   **   **  ** ** * * ** **    ****  *
*   **   **  ** **  *  ** **      **  *
*   **   **  ** **     ** **      **  *
*   **   **  ** **     ** **      **  *
*   **    ****  **     ** **     **** *
*                                     *
***************************************


FIN    EQU    $9100


       ORG    $9000

TOMI1  PSHS   U,Y,X,DP,B,A,CC
       LDA    #$E7
       PSHS   A
       TFR    A,DP
TOMI2  LDU    #$A000
TOMI3  LDA    $E7C3
       ANDA   #8
       BNE    SORTIE
       LDA    #$08
       STA    ,S
       LDA    <$CA
       ANDA   #$C4
       STA    <$CA
       LDA    <$C8
       LDY    #$0000
       LDB    #$1E
TEMPO  LEAY   -1,Y
       BNE    TOMI4
       DECB
       BEQ    TOMI11
       LDY    #$0000
TOMI4  LDA    <$CA
       BITA   #$40
       BEQ    TEMPO
       ANDCC  #$FE
       LDX    #$0013
TOMI5  LEAX   -1,X
       BNE    TOMI5
TOMI6  BCC    TOMI8
       BSR    TOMI13
       BCS    TOMI7
       RORB
       ANDCC  #$FE
       BRA    TOMI10
TOMI7  RORB
       ORCC   #$01
       BRA    TOMI10
TOMI8  BSR    TOMI15
       BCC    TOMI9
       RORB
       ORCC   #$01
       BRA    TOMI10
TOMI9  RORB
       ANDCC  #$FE
       BRA    TOMI10
TOMI10 DEC    ,S
       BNE    TOMI6
       ANDB   #$7F
       BRA    TOMI12
TOMI11 LDB    #$00
TOMI12 STB    ,U+
       CMPU   #$E000
       BNE    TOMI3
       INC    $E7E5
       LDA    $E7E5
       CMPA   #$10    ou $20 si 512Ko
       BLO    TOMI2
SORTIE STU    FIN
       LDA    $E7E5
       STA    FIN+2
       PULS   A
       PULS   CC,A,B,DP,X,Y,U,PC

TOMI13 LDA    <$CA
       ANDA   #$C4
       STA    <$CA
       LDA    <$C8
       BSR    TEMPO1
       LDA    <$CA
       ANDA   #$40
       BNE    TOMI16
TOMI14 ORCC   #$01
       RTS
TOMI15 LDA    <$CA
       ORA    #$10
       STA    <$CA
       LDA    <$C8
       BSR    TEMPO1
       LDA    <$CA
       ANDA   #$40
       BNE    TOMI14
TOMI16 ANDCC  #$FE
       RTS
TEMPO1 LDX    #$005E
TEMPO2 LEAX   -1,X
       BNE    TEMPO2
       RTS

       END
