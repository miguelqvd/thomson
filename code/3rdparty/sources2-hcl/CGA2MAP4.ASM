****************************************
*Conversion d'une image CGA en BITMAP-4*
****************************************
********* (c) Doctor Lô 1991 ***********


BANK   EQU    15      où est l'image CGA
DIR    EQU    $9E      accès direct au
Z      EQU    $FD     buffer "variables"

       ORG    $9E00
G      ORCC   #80
       PSHS   DP
       LDA    #DIR
       TFR    A,DP
       LDA    #33     mode BITMAP4 plans
       STA    $E7DC

       LDU    #$A000  source CGA
       LDX    #$A000  } destination TO
       LDY    #$C000  }


       LDA    #40     une ligne = 40 o.
       STA    <Z+2    (sur chaque plan)
LIGNE  CLR    <Z      }
       CLR    <Z+1    } pour les calculs

       LDD    #$8080
       BITA   ,U      premier octet CGA
       BEQ    *+6      =4 bits forts du
       ORB    <Z+1     premier octet de
       STB    <Z+1    chaque bitplan TO.
       LDD    #$4080
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$2040
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$1040
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0820
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0420
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0210
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0110
       BITA   ,U+
       BEQ    *+6
       ORB    <Z
       STB    <Z

       LDD    #$8008
       BITA   ,U      deuxième octet CGA
       BEQ    *+6     =4 bits faibles du
       ORB    <Z+1     premier octet de
       STB    <Z+1    chaque bitplan TO.
       LDD    #$4008
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$2004
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$1004
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0802
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0402
       BITA   ,U
       BEQ    *+6
       ORB    <Z
       STB    <Z
       LDD    #$0201
       BITA   ,U
       BEQ    *+6
       ORB    <Z+1
       STB    <Z+1
       LDD    #$0101
       BITA   ,U+
       BEQ    *+6
       ORB    <Z
       STB    <Z

       CLR    $E7E5   affichage écran de
       LDD    <Z
       STA    ,X+     1er octet bitplanB
       STB    ,Y+     1er octet bitplanA
       LDA    #BANK
       STA    $E7E5   retour image CGA.
       DEC    <Z+2
       LBNE   LIGNE

       LEAU   $1FB0,U entrelacement CGA:
       CMPU   #$DF40  une ligne sur deux
       BLO    *+6       =>  A000
       LEAU   -$3FB0,U      C000
       CMPX   #$BF40        A050
       LBNE   LIGNE-4       C050 ...

       PULS   DP,PC   see you later !
       END
