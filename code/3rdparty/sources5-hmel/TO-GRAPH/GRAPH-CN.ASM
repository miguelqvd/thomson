       TITLE  TO-GRAPH: constantes
*      ------------------------------
       PAGE

****************************************
*                                      *
*           constantes                 *
*                                      *
****************************************

****************************************
*           F E N E T R E S            *
****************************************

* Fenêtre principale
*---------------------------------------

FENPR  FCB    FEDI,ESC,$4E,0
       FCB    FLOCA,0,5,1,16
       FCB    FEDI
       FCC    \FICHIERS\
       FCB    0
       FCB    FINVVD
       FCB    FLOCA,0,23,1,12
       FCB    FEDI
       FCC    \TIROIR\
       FCB    0
       FCB    FINVVD
       FCB    FLOCA,0,37,1,14
       FCB    FEDI
       FCC    \CADRAGE\
       FCB    0
       FCB    FINVVD
       FCB    FLOCA,0,53,1,12
       FCB    FEDI
       FCC    \ALBUMS\
       FCB    0
       FCB    FINVVD
       FCB    FLOCA,0,67,1,12
       FCB    FEDI
       FCC    \IMPRES\
       FCB    0
       FCB    FINVVD

       FCB    FLOCA,4,1,2,2
       FCB    FTOURE,FCADRE
       FCB    FLOCA,7,1,1,2
       FCB    FTOURE
       FCB    FLOCA,9,1,1,2   Remplissag
       FCB    FINVVD
       FCB    FLOCA,11,1,1,2
       FCB    FINVVD
       FCB    FLOCA,10,0,1,4
       FCB    FTOURI
       FCB    FLOCA,10,1,1,2
       FCB    FLOCA,13,1,2,2  Superposit
       FCB    FTOURE
       FCB    FLOCA,16,1,2,2  Taille lig
       FCB    FTOURE
       FCB    FLOCA,20,1,1,2  Taille car
       FCB    FTOURE
       FCB    FEDI,MOTRAZ,0   Effacement
       FCB    FLOCA,22,1,1,2
       FCB    FTOURE
       FCB    FEDI,MOTRET,0   Précédent
       FCB    FLOCA,0,0,19,4
       FCB    FTOURI
       FCB    FLOCA,19,0,6,4
       FCB    FTOURI

       FCB    FLOCA,24,6,1,4
       FCB    FEDI,CSCRG0,CSCRG1,0
       FCB    FLOCA,24,10,1,2
       FCB    FEDI,CSCRG2,0
       FCB    FLOCA,24,12,1,60
       FCB    FTOURI
       FCB    FLOCA,24,72,1,2
       FCB    FEDI,CSCRD0,0
       FCB    FLOCA,24,74,1,4
       FCB    FEDI,CSCRD1,CSCRD2,0
       FCB    FLOCA,1,78,2,2
       FCB    FEDI,CSCRH0,0
       FCB    FLOCA,2,78,1,2
       FCB    FEDI,CSCRH1,0
       FCB    FLOCA,3,78,1,2
       FCB    FEDI,CSCRH2,0
       FCB    FLOCA,4,78,17,2
       FCB    FTOURI
       FCB    FLOCA,21,78,1,2
       FCB    FEDI,CSCRB0,0
       FCB    FLOCA,22,78,2,2
       FCB    FEDI,CSCRB1,0
       FCB    FLOCA,23,78,1,2
       FCB    FEDI,CSCRB2,0

MENUD  FCB    FLOCA,0,5,1,16
       FCB    FPOUSS,$90,OFF
       FCB    FLOCA,0,23,1,12
       FCB    FPOUSS,$91,OFF
       FCB    FLOCA,0,37,1,14
       FCB    FPOUSS,$92,OFF
       FCB    FLOCA,0,53,1,12
       FCB    FPOUSS,$93,OFF
       FCB    FLOCA,0,67,1,12
       FCB    FPOUSS,$94,OFF
       FCB    FLOCA,1,1,2,2
       FCB    FPOUSS,$0F,OFF  (ctrl) O
       FCB    FLOCA,4,1,2,2
       FCB    FPOUSS,$10,OFF  (ctrl) P
       FCB    FLOCA,7,1,1,2
       FCB    FINV,$12,OFF    (ctrl) R
       FCB    FLOCA,10,1,1,2
       FCB    FINV,$13,OFF    (ctrl) S
       FCB    FLOCA,13,1,2,2
       FCB    FPOUSS,$14,OFF  (ctrl) T
       FCB    FLOCA,16,1,2,2
       FCB    FPOUSS,$15,OFF  (ctrl) U
       FCB    FLOCA,20,1,1,2
       FCB    FPOUSS,$05,OFF  (ctrl) E
       FCB    FLOCA,22,1,1,2
       FCB    FPOUSS,$11,OFF  (ctrl) Q
       FCB    FLOCA,24,6,1,4
       FCB    FPOUSS,BS+$80,OFF
       FCB    FLOCA,24,10,1,2
       FCB    FPOUSS,BS,OFF
       FCB    FLOCA,24,12,1,60
       FCB    FPOUSS,$80,OFF
       FCB    FLOCA,24,72,1,2
       FCB    FPOUSS,HT,OFF
       FCB    FLOCA,24,74,1,4
       FCB    FPOUSS,HT+$80,OFF
       FCB    FLOCA,1,78,2,2
       FCB    FPOUSS,VT+$80,OFF
       FCB    FLOCA,3,78,1,2
       FCB    FPOUSS,VT,OFF
       FCB    FLOCA,4,78,17,2
       FCB    FPOUSS,$81,OFF
       FCB    FLOCA,21,78,1,2
       FCB    FPOUSS,LF,OFF
       FCB    FLOCA,22,78,2,2
       FCB    FPOUSS,LF+$80,OFF
       FCB    FEDI,ESC,$4C,0
FENVID FCB    FSTOP

FENTIT FCB    FEDI,ESC,$4F,0       titre
       FCB    FLOCF,0,0,5,37
       FCB    FTOURE,FCADRE
       FCB    FLOCR,2,2,20,20
       FCB    FEDI,HT,HT
       FCC    \TO-GRAPH\
       FCB    ESC,$4C
       FCC    \HMEL-93V1.7\
       FCB    0
       FCB    FSTOP

FFLOUP FCB    FLOCF,0,0,18,18
       FCB    FTRAME,FTOURI
       FCB    FLOCR,1,1,16,16
       FCB    FFOND,FTOURE,FCADRE
       FCB    FSTOP

FENFIC FCB    FLOCF,0,0,16,40
       FCB    FTOURE,FCADRE,FFOND
       FCB    FCOMF,FF,ON
       FCB    FLOCF,1,1,1,29
       FCB    FPOUSS,$50,OFF
       FCB    FEDI
       FCB    ESC,$4E
       FCC    \Pr\
       FCB    SS2,$42
       FCC    \eciserunit\
       FCB    SS2,$42,$65
       FCB    0
       FCB    FLOCF,2,1,1,29
       FCB    FPOUSS,$49,OFF
       FCB    FEDI
       FCC    \Initialiser\
       FCB    0
       FCB    FLOCF,3,1,1,29
       FCB    FPOUSS,$43,OFF
       FCB    FEDI
       FCC    \Catalogue\
       FCB    0
       FCB    FLOCF,4,1,1,38
       FCB    FPOUSS,$52,OFF
       FCB    FEDI
       FCC    \Renommerfichier\
       FCB    0
       FCB    FLOCF,5,1,1,38
       FCB    FPOUSS,$53,OFF
       FCB    FEDI
       FCC    \Supprimerfichier\
       FCB    0
       FCB    FLOCF,6,1,1,38
       FCB    FPOUSS,$44,OFF
       FCB    FEDI
       FCC    \Dupliquerfichier\
       FCB    0
       FCB    FLOCF,8,1,1,38
       FCB    FPOUSS,$4C,OFF
       FCB    FEDI
       FCC    \Liredessin\
       FCB    0
       FCB    FLOCF,9,1,1,38
       FCB    FPOUSS,$45,OFF
       FCB    FEDI
       FCC    \Ecriredessin\
       FCB    0
       FCB    FLOCF,11,1,1,38
       FCB    FPOUSS,$46,OFF
       FCB    FEDI
       FCC    \Fichier\
       FCB    SS2,$2E
       FCC    \Album\
       FCB    0
       FCB    FLOCF,12,1,1,38
       FCB    FPOUSS,$41,OFF
       FCB    FEDI
       FCC    \Album\
       FCB    SS2,$2E
       FCC    \Fichier\
       FCB    0
       FCB    FLOCF,14,1,1,38
       FCB    FPOUSS,$51,OFF
       FCB    FEDI
       FCC    \Quitter...\
       FCB    ESC,$4C,0
       FCB    FLOCF,1,32,2,6
       FCB    FFOND,FTOURE,FCADRE

       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP

FALBUM FCB    FLOCF,0,0,11,32
       FCB    FTOURE,FCADRE,FFOND
       FCB    FCOMF,FF,ON
       FCB    FLOCF,1,1,1,30
       FCB    FPOUSS,$43,OFF
       FCB    FEDI,ESC,$4E
       FCC    \Copier\
       FCB    SS2,$2E
       FCC    \Tiroir\
       FCB    0
       FCB    FLOCR,2,0,1,30
       FCB    FPOUSS,$41,OFF
       FCB    FEDI
       FCC    \Album\
       FCB    SS2,$2E
       FCC    \Ecran\
       FCB    0
       FCB    FLOCR,2,0,1,30
       FCB    FPOUSS,$45,OFF
       FCB    FEDI
       FCC    \Ecran\
       FCB    SS2,$2E
       FCC    \Album\
       FCB    0
       FCB    FLOCR,2,0,1,30
       FCB    FPOUSS,$56,OFF
       FCB    FEDI
       FCC    \Voirliste\
       FCB    0
       FCB    FLOCR,2,0,1,30
       FCB    FPOUSS,$53,OFF
       FCB    FEDI
       FCC    \Supprimer\
       FCB    ESC,$4C,0

       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP

FIMPR  FCB    FLOCF,0,0,5,28
       FCB    FTOURE,FCADRE,FFOND
       FCB    FCOMF,FF,ON
       FCB    FLOCF,1,1,1,26
       FCB    FPOUSS,$45,OFF
       FCB    FEDI,ESC,$4E
       FCC    \impr.Ecran\
       FCB    0
       FCB    FLOCR,2,0,1,26
       FCB    FPOUSS,$46,OFF
       FCB    FEDI
       FCC    \impr.Feuille\
       FCB    0

       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP

FENOUT FCB    FLOCF,0,0,7,38
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOMF,FF,ON

       FCB    FLOCF,1,2,2,2
       FCB    FTEXTE
MPOIN  FCB    $80,$81,$82,$83,0
       FCB    FEDI,HT,HT,HT,LF,$41,0
       FCB    FPOUSS,$41,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MLIGN  FCB    $84,$85,$86,$87,0
       FCB    FEDI,HT,HT,HT,LF,$42,0
       FCB    FPOUSS,$42,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MRECT  FCB    $88,$89,$8A,$8B,0
       FCB    FEDI,HT,HT,HT,LF,$43,0
       FCB    FPOUSS,$43,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MCARR  FCB    $8C,$8D,$8E,$8F,0
       FCB    FEDI,HT,HT,HT,LF,$44,0
       FCB    FPOUSS,$44,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MELLI  FCB    $90,$91,$92,$93,0
       FCB    FEDI,HT,HT,HT,LF,$45,0
       FCB    FPOUSS,$45,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MCERC  FCB    $94,$95,$96,$97,0
       FCB    FEDI,HT,HT,HT,LF,$46,0
       FCB    FPOUSS,$46,OFF
       FCB    FLOCF,4,2,2,2
       FCB    FTEXTE
MCARA  FCB    $98,$99,$9A,$9B,0
       FCB    FEDI,HT,HT,HT,LF,$47,0
       FCB    FPOUSS,$47,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MPEIN  FCB    $9C,$9D,$9E,$9F,0
       FCB    FEDI,HT,HT,HT,LF,$48,0
       FCB    FPOUSS,$48,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MGOMM  FCB    $A0,$A1,$A2,$A3,0
       FCB    FEDI,HT,HT,HT,LF,$49,0
       FCB    FPOUSS,$49,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MLOUP  FCB    $A4,$A5,$A6,$A7,0
       FCB    FEDI,HT,HT,HT,LF,$4A,0
       FCB    FPOUSS,$4A,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MCOUC  FCB    $A8,$A9,$AA,$AB,0
       FCB    FEDI,HT,HT,HT,LF,$4B,0
       FCB    FPOUSS,$4B,OFF
       FCB    FLOCR,0,6,2,2
       FCB    FTEXTE
MCOLL  FCB    $AC,$AD,$AE,$AF,0
       FCB    FEDI,HT,HT,HT,LF,$4C,0
       FCB    FPOUSS,$4C,OFF

       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP

FENMOT FCB    FLOCF,0,0,18,19
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOMF,FF,ON

       FCB    FLOCF,1,1,16,8
       FCB    FTOURE
       FCB    FLOCR,-2,6,0,0
       FCB    FDO,8
       FCB    FLOCR,2,-8,0,0
       FCB    FDO,4
       FCB    FLOCR,0,2,2,2
       FCB    FPOUSS,255,OFF   code déf.
       FCB    FLOOP
       FCB    FLOOP

       FCB    FLOCF,1,10,2,2
       FCB    FTOURE,FINVVD
       FCB    FPOUSS,200,OFF   plein
       FCB    FLOCF,4,10,2,2
       FCB    FTOURE
       FCB    FPOUSS,201,OFF   vide

       FCB    FLOCF,2,15,2,2
       FCB    FTOURE,FCADRE

       FCB    FLOCF,5,14,0,0
       FCB    FEDI
       FCC    \OK\
       FCB    BALISE,0
       FCB    FLOCF,5,17,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCF,7,10,0,0
       FCB    FEDI
       FCC    \Ranger\
       FCB    BALISE,0
       FCB    FLOCF,7,17,1,1
       FCB    FINV,199,OFF

       FCB    FLOCF,9,10,8,8
       FCB    FTOURE
       FCB    FPOUSS,254,INTERD (bidon)

       FCB    FCALL
       FDB    MENUD
       FCB    FSTOP

FFCOUC FCB    FLOCF,0,0,7,18
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,1,1,16
       FCB    FEDI,ESC,$4E
       FCC    \Copier\
       FCB    0
       FCB    FPOUSS,$43,OFF
       FCB    FLOCR,2,0,1,16
       FCB    FEDI
       FCC    \Couper\
       FCB    0
       FCB    FPOUSS,$03,OFF
       FCB    FLOCR,2,0,1,16
       FCB    FEDI
       FCC    \Inverser\
       FCB    0
       FCB    FPOUSS,$49,OFF
       FCB    FSTOP


****************************************
*  M E S S A G E S                     *
****************************************

MLIRE  FCB    ESC,$4E
       FCC    \LIRE\
       FCB    ESC,$4C,0
MOUT   FCC    \MEMOIREinsuffisante\
       FCB    0
MVFICH FCB    ESC,$4E,HT,SS2,$2E
       FCC    \FICHIER\
       FCB    ESC,$4C,0
MCOMAL FCC    \To-graph\
       FCB    0
MLIGN1 FCB    $B0,$B1,$B2,$B3,0
MLIGN2 FCB    $B4,$B5,$B6,$B7,0
MLIGN3 FCB    $B8,$B9,$BA,$BB,0
MCN    FCB    $41,$42,$43,$44,0
MCDH   FCB    LF,ESC,TCDH,$41,$42
       FCB    ESC,TCN,0
MCDL   FCB    ESC,TCDL,$41,$42,ESC,TCN,0
MCDT   FCB    LF,ESC,TCDT,$41,ESC,TCN,0
MTIRVI FCC    \TIROIRVIDE!!!\
       FCB    0


****************************************
*  M O T I F S   D E   R E M P L I S . *
****************************************

MOTREM FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $0000,$0000,$0000,$0000
       FDB    $DFDF,$00EE,$00F7,$F700
       FDB    $8488,$5030,$1028,$4782
       FDB    $2078,$CC84,$87CC,$3030
       FDB    $FFFF,$AAFF,$8888,$8888
       FDB    $0880,$2401,$0842,$1042
       FDB    $0242,$D080,$042B,$9A90
       FDB    $6C0E,$093C,$7EA9,$A792
       FDB    $E2F6,$EE4E,$A81F,$BF2E
       FDB    $5ADA,$5B55,$A56B,$6BAA
       FDB    $1CC1,$13CE,$007C,$8300
       FDB    $11AA,$44AA,$11AA,$44AA
       FDB    $AA55,$AA55,$AA55,$AA55
       FDB    $A244,$8A11,$A044,$2A11
       FDB    $1D3C,$9C88,$C5E3,$D188
       FDB    $BB55,$EE55,$BB55,$EE55
       FDB    $1010,$7C82,$0101,$C728
       FDB    $0B0D,$0B0D,$5FAF,$5FAF
       FDB    $41FE,$EEEE,$EF28,$EFFE
       FDB    $8080,$8080,$8080,$80FF
       FDB    $00FF,$00FF,$00FF,$00FF
       FDB    $AAAA,$AAAA,$AAAA,$AAAA
       FDB    $0000,$00FF,$0000,$00FF
       FDB    $8888,$8888,$8888,$8888
       FDB    $8888,$88FF,$8888,$88FF
       FDB    $8844,$2211,$8844,$2211
       FDB    $1122,$4488,$1122,$4488
       FDB    $DDAA,$DDFF,$DDAA,$DDFF
       FDB    $1199,$CC44,$44CC,$9911
       FDB    $663C,$00C3,$663C,$00C3
       FDB    $3E63,$DDD5,$DD61,$3E1C
       FDB    $9942,$2499,$9924,$4299
       FDB    $9966,$6699,$9966,$6699


****************************************
*  C A R A C T E R E S   U T I L I S . *
****************************************

CARUSR EQU    *
*      icone points
       FDB    $8081,$8090,$8080,$403F
       FDB    $0101,$1501,$0101,$02FC
       FDB    $3F40,$8080,$8280,$9080
       FDB    $FC02,$0111,$0101,$4101
*      icone lignes
       FDB    $8080,$8080,$8080,$403F
       FDB    $8141,$4121,$2111,$02FC
       FDB    $3F40,$8482,$8281,$8180
       FDB    $FC02,$0101,$0101,$0181
*      icone rectangles
       FDB    $9090,$9090,$9F80,$403F
       FDB    $0909,$0909,$F901,$02FC
       FDB    $3F40,$809F,$9090,$9090
       FDB    $FC02,$01F9,$0909,$0909
*      icone carré
       FDB    $9090,$9F80,$8080,$403F
       FDB    $0909,$F901,$0101,$02FC
       FDB    $3F40,$8080,$809F,$9090
       FDB    $FC02,$0101,$01F9,$0909
*      icone ellipse
       FDB    $9090,$888C,$8380,$403F
       FDB    $0909,$1131,$C101,$02FC
       FDB    $3F40,$8083,$8C88,$9090
       FDB    $FC02,$01C1,$3111,$0909
*      icone cercle
       FDB    $9098,$8780,$8080,$403F
       FDB    $0519,$E101,$0101,$02FC
       FDB    $3F40,$8080,$8087,$98A0
       FDB    $FC02,$0101,$01E1,$1905
*      icone caractères
       FDB    $A5BD,$A5A5,$A598,$403F
       FDB    $C929,$2929,$29C7,$C7FC
       FDB    $3F40,$A5A5,$A5A5,$A5A5
       FDB    $FC02,$C729,$2929,$2929
*      icone peinture
       FDB    $8783,$8387,$8783,$403F
       FDB    $F9F9,$F9F9,$F1E1,$02FC
       FDB    $3F40,$8087,$8890,$908F
       FDB    $FC02,$01E1,$1111,$0909
*      icone gomme
       FDB    $8884,$8281,$8080,$403F
       FDB    $9151,$31F1,$0101,$02FC
       FDB    $3F40,$8080,$9F91,$919F
       FDB    $FC02,$0101,$0181,$4121
*      icone loupe
       FDB    $8181,$8181,$8181,$403F
       FDB    $0505,$0505,$05FD,$02FC
       FDB    $3F40,$8098,$8C86,$8381
       FDB    $FC02,$0101,$0101,$01FD
*      icone couper copier
       FDB    $9197,$8181,$8181,$403F
       FDB    $81D9,$8181,$8181,$02FC
       FDB    $3F40,$809B,$8090,$9183
       FDB    $FC02,$0169,$0901,$89C9
*      icone coller
       FDB    $9197,$8181,$8381,$403F
       FDB    $81D9,$8181,$C181,$02FC
       FDB    $3F40,$809B,$8090,$9181
       FDB    $FC02,$0169,$0901,$8989
*      icone lignes taille 1
       FDB    $0101,$0101,$0101,$0100
       FDB    $0000,$0000,$0000,$0000
       FDB    $0001,$0101,$0101,$017F
       FDB    $0000,$0000,$0000,$00FE
*      icone lignes taille 2
       FDB    $7F01,$0101,$0101,$0100
       FDB    $FE80,$8080,$8080,$8000
       FDB    $0001,$0101,$0101,$017F
       FDB    $0080,$8080,$8080,$80FE
*      icone lignes taille 3
       FDB    $7F03,$0303,$0303,$0300
       FDB    $FE80,$8080,$8080,$8000
       FDB    $0003,$0303,$0303,$7F7F
       FDB    $0080,$8080,$8080,$FEFE
*      motif RAZ visu
       FDB    $007E,$4242,$4242,$7E00
*      motif retour
       FDB    $0042,$2418,$4224,$1800
*      motif suite
       FDB    $0018,$2442,$1824,$4200
*      scroll gauche
       FDB    $FF80,$9F89,$8482,$80FF
       FDB    $FF01,$F901,$8141,$01FF
       FDB    $FF81,$BD91,$8981,$81FF
*      scroll droit
       FDB    $FF81,$BD89,$9181,$81FF
       FDB    $FF80,$9F80,$8182,$80FF
       FDB    $FF01,$F991,$2141,$01FF
*      scroll haut
       FDB    $8DA5,$958D,$8581,$81FF
       FDB    $FF81,$8185,$8585,$A595
       FDB    $FF81,$8595,$8D85,$81FF
*      scroll bas
       FDB    $FF81,$858D,$9585,$81FF
       FDB    $95A5,$8585,$8581,$81FF
       FDB    $FF81,$8185,$8D95,$A58D

* Vecteurs vers icones outils
*---------------------------------------

TMOUTI FDB    MPOIN
       FDB    MLIGN
       FDB    MRECT
       FDB    MCARR
       FDB    MELLI
       FDB    MCERC
       FDB    MCARA
       FDB    MPEIN
       FDB    MGOMM
       FDB    MLOUP
       FDB    MCOUC
       FDB    MCOLL

* Vecteurs vers textes tailles car.
*---------------------------------------

TMMT   FDB    MCN
       FDB    MCDH
       FDB    MCDL
       FDB    MCDT

* Tortues spécifiques
*---------------------------------------

TORPT  FCC    \L0D2L128D1L128U4L0D6\
       FCC    \L128U15L0D6L128U10L64U3\
       FCC    \L0D3L128U9L0D3\
LTORPT EQU    *-TORPT

TORST  FCC    \L0D2L0U3L0D2\
       FCC    \L64U1L0D1L0U3L0D2\
       FCC    \L64U1L0D1L0U3L0D2\
       FCC    \L64U1L0D1L0U3L0D1\
LTORST EQU    *

TORDH  FCC    \L0D2L0U3L0D2\
       FCC    \L64U1L0D1L0U11L0D2\
       FCC    \L64U1L0D1L0U3L0D2\
       FCC    \L64U1L0D1L0U11L0D1\
LTORDH EQU    *

TORDL  FCC    \L0D2L0U11L0D2\
       FCC    \L64U1L0D1L0U3L0D2\
       FCC    \L64U1L0D1L0U11L0D2\
       FCC    \L64U1L0D1L0U3L0D1\
LTORDL EQU    *

TORDT  FCC    \L0D2L0U11L0D2\
       FCC    \L64U1L0D1L0U11L0D2\
       FCC    \L64U1L0D1L0U11L0D2\
       FCC    \L64U1L0D1L0U11L0D1\
LTORDT EQU    *

TABTOR EQU    *       table tortue ASCII
       FDB    TORST
       FCB    LTORST-TORST
       FDB    TORDH
       FCB    LTORDH-TORDH
       FDB    TORDL
       FCB    LTORDL-TORDL
       FDB    TORDT
       FCB    LTORDT-TORDT

* Divers
*---------------------------------------

TBITS  FCB    1,2,4,8,16,32,64,128
TMASQG FDB    $FF7F,$3F1F,$0F07,$0301
TMASQD FDB    $80C0,$E0F0,$F8FC,$FEFF
ASCCOE FCC    \1.6396\  coeff.
       FCB    0         point écran ->
*                       point imprimante
