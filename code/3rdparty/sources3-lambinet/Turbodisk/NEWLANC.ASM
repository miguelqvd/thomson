***************************************
*                                     *
* *     *   *   *  **  **** *  * ***  *
* *    * *  **  * *  * *    *  * *  * *
* *   ***** * * * *    ***  *  * ***  *
* *   *   * *  ** *  * *    *  * * *  *
* *** *   * *   *  **  ****  **  *  * *
*                                     *
***************************************
*                                     *
* ***** *   * ****  ****   ***        *
*   *   *   * *   * *   * *   *   *   *
*   *   *   * *   * *   * *   *   *   *
*   *   *   * ****  ****  *   * ***** *
*   *   *   * *   * *   * *   *   *   *
*   *   *   * *   * *   * *   *   *   *
*   *    ***  *   * ****   ***        *
*                                     *
***************************************
* LANCEUR de TURBO+ (TURBODISK v 2.1) *
* par Michel SAINT-BRIANT - ASCI/1992 *
***************************************

COMPT  EQU    FIN+4   COMPTEUR
NESSAI EQU    FIN+5   NBRE D'ESSAIS
SAVEX  EQU    FIN+6

       ORG    $8000

       LDX    #MESSEN
AFF0   LDB    ,X+
       BEQ    AFF1
       JSR    $E803
       BRA    AFF0
AFF1   LDX    #$6202
       LEAY   ,X++
AFF2   LDB    ,X+
       LEAY   B,Y
       JSR    $E803
       CMPX   #$627F
       BNE    AFF2
       PSHS   Y
       LDD    $62FD   FACE/PISTE
       DECA
       BNE    ADR01
       INCB
       BRA    ADR02
ADR01  LDA    #$01
ADR02  STA    $6049
       STB    $604B
       LDA    $62FA   BANK1
       STA    $E7E5
       JSR    $E09D
       JSR    $E0A7
       JSR    $E452
       JSR    $E341
       LDB    #$18
       JSR    $E394
NBANK  LDA    #$03    1 BANK=3 PISTES
       STA    COMPT
       INC    $E7E5
       LDX    #$A000
       STX    SAVEX   ON SAUVE L'ADRESSE
NPIST  JSR    $E09D
       DEC    <$49    NOUVELLE PISTE
       BEQ    ADR03
       DEC    <$4B
       LDD    #$4001
       STD    <$48
       JSR    $E0A7
       JSR    $E47D
ADR03  LDA    #$08
       STA    NESSAI
       LDX    SAVEX   ON DECALE L'ADRES-
       LEAX   $1556,X SE DE 1/3 BANK
       STX    COMP+1
DEMAR  JSR    $E09D   INITIALISATION DU
       JSR    $E0A7   CONTROLEUR
       JSR    $E47D
       JSR    $E341
       LDB    #$18
       JSR    $E394
       LDA    #$E7
       TFR    A,DP
       LDY    ,S
ADR04  LDA    <$D1
       BITA   #$40
       BEQ    ADR04
ADR05  LDA    <$D3
       LDA    <$D0
       BPL    ADR05
ADR06  LDA    <$D0
       BPL    ADR06
LIRE   LDA    <$D3    LECTURE
ADR16  LDA    <$D0
       BPL    ADR16
       BITA   #$01
       BNE    LIRE
       CLRB
       LDX    SAVEX
       LDA    <$D3
ADR17  LDA    <$D0
       BPL    ADR17
       LDA    <$D3
       CMPA   #$FB
       BEQ    ADR18
       DECB
       BNE    ADR17
       BRA    ERROR
ADR18  LDA    <$D0
       BPL    ADR18
       LDA    <$D3
       STA    ,X+
       LEAY   A,Y
COMP   CMPX   #$E002
       BNE    ADR18
       TFR    Y,D
ADR19  TST    <$D0
       BPL    ADR19
       CMPA   <$D3
       BNE    ERROR
ADR20  TST    <$D0
       BPL    ADR20
       CMPB   <$D3
       BEQ    ADR21
ERROR  DEC    NESSAI
       LBNE   DEMAR
       TST    ,S
       BNE    ILLIC
       TST    1,S
       BNE    ILLIC
       LDX    #MESSPB
       BRA    IMPENC
ILLIC  LDX    #MESSIL
IMPENC LDB    ,X+
       JSR    $E803
       BNE    IMPENC
BSF    BRA    BSF
ADR21  LDX    #COMP+1
       STX    SAVEX
       DEC    COMPT
       LBNE   NPIST
       DEC    $62FB   NBBANK
       LBNE   NBANK
       CLR    <$D0
       LDA    #$40
       STA    <$D2
       PULS   X
       CMPX   #0
       LBEQ   PALETT
       BRA    ILLIC

MESSEN FCB    $1B,$40,$1B,$57,$1B,$67,12
       FCC    #TURBODISK version 2.#
       FCC    #1 A.S.C.I. Copyright#
       FCB    10,10
       FCC    #Licence d'utilisatio#
       FCC    #n no #
       FCB    0

MESSPB FCB    12
       FCC    #Disquette illisible#
       FCB    0
MESSIL FCB    12
       FCC    #Copie illicite#
       FCB    0

FIN    FCC    #012#

PALETT LDX    #$62D8
       LDA    ,X+
       CMPA   #$FF
       BNE    NONPAL
       JSR    $EC00
NONPAL NOP

       END
