****************************************
*                                      *
*            Set-Prevs BOOT            *
*                                      *
****************************************
*   (c) By Laurent HIRIART 6-10-1991   *
*                                      *
* 6280: les 16 nouvelles palettes.     *
* 62A0: texte ASCII, terminé par 0.    *
* 62FF: flags (NoAutoBat? ; NewPal?).  *
****************************************

       ORG    $6200
       LDX    #$6200   le programme se
COPY   LDB    ,X+       copie en $7200
       STB    $FFF,X   pour pas se faire
       CMPX   #$6300    buter pas les
       BNE    COPY     initialisations!
       JMP    $7211
BSTART CLR    >0      ROM0 -> cartouche
       JSR    $2B42   voir ($2B52) ROM0
       LDS    #$9FFF
       CLR    >1      ROM1 -> cartouche
       JSR    $193
       COM    <$31
       STS    $6C43
       CLR    >0      ROM0 -> cartouche
       JSR    $2D00
       LDA    #2      } copie de ($2B74)
       LDX    #$100   }
       JSR    $3A13   }
       LDA    #$80    }
       STA    $6768   }
       JSR    $342F     } cf ($2B1A)
       LDA    #4        }
       STA    $6C42     }
       LDX    #$6300    }
       STX    $6027     }
       LDA    $6019     }
       ORA    #$20      }
       STA    $6019     }
       LDA    #$FF      }
       STA    $603A     }
       JSR    $43B    }
       LDX    #$72A0  affichage du texte
       LDB    ,X+      de l'utilisateur
       JSR    $E803
       BNE    *-5
       LDA    $62FF   les 2 Flags :
       BPL    *+5
       CLR    $607F   ->pas d'AUTO.BAT !
       ASLA
       BEQ    *+10
       LDA    #-1     ->nouvelle palette
       LDX    #$7280
       JSR    $EC00
       JMP    $2BAD   retour BASIC /ROM0

****************************************
* Valeur-test: "BASIC2.." complémenté: *
****************************************

       ORG    $6278
       FDB    $BEBF,$ADB7,$BDCE,$0000

       END
