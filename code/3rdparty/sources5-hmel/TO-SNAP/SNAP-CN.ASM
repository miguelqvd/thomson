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

FENVID FCB    FSTOP

MIGDIN FCB    ABS
       FCB    LFCUR
       FDB    9*8,19*8+4
       FCB    ROND,12,12
       FCB    REL
       FCB    FCUR,-2,-12
       FCB    BOITE,4,3
       FCB    FCUR,6,7
       FCB    ROND,2,2
       FCB    FCUR,-16,0
       FCB    ROND,2,2
       FCB    FCUR,0,6
       FCB    ROND,2,2
       FCB    FCUR,16,0
       FCB    ROND,2,2
       FCB    FCUR,-8,4
       FCB    ROND,2,2
       FCB    STOP
FMIGDI EQU    *

FENHLP FCB    FLOCF,0,0,25,40
       FCB    FCOULF,VERTCL
       FCB    FTRAME,FTOURI
       FCB    FLOCF,1,1,1,38
       FCB    FCOULF,BLANC
       FCB    FFOND,FTOURE,FCADRE
       FCB    FEDI,ESC,$4E
       FCC    \MODED'EMPLOI\
       FCB    ESC,$4C,0
       FCB    FCOULF,TRANSP
       FCB    FLOCF,3,1,19,38
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCF,23,1,1,26
       FCB    FFOND,FTOURE,FCADRE
       FCB    FTEXTE
       FCC    \OK\
       FCB    BALISE
       FCC    \Annuler\
       FCB    BALISE,0
       FCB    FLOCR,0,5,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCR,0,18,1,1
       FCB    FPOUSS,FF,OFF
       FCB    FLOCF,23,29,1,4
       FCB    FFOND,FTOURE,FCADRE
       FCB    FEDI,HT,ESC,$4E,SS2,$2D
       FCB    ESC,$4C,0
       FCB    FPOUSS,VT,OFF
       FCB    FLOCF,23,35,1,4
       FCB    FFOND,FTOURE,FCADRE
       FCB    FEDI,HT,ESC,$4E,SS2,$2F
       FCB    ESC,$4C,0
       FCB    FPOUSS,LF,OFF
       FCB    FSTOP

FENLAN FCB    FLOCF,0,0,17,29
       FCB    FCOULF,VERTCL
       FCB    FTRAME,FTOURI
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,1,1,27
       FCB    FCOULF,BLANC
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FEDI,$20,$1B,$4E
       FCC    \LANCEMENT\
       FCB    $1B,$4C,0

       FCB    FLOCF,3,1,13,27
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,4,2,1,25
       FCB    FPOUSS,$90,OFF

       FCB    FLOCF,5,2,1,25
       FCB    FPOUSS,$91,OFF

       FCB    FLOCF,6,2,1,25
       FCB    FPOUSS,$92,OFF

       FCB    FLOCF,7,2,1,25
       FCB    FPOUSS,$93,OFF

       FCB    FLOCF,8,2,1,25
       FCB    FPOUSS,$94,OFF

       FCB    FLOCF,10,2,1,25
       FCB    FEDI
       FCC    \Bootdisquette\
       FCB    0
       FCB    FPOUSS,$95,OFF

       FCB    FLOCF,12,3,1,25
       FCB    FTEXTE,BALISE
       FCC    \Auto\
       FCC    \(oct.)\
       FCB    0
       FCB    FLOCR,0,0,1,1
       FCB    FINV,$01,OFF
       FCB    FLOCR,0,16,1,2
       FCB    FPOUSS,254,INTERD

       FCB    FLOCF,14,3,1,16
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,$53,OFF

       FCB    FLOCR,0,17,1,2
       FCB    FEDI
       FCC    \en\
       FCB    0

       FCB    FLOCR,0,3,1,4
       FCB    FTOURE,FCADRE
       FCB    FCZI,255,HEXA

       FCB    FSTOP

FENINF FCB    FLOCF,0,0,16,23
       FCB    FCOULF,VERTCL
       FCB    FTRAME,FTOURI
       FCB    FLOCF,1,1,1,21
       FCB    FCOULF,BLANC
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FEDI,$1B,$4E
       FCC    \INFO\
       FCB    $1B,$4C,0

       FCB    FLOCF,3,1,10,21
       FCB    FFOND,FTOURE,FCADRE

       FCB    FLOCF,4,1,1,21
       FCB    FEDI
       FCC    \TourPaletteBVR\
       FCB    0

       FCB    FLOCF,6,2,4,2
       FCB    FCOULF,PARME
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FPOUSS,$58,INTERD

       FCB    FLOCF,6,5,2,1
       FCB    FTOURE
       FCB    FTEXTE,$2B,$2D,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$54,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$55,OFF

       FCB    FLOCF,9,5,1,2
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,$59,INTERD

       FCB    FLOCF,6,9,4,2
       FCB    FCOULF,ORANGE
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP

       FCB    FLOCF,6,12,2,1
       FCB    FTOURE
       FCB    FTEXTE,$2B,$2D,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$50,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$51,OFF

       FCB    FLOCF,9,12,1,2
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,$5A,INTERD

       FCB    FLOCF,6,16,2,1
       FCB    FTOURE
       FCB    FTEXTE,$2B,$2D,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$42,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$43,OFF

       FCB    FLOCF,6,18,2,1
       FCB    FTOURE
       FCB    FTEXTE,$2B,$2D,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$56,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$57,OFF

       FCB    FLOCF,6,20,2,1
       FCB    FTOURE
       FCB    FTEXTE,$2B,$2D,0
       FCB    FLOCR,0,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$52,OFF
       FCB    FLOCR,1,0,1,1
       FCB    FTOURI
       FCB    FPOUSS,$53,OFF

       FCB    FLOCF,9,16,1,5
       FCB    FTOURE,FCADRE
       FCB    FEDI
       FCC    \--\
       FCB    0
       FCB    FPOUSS,$48,INTERD

       FCB    FLOCF,11,2,1,4
       FCB    FEDI
       FCC    \Mode\
       FCB    0
       FCB    FLOCR,0,5,1,14
       FCB    FTOURE,FCADRE
       FCB    FPOUSS,$4D,OFF

       FCB    FLOCF,14,1,1,21
       FCB    FFOND,FTOURE,FCADRE

       FCB    FTEXTE
       FCC    \Ok\
       FCB    BALISE
       FCC    \Annuler\
       FCB    BALISE,0
       FCB    FLOCR,0,5,1,1
       FCB    FPOUSS,RC,OFF
       FCB    FLOCR,0,13,1,1
       FCB    FPOUSS,FF,OFF
       FCB    FSTOP

FFPEL  FCB    FLOCF,0,0,23,22
       FCB    FCOULF,VERTCL
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP

       FCB    FLOCF,1,1,1,2
       FCB    FEDI,HT,$30,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,HT,$32,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,HT,$34,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,HT,$36,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,HT,$38,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,$31,$30,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,$31,$32,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,$31,$34,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,$31,$36,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,$31,$38,0
       FCB    FLOCR,2,0,1,2
       FCB    FEDI,$32,$30,0

       FCB    FLOCF,1,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,200,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,201,OFF

       FCB    FLOCF,3,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,202,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,203,OFF

       FCB    FLOCF,5,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,204,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,205,OFF

       FCB    FLOCF,7,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,206,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,207,OFF

       FCB    FLOCF,9,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,208,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,209,OFF

       FCB    FLOCF,11,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,210,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,211,OFF

       FCB    FLOCF,13,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,212,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,213,OFF

       FCB    FLOCF,15,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,214,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,215,OFF

       FCB    FLOCF,17,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,216,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,217,OFF

       FCB    FLOCF,19,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,218,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,219,OFF

       FCB    FLOCF,21,4,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,220,OFF
       FCB    FLOCR,0,9,1,8
       FCB    FTOURE,FCADRE
       FCB    FINV,221,OFF

       FCB    FLOCF,10,23,11,15
       FCB    FCOULF,VERTCL
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP

       FCB    FLOCR,1,1,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,$56,OFF
       FCB    FEDI,HT,HT
       FCC    \Voir\
       FCB    0
       FCB    FLOCR,2,0,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FINV,$45,OFF
       FCB    FEDI,HT,HT
       FCC    \Echanger\
       FCB    0
       FCB    FLOCR,2,0,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,$53,OFF
       FCB    FEDI,HT,HT
       FCC    \Supprimer\
       FCB    0
       FCB    FLOCR,2,0,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,$41,OFF
       FCB    FEDI,HT,HT
       FCC    \Animers\
       FCB    0
       FCB    FLOCR,2,0,1,1
       FCB    FTEXTE,BALISE,0
       FCB    FPOUSS,FF,OFF
       FCB    FEDI,HT,HT
       FCC    \Annuler\
       FCB    0
       FCB    FLOCF,10,23,11,15
       FCB    FLOCR,7,10,1,2
       FCB    FTOURE,FCADRE
       FCB    FCZI,255,DECIM
       FCB    FSTOP

FENMEN FCB    FLOCF,0,0,15,18
       FCB    FCOULF,BLEUCI
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOMF,FF,OFF
       FCB    FLOCF,1,10,1,10
       FCB    FEDI
       FCC    \Vue\
       FCB    0
       FCB    FLOCF,1,14,1,2
       FCB    FCOULF,BLANC
       FCB    FFOND,FTOURE,FCADRE
       FCB    FCOULF,TRANSP
       FCB    FLOCF,3,1,1,16
       FCB    FPOUSS,$4C,OFF
       FCB    FEDI
       FCC    \LANCERAVECSNAP\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,$44,OFF
       FCB    FEDI
       FCC    \DIAPORAMA\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,$49,OFF
       FCB    FEDI
       FCC    \INFOVIDEO\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,$46,OFF
       FCB    FEDI
       FCC    \FICHIERS\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,$4D,OFF
       FCB    FEDI
       FCC    \MODED'EMPLOI\
       FCB    0
       FCB    FLOCR,2,0,1,16
       FCB    FPOUSS,$51,OFF
       FCB    FEDI
       FCC    \QUITTER\
       FCB    0
       FCB    FSTOP

FENTIT FCB    FLOCF,0,0,6,19    titre
       FCB    FCOULF,ORANGE
       FCB    FFOND,FTOURE,FCADRE
       FCB    FLOCR,1,2,20,20
       FCB    FEDI
       FCC    \TO-SNAP\
       FCB    0
       FCB    FLOCR,2,4,20,20
       FCB    FEDI
       FCC    \HMEL-92V1.1\
       FCB    0
       FCB    FSTOP

FENFIC FCB    FLOCF,0,0,20,20
       FCB    FCOULF,BLEUCI
       FCB    FTOURE,FCADRE,FFOND
       FCB    FCOMF,FF,ON
       FCB    FLOCF,1,1,1,14
       FCB    FPOUSS,$50,OFF
       FCB    FEDI
       FCC    \Pr\
       FCB    SS2,$42
       FCC    \eciserunit\
       FCB    SS2,$42,$65
       FCB    0
       FCB    FLOCR,2,0,1,14
       FCB    FPOUSS,$49,OFF
       FCB    FEDI
       FCC    \Initialiser\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,$43,OFF
       FCB    FEDI
       FCC    \Catalogue\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,$52,OFF
       FCB    FEDI
       FCC    \Renommerfichier\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,$53,OFF
       FCB    FEDI
       FCC    \Supprimerfichier\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,$44,OFF
       FCB    FEDI
       FCC    \Dupliquerfichier\
       FCB    0
       FCB    FLOCR,3,0,1,18
       FCB    FPOUSS,$4C,OFF
       FCB    FEDI
       FCC    \Lire\
       FCB    SS2,$42
       FCC    \ecran\
       FCB    0
       FCB    FLOCR,2,0,1,18
       FCB    FPOUSS,$45,OFF
       FCB    FEDI
       FCC    \Ecrire\
       FCB    SS2,$42
       FCC    \ecran\
       FCB    0
       FCB    FLOCR,2,5,1,13
       FCB    FTEXTE
       FCC    \pellicule\
       FCB    BALISE,0
       FCB    FLOCR,0,10,1,1
       FCB    FINV,$10,OFF
       FCB    FCOULF,BLANC
       FCB    FLOCF,1,16,2,3
       FCB    FFOND,FTOURE,FCADRE
       FCB    FSTOP

* Pages de mode d'emploi
*---------------------------------------

HLP1   FCC    \TO-SNAPapourbut:\
       FCB    RC,LF,LF
       FCC    \-Lacaptured'\
       FCB    SS2,$42
       FCC    \ecransd'autres\
       FCB    RC,LF
       FCC    \logiciels.\
       FCB    RC,LF,LF
       FCC    \-Lam\
       FCB    SS2,$42
       FCC    \emorisationdeces\
       FCB    SS2,$42
       FCC    \ecrans\
       FCB    RC,LF
       FCC    \pourdiffusionult\
       FCB    SS2,$42
       FCC    \erieure.\
       FCB    RC,LF,LF
       FCC    \Lelogicielestcharg\
       FCB    SS2,$42
       FCC    \eentant\
       FCB    RC,LF
       FCC    \qu'application"cartou\
       FCC    \che"dedeux\
       FCB    RC,LF
       FCC    \banksetdemeuredoncr\
       FCB    SS2,$42
       FCC    \esidenten\
       FCB    RC,LF
       FCC    \RAM.\
       FCB    RC,LF
       FCC    \Apartirdecesoftil\
       FCC    \estpossible\
       FCB    RC,LF
       FCC    \d'activerd'autresprog\
       FCC    \rammesen\
       FCB    RC,LF
       FCC    \maintenantenm\
       FCB    SS2,$42
       FCC    \emoirenoncommutable\
       FCB    RC,LF
       FCC    \unimplantr\
       FCB    SS2,$42
       FCC    \eduitdontler\
       FCB    SS2,$43
       FCC    \olesera\
       FCB    RC,LF
       FCC    \decommuterpuisder\
       FCB    SS2,$42
       FCC    \eactiverTO-SNAP\
       FCB    0

HLP2   FCC    \C'estund\
       FCB    SS2,$42
       FCC    \eroutementdevecteurs\
       FCB    RC,LF
       FCC    \RAMdumoniteurquiper\
       FCC    \metl'ex\
       FCB    SS2,$42
       FCC    \ecu-\
       FCB    RC,LF
       FCC    \tiondel'implant.\
       FCB    RC,LF,LF
       FCC    \UnefoisTO-SNAPrelan\
       FCC    \c\
       FCB    SS2,$42
       FCC    \e,l'\
       FCB    SS2,$42
       FCC    \ecran\
       FCB    RC,LF
       FCC    \courantestautomatique\
       FCC    \mentstock\
       FCB    SS2,$42
       FCC    \e\
       FCB    RC,LF
       FCC    \danslepremier\
       FCB    SS2,$42
       FCC    \ecrandemanoeuvre.\
       FCB    RC,LF,LF
       FCC    \Ilpeutalorssubir\
       FCC    \quelquesmodif-\
       FCB    RC,LF
       FCC    \ications(palette,tour\
       FCC    \quinepeut\
       FCB    RC,LF
       FCC    \\
       FCB    SS2,$43
       FCC    \etreacquisparlehard.\
       FCC    \..)puis\
       FCB    RC,LF
       FCC    \archiv\
       FCB    SS2,$42
       FCC    \esurfichier.\
       FCB    0

HLP3   FCC    \Encasded\
       FCB    SS2,$42
       FCC    \eroutementdeRESETP,\
       FCB    RC,LF
       FCC    \l'activationdeTO-SNAP\
       FCC    \estobtenue\
       FCB    RC,LF
       FCC    \parlepoussoirINIT...\
       FCB    RC,LF,LF
       FCC    \ATTENTION:avecles\
       FCC    \ROMsstandards\
       FCB    RC,LF
       FCC    \l'\
       FCB    SS2,$42
       FCC    \ecrann'estcaptur\
       FCB    SS2,$42
       FCC    \eques'il\
       FCB    RC,LF
       FCC    \estenmodeTO7-70.(Je\
       FCC    \disposed'uneROMmodif\
       FCC    \i\
       FCB    SS2,$42
       FCC    \eesanscettelimitation\
       FCC    \).\
       FCB    RC,LF,LF
       FCC    \Encasded\
       FCB    SS2,$42
       FCC    \eroutementdeFIRQPTon\
       FCB    RC,LF
       FCC    \utilisel'interruption\
       FCC    \hardFIRQ\
       FCB    RC,LF
       FCC    \accessiblesurlebus\
       FCC    \ougraceau\
       FCB    RC,LF
       FCC    \6821syst\
       FCB    SS2,$41
       FCC    \emesurleconnecteurdu\
       FCB    RC,LF
       FCC    \crayonoptiqueparun\
       FCC    \poussoir\
       FCB    RC,LF
       FCC    \sp\
       FCB    SS2,$42
       FCC    \ecifique(pr\
       FCB    SS2,$42
       FCC    \evupourcodebarre).\
       FCB    0

HLP4   FCC    \Encasded\
       FCB    SS2,$42
       FCC    \eroutementd'uneroutine\
       FCB    RC,LF
       FCC    \moniteur(GETLP..GETSC)\
       FCC    \l'implant\
       FCB    RC,LF
       FCC    \testelepoussoirci-de\
       FCC    \ssus.GETCH\
       FCB    RC,LF
       FCC    \etGETLPsontlesplus\
       FCC    \efficaces\
       FCB    RC,LF
       FCC    \puisquetr\
       FCB    SS2,$41
       FCC    \essouventutilis\
       FCB    SS2,$42
       FCC    \es.\
       FCB    RC,LF,LF
       FCC    \Encasded\
       FCB    SS2,$42
       FCC    \eroutementdeTIMEPT,\
       FCB    RC,LF
       FCC    \l'implantestappel\
       FCB    SS2,$42
       FCC    \eparl'horloge\
       FCB    RC,LF
       FCC    \syst\
       FCB    SS2,$41
       FCC    \eme.Iltestealorsle\
       FCC    \m\
       FCB    SS2,$43
       FCC    \eme\
       FCB    RC,LF
       FCC    \poussoir.\
       FCB    RC,LF,LF
       FCC    \Led\
       FCB    SS2,$42
       FCC    \eroutementBUFCLVestle\
       FCC    \plus\
       FCB    RC,LF
       FCC    \"tordu".Lebufferclav\
       FCC    \ierest\
       FCB    RC,LF
       FCC    \d\
       FCB    SS2,$42
       FCC    \erout\
       FCB    SS2,$42
       FCC    \esurlevecteurd'indir\
       FCC    \ection\
       FCB    RC,LF
       FCC    \RAMdeGETCH.Lasaisie\
       FCC    \de_lefait\
       FCB    RC,LF
       FCC    \passerde$FF8E\
       FCB    SS2,$41
       FCC    \a$5F8E,adresseo\
       FCB    SS2,$41
       FCC    \u\
       FCB    RC,LF
       FCC    \ond\
       FCB    SS2,$42
       FCC    \erouteGETCHversl'imp\
       FCC    \lantstd.\
       FCB    0

HLP5   FCC    \Commeiln'estpaspos\
       FCC    \siblesurTO\
       FCB    RC,LF
       FCC    \des\
       FCB    SS2,$42
       FCC    \ecuriserlaRAM,ilfaut\
       FCC    \souvent\
       FCB    RC,LF
       FCC    \tatonnerpourtrouver\
       FCC    \led\
       FCB    SS2,$42
       FCC    \eroutement\
       FCB    RC,LF
       FCC    \quiconvient(ainsi\
       FCC    \qu'\
       FCB    SS2,$42
       FCC    \eventuel-\
       FCB    RC,LF
       FCC    \lementl'adressedel'\
       FCC    \implant).\
       FCB    RC,LF,LF
       FCC    \Ilya\
       FCB    SS2,$42
       FCC    \egalementdessofts\
       FCC    \blind\
       FCB    SS2,$42
       FCC    \es\
       FCB    RC,LF
       FCC    \quir\
       FCB    SS2,$42
       FCC    \einitialisenttousles\
       FCC    \vecteurs.\
       FCB    RC,LF
       FCC    \Seulesolution:d\
       FCB    SS2,$42
       FCC    \erouterRESETPavec\
       FCB    RC,LF
       FCC    \uneROMmoniteursp\
       FCB    SS2,$42
       FCC    \ecifique...\
       FCB    RC,LF,LF
       FCC    \Branchementdupoussoi\
       FCC    \r"travail"\
       FCB    RC,LF
       FCC    \entrelesplots2et4\
       FCC    \d'uneprise\
       FCB    RC,LF
       FCC    \51DINm\
       FCB    SS2,$43
       FCC    \ale5plots240\
       FCB    SS2,$30
       FCB    RC,LF,LF
       FCC    \42(vuecot\
       FCB    SS2,$42
       FCC    \esoudure)\
       FCB    RC,LF
       FCC    \3\
       FCB    0

HLP6   FCC    \Lesfichiersg\
       FCB    SS2,$42
       FCC    \er\
       FCB    SS2,$42
       FCC    \esparTO-SNAPsont\
       FCB    RC,LF
       FCC    \des.MAPclassiquesave\
       FCC    \cdesinfos\
       FCB    RC,LF
       FCC    \suppl\
       FCB    SS2,$42
       FCC    \ementairespourlemode\
       FCC    \vid\
       FCB    SS2,$42
       FCC    \eo.\
       FCB    RC,LF,LF
       FCC    \LelogicielBASICTO-\
       FCC    \SNAP.BASvous\
       FCB    RC,LF
       FCC    \montrecommentutiliser\
       FCC    \compl\
       FCB    SS2,$41
       FCC    \etement\
       FCB    RC,LF
       FCC    \detelsfichiers\
       FCB    SS2,$41
       FCC    \apartirdevos\
       FCB    RC,LF
       FCC    \propresprogrammes!\
       FCB    0

HLP7   FCC    \Commandesdisponibles\
       FCC    \horsmenu\ :\
       FCB    RC,LF,LF
       FCC    \L:\
       FCC    \lancementprog.avec\
       FCC    \SNAPactif\
       FCB    RC,LF
       FCC    \D:\
       FCC    \acc\
       FCB    SS2,$41
       FCC    \es\
       FCC    \audiaporama\
       FCB    RC,LF
       FCC    \I:\
       FCC    \acc\
       FCB    SS2,$41
       FCC    \esauxinfo.vid\
       FCB    SS2,$42
       FCC    \eo\
       FCB    RC,LF
       FCC    \F:\
       FCC    \acc\
       FCB    SS2,$41
       FCC    \esaumenufichier\
       FCB    RC,LF
       FCC    \Q:\
       FCC    \quitteTO-SNAP\
       FCB    RC,LF
       FCB    HT,SS2,$2C,SS2,$2D
       FCC    \:\
       FCC    \visualisel'\
       FCB    SS2,$42
       FCC    \eRCanpr\
       FCB    SS2,$42
       FCC    \ec\
       FCB    SS2,$42
       FCC    \edent\
       FCB    RC,LF
       FCB    HT,SS2,$2E,SS2,$2F
       FCC    \:\
       FCC    \visualisel'\
       FCB    SS2,$42
       FCC    \eRCansuivant\
       FCB    RC,LF
       FCC    \DEL:d\
       FCB    SS2,$42
       FCC    \etruitl'\
       FCB    SS2,$42
       FCC    \eRCancourant\
       FCB    RC,LF,LF
       FCC    \Commandesdufen\
       FCB    SS2,$43
       FCC    \etrage :\
       FCB    RC,LF,LF
       FCC    \RAZ:\
       FCB    SS2,$42
       FCC    \fermefen\
       FCB    SS2,$43
       FCC    \etre,annules\
       FCB    SS2,$42
       FCC    \election\
       FCB    RC,LF
       FCC    \ENT:\
       FCC    \acceptes\
       FCB    SS2,$42
       FCC    \election\
       FCB    0

* Motifs
*---------------------------------------

       FDB    $F00F,$F00F,$F00F,$F00F
TRAME  EQU    *

       FDB    $0000,$0000,$0000,$0000
VIDE   EQU    *

*      Palette du mode dialogue
*---------------------------------------

PALDEF FDB    0000,0015,0240,0255
       FDB    3840,3855,4080,4095
       FDB    1911,0826,0931,0938
       FDB    2611,2618,3815,0123

*      Mémorisation palette à l'appel
*---------------------------------------

TFMEMO FCB    $FF
TMEMO  FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $FFFF,$FFFF,$FFFF,$FFFF
       FDB    $FFFF,$FFFF,$FFFF,$FFFF

*      Mémo flag échec boot & vecteurs
*---------------------------------------

VECTMM FDB    $0000,$0000,$0000,$0000
       FDB    $0000,$0000,$0000,$0000
       FDB    $0000,$0000,$0000
TIMEMM FDB    $0000
IRQMM  FDB    $0000
FIRQMM FDB    $0000
SWIMM  FDB    $0000
PTGEMM FDB    $0000
RESEMM FCB    $00
       FDB    $0000
BUFCMM FDB    $0000
SIZCMM FCB    $00
USERMM FDB    $0000
FLGBOO FCB    0
ADRIT  FDB    $608E

*      Mnémo des déroutements SNAP
*---------------------------------------

TYPDER FCB    0       défaut par FIRQ

TABDER FCB    $44,SS2,$42
       FCC    \erouteFIRQPT\
       FCB    0,$44,SS2,$42
       FCC    \erouteRESETP\
       FCB    0,$44,SS2,$42
       FCC    \erouteTIMEPT\
       FCB    0,$44,SS2,$42
       FCC    \erouteGETLP\
       FCB    0,$44,SS2,$42
       FCC    \erouteLPINT\
       FCB    0,$44,SS2,$42
       FCC    \erouteGETPERI\
       FCB    0,$44,SS2,$42
       FCC    \erouteGACHPERI\
       FCB    0,$44,SS2,$42
       FCC    \eroutePUTCH\
       FCB    0,$44,SS2,$42
       FCC    \erouteGETCH\
       FCB    0,$44,SS2,$42
       FCC    \erouteDRAWXY\
       FCB    0,$44,SS2,$42
       FCC    \eroutePLOTXY\
       FCB    0,$44,SS2,$42
       FCC    \erouteRSCONT\
       FCB    0,$44,SS2,$42
       FCC    \erouteGETPT\
       FCB    0,$44,SS2,$42
       FCC    \erouteGETSC\
       FCB    0,$44,SS2,$42
       FCC    \erouteBUFCLV\
       FCB    0

*      Mnémo des modes graphiques
*---------------------------------------

TMNGR  FCB    $00,0
       FCC    \TO7-70\
       FCB    0
       FCB    $80,1
       FCC    \80colonnes   \
       FCB    0
       FCB    $40,3
       FCC    \Bitmap 16     \
       FCB    0
       FCB    $20,11
       FCC    \Tripleoverlay\
       FCB    0
       FCB    $08,7
       FCC    \Doubleoverlay\
       FCB    0
       FCB    $04,5
       FCC    \Page2\
       FCB    0
       FCB    $02,4
       FCC    \Page1\
       FCB    0
       FCB    $01,2
       FCC    \Bitmap 4      \
       FCB    0
       FCB    $FF

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
MVPEL  FCB    ESC,$4E,HT,SS2,$2E
       FCC    \PELLICULE\
       FCB    ESC,$4C,0
MCOMAL FCC    \To-snap\
       FCB    0
MPLEIN FCC    \PLUSD'ECRANVIERGE\
       FCB    0
MPASPH FCC    \ECRANVIERGE\
       FCB    0
MERRX  FCC    \ERREURCOMMUNICATION\
       FCB    0
MPELVI FCC    \PELLICULEVIERGE\
       FCB    0
MNUMP  FCC    \LAISSER2##(NUMERO)\
       FCB    0
MPATIR FCC    \PASDETIROIR\
       FCB    0
PASBOO FCC    \PASDESECTEURDEBOOT\
       FCB    0
MSANN  FCC    \SANS-NOM\
