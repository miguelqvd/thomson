*********************************
*          *                    *
* PATRIOTE * Affichage OVERSCAN *
*          *                    *
*********************************
*                               *
* AFFICHAGE DU DRAPEAU FRANCAIS *
*                               *
*********************************
*                               *
* Pour ASCINEWS 3 / ASSEMBLEUR6 *
* Michel SAINT-BRIANT / ASCI(C) *
*                               *
*********************************


       ORG    $8000

       PSHS   U,Y,X,DP,B,A,CC
G      ORCC   #$50
       LDU    #$E7DD
       LDY    #$E7E7
ATTRA0 LDA    ,Y
       BPL    ATTRA0
ATTRA1 LDA    ,Y
       BMI    ATTRA1
       LDX    #624
       LDY    #750    =750/25=30 s
       LDB    #4
       STB    ,U
       BRA    DEBUT

BLEU   LDB    #4      2 us     ) ROUGE
       STB    ,U      4 us  ___)__6 us
       NOP            )        )
       NOP            )        )
       NOP            )        ) BLEU
       NOP            ) 7x2 us )
DEBUT  NOP            )        )
       NOP            )        )
       NOP            )        ) 20 us
BLANC  LDB    #7      2 us     )
       STB    ,U      4 us  ___)_______
       NOP            )        )
       NOP            )        )
       NOP            )        ) BLANC
       NOP            ) 7x2 us )
       NOP            )        )
       NOP            )        )
       NOP            )        ) 20 us
ROUGE  LDB    #1      2 us     )
       STB    ,U      4 us  ___)_______
       NOP            )        )
       NOP            )        ) ROUGE
       NOP            ) 5x2 us )
       NOP            )        ) 18 us
       NOP            )        )   +
       LEAX   -1,X    5 us     )  6 us
       BNE    BLEU    3 us  ___)_
       LDB    #4      2 us     )  6 us
       STB    ,U      4 us  ___)_
       LDX    #624    3 us       )
       LEAY   -1,Y    5 us       ) 14 us
       LBNE   BLANC   6 us ______)

FIN    CLR    ,U
       ANDCC  #$AF
K      PULS   CC,A,B,DP,X,Y,U,PC

       END
