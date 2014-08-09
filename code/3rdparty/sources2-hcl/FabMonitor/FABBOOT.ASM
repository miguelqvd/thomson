****************************************
*         BOOT / FAB-Monitor           *
****************************************

       ORG    $6200

       ORCC   #80     stop interruptions
       LDS    #$60CC  init. pile système
       LDX    #$6280   charge le menu
       LDY    #$0002   (secteur 00.02)
       LDD    #$4158  exécution finale
       PSHS   D
       LDD    #$0700  (face0;7 secteurs)
       BSR    DISK
       LDD    >$6286
       JMP    D,X
       FCC    "    "
       FCC    "FAB-Monitor v3.1 / BOOT "
       FCC    " (c) by Laurent Hiriart "
       FCC    "   "

DISK   LDU    #$6048
       STB    1,U     face          : B
       LDB    #2
       STB    ,U
       STY    3,U     piste.secteur : Y
       STX    7,U     buffer        : X
       LDB    4,U     secteur -> B
CHARGE JSR    $E004
       BCS    CHARGE
       CMPB   #16     fin piste ?
       BNE    NXTSEC
       INC    3,U
       CLRB
NXTSEC INCB
       STB    4,U
       INC    7,U
       DECA
       BNE    CHARGE
       RTS

****************************************
* Valeur-test: "BASIC2.." complémenté: *
****************************************

       FDB    $BEBF,$ADB7,$BDCE,$A200

* 128 octets de texte :

       FCC    "----------------"
       FCC    "FAB-Monitor v3.1"
       FCC    "----------------"
       FCC    "Distribue par : "
       FCC    "ASCI, 365 Chemin"
       FCC    "  des Montants, "
       FCC    "  54690 EULMONT "
       FCC    "Tel: 83.22.84.14"

       END
