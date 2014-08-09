


****************************************
*                                      *
*             C O M M U T              *
*                                      *
****************************************
*                                      *
* Routine de sélection des banques de  *
* la zone mémoire &HA000 - &HDFFF.     *
*--------------------------------------*
*                                      *
*     Manuel de l'assembleur 6809      *
*        du TO7/TO7-70 page 190        *
*                                      *
****************************************

CSR    EQU    $E7C0   Registre d'état

*--------------------------------------*


COMMUT EQU    *
       PSHS   D,X,U
       LDU    #CSR
       LDB    11,U
       ANDB   #$FB
       STB    11,U
       LDX    #TAB
       LDA    A,X
       STA    9,U
       ORB    #$04
       STB    11,U
       PULS   D,X,U,PC
TAB    EQU    *
       FCB    $0F,$17,$E7,$67,$A7,$27
