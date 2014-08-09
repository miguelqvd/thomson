****************************************
*                                      *
*   Restitution d'un son TO8 compilé   *
*                                      *
****************************************

BSOUND EQU    $7600   adresse début son
ESOUND EQU    $DE96   adresse fin du son


       ORG    $7500

G      ORCC   #80
       LDA    $E7C5        autorise
       ORA    #1          sortie son
       STA    $E7C5
       LDA    $E7C1
       ANDA   #$F7
       STA    $E7C1

       CLR    $E7CF     définition son
       LDD    #$3F04
       STA    $E7CD     merci Gaël !!!
       STB    $E7CF

       LDX    #BSOUND
PLAY   LDA    ,X+
       LDA    -1,X
       LSRA
       LSRA
       TST    ,-X
       STA    $E7CD
       BSR    WAIT

       LDA    ,X+     6
       ANDA   #3      2
       STA    *+8     5  attention ! les
       LDA    ,X      4  temps d'attente
       LSRA           2  sont identiques
       LSRA           2  pour chaque son
       ORA    #0      2    (cf cycles)
       STA    $E7CD   5
       BSR    WAIT

       LDA    ,X+
       ASLA
       ASLA
       STA    *+8
       LDA    ,X
       ANDA   #3
       ORA    #0
       STA    $E7CD
       BSR    WAIT

       LDA    ,X
       TST    ,X+
       NOP
       LSRA
       LSRA
       STA    $E7CD
       BSR    WAIT
       CMPX   #ESOUND
       BLO    PLAY
       SWI

WAIT   LDA    #16
       DECA
       BNE    *-1
       RTS

       END
