****************************************
* Divise un mot de 8 bits par un autre *
*   Le résultat est codé sur 16 bits   *
****************************************

       ORG    $9000
DIR    EQU    $9F
Z      EQU    0

G      ORCC   #80
       LDA    #DIR
       TFR    A,DP
       LDA    #4
       LDB    #192
       STD    <Z


       CLRB             partie entière
       CMPA   <Z+1        sur 8 bits
       BLO    *+7
       SUBA   <Z+1
       INCB
       BRA    *-7
       STB    <Z+2

       CLRB            partie "décimale"
       ASLA                (256èmes)
       BCS    *+6
       CMPA   <Z+1        sur 8 bits
       BLO    *+6
       SUBA   <Z+1
       ORB    #128
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #64
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #32
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #16
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #8
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #4
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #2
       ASLA
       BCS    *+6
       CMPA   <Z+1
       BLO    *+6
       SUBA   <Z+1
       ORB    #1
       STB    <Z+3

       LDX    <Z
       LDY    <Z+2
       SWI

       END
