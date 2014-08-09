       FCC    #MTD:#
D0000  LBRA   D0090
       LBRA   D0020
D0010  LBRA   D1210
       LBSR   $ECB8
       LBSR   $ECB8
       LBSR   $ECB8
       LBSR   $ECB8
       LBSR   $ECB8
       LBSR   $ECB8
       LBSR   $ECB8
       LBSR   $ECB8
D0020  BSR    D0140
       CLR    <$49
       BSR    D0150
       LBSR   D0260
       LDA    #$02
D0030  PSHS   A
       CLR    <$58
D0040  LDD    #$0001
       STD    <$4B
       LDU    #$6200
       STU    <$4F
       LBSR   D0940
       BSR    D0170
       LDU    <$4F
       BCC    D0050
       LDA    <$58
       BNE    D0070
       COM    <$58
       BRA    D0040
D0050  LDY    #$627F
       PSHS   Y
       LDA    #$55
D0060  DEC    ,U
       COM    ,U
       ADDA   ,U+
       CMPU   ,S
       BNE    D0060
       PULS   Y
       CMPA   ,U
       BNE    D0080
       JMP    $6200
D0070  PULS   A
       DECA   
       BNE    D0030
D0080  CLR    <$80
       JMP    [$001E]
D0090  PSHS   U,Y,X,DP,B,A,CC
       BSR    D0140
       LDA    <$48
       CMPA   #$01
       BEQ    D0100
       LDA    <$49
       CMPA   #$04
       BEQ    D0130
D0100  BSR    D0150
       BSR    D0190
D0110  BSR    D0170
D0120  PULS   A
       EXG    A,CC
       LSRA   
       PULS   A,B,DP,X,Y,U,PC
D0130  LDU    #D0000    #$E004
       STU    <$55
       JSR    $FFA0
       BRA    D0120
D0140  LDA    #$60
       TFR    A,DP
       LDX    #$E7D0
       CLR    <$4E
       RTS    
D0150  LDD    <$48
       CMPA   #$01
       BNE    D0160
       LDB    #$01
D0160  LDU    #D0180    #$E0BE
       LDA    B,U
       STA    2,X
       STA    <$57
       RTS    
D0170  LDA    #$40
       STA    2,X
       RTS    
D0180  FCB    $41,$01,$42,$02
D0190  LDA    #$02
       PSHS   A
D0200  CLRA   
       LDB    <$48
D0210  LSRB   
       INCA   
       BCC    D0210
       DECA   
       ASLA   
       LDY    #D0250    #$E0F0
       JSR    [A,Y]
       BCC    D0240
       LDA    <$4E
       BITA   #$51
       BNE    D0240
D0220  DEC    ,S
       BEQ    D0230
       CLR    <$4E
       CMPA   #$08
       BEQ    D0200
       BSR    D0310
       BCS    D0220
       BRA    D0200
D0230  COMB   
D0240  PULS   A,PC
D0250  FDB    D0260     =$E0FE
       FDB    D0940     =$E3A7
       FDB    D0380     =$E16E
       FDB    D0410     =$E177
       FDB    D0390     =$E174
       FDB    D0310     =$E134
       FDB    D1100     =$E452
D0260  BSR    D0310
       BCS    D0300
       LDA    #$01
       STA    <$4B
       LBSR   D1160
       LDB    #$44
       LDA    1,X
       BITA   #$08
       BEQ    D0270
       LDB    #$43
D0270  STB    <$4E
       BSR    D0310
       CLR    <$52
       CLR    <$54
       CLR    ,X
       CLR    <$58
       LDD    <$E9
       SUBD   <$ED
       BGE    D0280
       COMA   
       COMB   
       ADDD   #$0001
D0280  TSTA   
       BNE    D0290
       TSTB   
       BPL    D0290
       COM    <$58
D0290  CLRA   
D0300  RTS    
D0310  LDB    #$64
D0320  LDA    1,X
       BITA   #$08
       BNE    D0330
       LDA    <$57
       ORA    #$10
       STA    2,X
       ANDA   #$EF
       STA    2,X
       BSR    D0360
       DECB   
       LBEQ   D1140
       BRA    D0320
D0330  BSR    D0350
       LBSR   D1200
       CLR    ,Y
       CLR    6,X
       RTS    
D0340  LDY    #$006C
       BRA    D0370
D0350  LDY    #$0750
       BRA    D0370
D0360  LDY    #$02EC
D0370  LEAY   -1,Y
       BNE    D0370
       RTS    
D0380  LDA    #$FF
       STA    <$58
       CLRA   
       RTS    
D0390  CLR    <$58
D0400  RTS    
D0410  LBSR   D1100
       BCS    D0400
       LDA    1,X
       BITA   #$04
       BEQ    D0420
       LDA    #$01
       LBRA   D1150
D0420  LDA    <$58
       LBNE   D0570
       LBSR   D0860
       LDB    #$19
       PSHS   CC
       LBSR   D0930
       LDY    #$7500
D0430  LEAY   -1,Y
       LBEQ   D1060
       LDB    ,X
       BITB   #$02
       BEQ    D0430
       STA    3,X
D0440  LDB    ,X
       BPL    D0440
       STA    3,X
D0450  LDB    ,X
       BPL    D0450
       LDB    #$FB
       STB    3,X
       CLRA   
D0460  LDB    ,X
       BPL    D0460
       LDB    ,U+
       STB    3,X
       DECA   
       BNE    D0460
D0470  LDB    ,X
       BITB   #$08
       BEQ    D0470
       BSR    D0340
       TST    <$48
       BPL    D0550
D0480  LBSR   D1120
       LDB    #$1B
       LBSR   D0930
       LDA    #$04
       LDY    #$7500
D0490  LEAY   -1,Y
       LBEQ   D0740
       LDB    ,X
       BITB   #$02
       BEQ    D0490
       LDB    3,X
D0500  DECA   
       LBEQ   D1080
D0510  LDB    ,X
       BPL    D0510
       LDB    3,X
       CMPB   #$FB
       BNE    D0500
       CLRA   
D0520  LDB    ,X
       BPL    D0520
       LDB    3,X
       CMPB   ,U+
       BNE    D0530
       DECA   
       BNE    D0520
D0530  LDB    ,X
       BITB   #$08
       BEQ    D0530
       TSTA   
       BNE    D0540
       BITB   #$04
D0540  LBNE   D0740
D0550  PULS   CC
       CLR    ,X
       RTS    
D0560  PSHS   CC
       BRA    D0480
D0570  LBSR   D0890
       LBSR   D0900
       PSHS   CC
       PSHS   B,A
       LBSR   D0760
       BCC    D0580
       PULS   A,B
       LBRA   D1060
D0580  LDB    #$FF
       STB    4,X
       LDD    #$0624
       STB    ,X
D0590  LDB    ,X
       BPL    D0590
       CLR    3,X
       DECA   
       BNE    D0590
D0600  LDB    ,X
       BPL    D0600
       LDD    #$FBC7
       STD    3,X
       LDB    #$FF
D0610  LDA    ,X
       BPL    D0610
       LDA    ,U+
       STD    3,X
       LDA    #$7F
D0620  LDB    ,X
       BPL    D0620
       LDB    ,U+
       STB    3,X
       DECA   
       BNE    D0620
D0630  LDB    ,X
       BPL    D0630
       PULS   B
       STB    3,X
       COMA   
       BNE    D0630
D0640  LDB    ,X
       BPL    D0640
       CLR    3,X
D0650  LDB    ,X
       BPL    D0650
       LDB    #$20
       STB    ,X
D0660  LDB    ,X
       BPL    D0660
       LDB    3,X
       COMA   
       BNE    D0660
       LEAS   -2,S
       LBSR   D0340
       TST    <$48
       BPL    D0720
D0670  LBSR   D1120
       BSR    D0760
       BCS    D0730
       LDB    #$FB
       STB    3,X
       LDD    #$8038
       STB    ,X
       LDY    #$0100
D0680  LEAY   -1,Y
       BEQ    D0730
       LDB    ,X
       BITB   #$01
       BEQ    D0680
       LDB    3,X
       LDB    #$28
       STB    ,X
D0690  LDB    ,X
       BPL    D0690
       LDB    3,X
       CMPB   ,U+
       BNE    D0730
       DECA   
       BNE    D0690
D0700  LDA    ,X
       BPL    D0700
       LDA    3,X
D0710  LDB    ,X
       BPL    D0710
       LDB    3,X
       CMPD   ,S
       BNE    D0730
D0720  PULS   A,B
       PULS   CC
       CLR    ,X
       RTS    
D0730  PULS   A,B
D0740  LDA    #$20
       LBRA   D1090
D0750  PSHS   CC
       LDD    #$5D30
       PSHS   B,A
       BRA    D0670
D0760  LDA    #$C7
       STA    4,X
       LDA    #$FE
       STA    3,X
       LDA    #$30
       LDU    <$4F
       ORCC   #$50
D0770  LDB    #$38
       STB    ,X
       LDY    #$1700
D0780  LEAY   -1,Y
       BEQ    D0850
       LDB    ,X
       BITB   #$01
       BEQ    D0780
       LDB    3,X
       LDB    #$28
       STB    ,X
D0790  LDB    ,X
       BPL    D0790
       LDB    3,X
       CMPB   <$4B
       BNE    D0840
D0800  LDB    ,X
       BPL    D0800
       LDB    3,X
       BNE    D0840
D0810  LDB    ,X
       BPL    D0810
       LDB    3,X
       CMPB   <$4C
       BNE    D0840
D0820  LDB    ,X
       BPL    D0820
       LDB    3,X
       BNE    D0840
       LBSR   D0340
       CLRA   
D0830  LDA    ,X
       RTS    
D0840  DECA   
       BNE    D0770
D0850  COMB   
       BRA    D0830
D0860  LDB    <$4B
       CMPB   #$39
       BPL    D0870
       LDD    #$9F20
       BRA    D0880
D0870  LDD    #$1F22
D0880  STA    7,X
       STB    1,X
       RTS    
D0890  LDA    #$BF
       STA    7,X
       CLR    1,X
       RTS    
D0900  LDU    <$4F
       LDY    #$0080
       LDD    #$BF84
D0910  PSHS   B,A
D0920  LDA    ,S
       EORA   ,U+
       PSHS   A
       LSRA   
       LSRA   
       LSRA   
       LSRA   
       EORA   ,S
       STA    ,S
       TFR    A,B
       LSRB   
       LSRB   
       LSRB   
       ASLA   
       ASLA   
       ASLA   
       ASLA   
       EORB   2,S
       STB    2,S
       TFR    A,B
       EORA   2,S
       STA    1,S
       ASLB   
       EORB   ,S
       STB    2,S
       LEAS   1,S
       LEAY   -1,Y
       BNE    D0920
       PULS   A,B,PC
D0930  LDA    <$4C
       STA    5,X
       LDA    #$0A
       STA    4,X
       LDA    #$A1
       STA    3,X
       ORCC   #$50
       LDU    <$4F
       STB    ,X
       RTS    
D0940  LBSR   D1100
       LBCS   D1050
       PSHS   CC
       LDA    <$58
       BNE    D1000
       BSR    D0860
       LDB    #$1B
       BSR    D0930
       LDA    #$04
       LDY    #$7500
D0950  LEAY   -1,Y
       BEQ    D1060
       LDB    ,X
       BITB   #$02
       BEQ    D0950
       LDB    3,X
D0960  DECA   
       BEQ    D1080
D0970  LDB    ,X
       BPL    D0970
       LDB    3,X
       CMPB   #$FB
       BNE    D0960
       CLRA   
D0980  LDB    ,X
       BPL    D0980
       LDB    3,X
       STB    ,U+
       DECA   
       BNE    D0980
D0990  LDB    ,X
       BITB   #$08
       BEQ    D0990
       BITB   #$04
       BNE    D1070
       BRA    D1040
D1000  LBSR   D0890
       LBSR   D0760
       BCS    D1060
       LEAY   3,Y
       LBSR   D0370
       LDB    #$FB
       STB    3,X
       LDD    #$8038
       STB    ,X
       LDY    #$0100
D1010  LEAY   -1,Y
       BEQ    D1080
       LDB    ,X
       BITB   #$01
       BEQ    D1010
       LDB    3,X
       LDB    #$28
       STB    ,X
D1020  LDB    ,X
       BPL    D1020
       LDB    3,X
       STB    ,U+
       DECA   
       BNE    D1020
D1030  LDB    ,X
       BPL    D1030
       LDB    3,X
       PSHS   B
       COMA   
       BNE    D1030
       LBSR   D0900
       EXG    A,B
       CMPD   ,S++
       BNE    D1070
D1040  PULS   CC
       CLR    ,X
D1050  RTS    
D1060  LDA    #$04
       BRA    D1090
D1070  LDA    #$08
       BRA    D1090
D1080  LDA    #$02
D1090  STA    <$4E
       CLR    ,X
       PULS   CC
       COMA   
       RTS    
D1100  BSR    D1120
       BCS    D1110
       BSR    D1160
       CLRA   
D1110  RTS    
D1120  LDY    #$8000
D1130  LDB    <$57
       ORB    #$04
       STB    2,X
       ANDB   #$FB
       STB    2,X
       LEAY   -1,Y
       BEQ    D1140
       LDB    1,X
       ANDB   #$02
       BEQ    D1130
       CLRA   
       RTS    
D1140  LDA    #$10
D1150  PSHS   CC
       BRA    D1090
D1160  LBSR   D0360
       BSR    D1200
       LDB    ,Y
       LDA    <$57
       SUBB   <$4B
       BEQ    D1190
       BPL    D1170
       ORA    #$20
       NEGB   
D1170  STA    2,X
D1180  ORA    #$14
       STA    2,X
       ANDA   #$EB
       STA    2,X
       LBSR   D0360
       DECB   
       BNE    D1180
       LBSR   D0350
D1190  BSR    D1200
       LDB    <$4B
       STB    6,X
       STB    ,Y
       RTS    
D1200  LDY    #$6052
       LDA    <$49
       ANDA   #$02
       LEAY   A,Y
       RTS    
D1210  PSHS   U,Y,X,DP,B,A,CC
       LBSR   D0140
       LDA    <$49
       CMPA   #$04
       BNE    D1220
       LDU    #D0010    #$E00A
       STU    <$55
       JSR    $FFA0
       BRA    D1270
D1220  BSR    D1310
       LDA    <$48
       ANDA   #$80
       STA    <$48
       LBSR   D0150
       LBSR   D1120
       BCS    D1270
       LBSR   D0310
       BCS    D1270
       CLR    <$4B
       BSR    D1280
       BCS    D1270
D1230  PSHS   CC
       ORCC   #$50
       LBSR   D1380
       LDA    #$02
       PSHS   A
D1240  LBSR   D1440
       LDX    #$E7D0
       LBSR   D1120
       LBSR   D1520
       BCC    D1250
       DEC    ,S
       BNE    D1240
       PULS   A
       PULS   CC
       COMA   
       BRA    D1270
D1250  PULS   A
       PULS   CC
       LDA    <$4B
       CMPA   #$4F
       BEQ    D1260
       BSR    D1300
       BRA    D1230
D1260  LBSR   D1960
       BCS    D1270
       LDA    #$50
       STA    <$4B
D1270  LBRA   D0110
D1280  LDA    1,X
       BITA   #$04
       BNE    D1290
       CLRA   
       RTS    
D1290  LDA    #$01
       LBRA   D1150
D1300  INC    <$4B
       LBRA   D1160
D1310  PSHS   X
       LDU    #D1370    #$E55E
D1320  LDX    #$0003
       LDB    #$04
D1330  LDA    ,X
       CMPA   ,U
       BEQ    D1340
       INCB   
       LEAU   B,U
       LDA    ,U
       BNE    D1320
       BRA    D1360
D1340  LEAX   -1,X
       BNE    D1350
       LDX    #$001A
D1350  LEAU   1,U
       DECB   
       BNE    D1330
       LDA    ,U
       STA    <$58
D1360  PULS   X,PC
D1370  FCB    $52,$45,$47,$6E
       FCB    $FF,$43,$49,$50
       FCB    $4A,$FF,$4C,$45
       FCB    $4D,$74,$FF,$4C
       FCB    $4F,$50,$B5,$00
       FCB    $53,$45,$47,$B6
       FCB    $00,$00
D1380  LDX    #$60D3
       LDB    #$10
D1390  CLR    B,X
       DECB
       BNE    D1390
       LEAX   $10,X
       PSHS   X
       LDX    #$60D3
       LDA    #$01
       LDB    <$4D
D1400  STA    ,X
       LEAX   B,X
       INCA
       CMPA   #$10
       BHI    D1430
D1410  CMPX   ,S
       BCS    D1420
       LEAX   -16,X
D1420  TST    ,X
       BEQ    D1400
       LEAX   1,X
       BRA    D1410
D1430  LEAS   2,S
       RTS    
D1440  LDX    #$60D3
       LDU    <$4F
D1450  LDB    ,X+
       BEQ    D1470
       LDA    <$4B
       STA    ,U
       CLR    1,U
       STB    2,U
       LDY    #$0004
       LDA    <$58
       INCA   
       STA    3,U
       BEQ    D1480
       LDD    #$B230
D1460  LBSR   D0910
       STD    ,U++
       BRA    D1450
D1470  RTS    
D1480  LDD    #$EF21
       BRA    D1460
D1490  LDB    1,X
       BITB   #$40
       BEQ    D1490
D1500  LDB    3,X
       LDB    ,X
       BPL    D1500
D1510  LDB    ,X
       BPL    D1510
       RTS    
D1520  LDA    #$10
       PSHS   A
       LDU    <$4F
       LDA    <$58
       LBNE   D1720
       LBSR   D0860
       BSR    D1490
       LDD    #$4EFF
       STD    3,X
       LDB    #$04
       STB    ,X
D1530  LDA    #$1E
D1540  LDB    ,X
       BPL    D1540
       LDB    #$4E
       STB    3,X
       DECA   
       BNE    D1540
D1550  LDA    #$0C
D1560  LDB    ,X
       BPL    D1560
       CLR    3,X
       DECA   
       BNE    D1560
D1570  LDB    ,X
       BPL    D1570
       LDD    #$A10A
       STD    3,X
D1580  LDB    ,X
       BPL    D1580
       STA    3,X
D1590  LDB    ,X
       BPL    D1590
       STA    3,X
D1600  LDB    ,X
       BPL    D1600
       LDD    #$FEFF
       STD    3,X
       LDA    #$06
D1610  LDB    ,X
       BPL    D1610
       LDB    ,U+
       STB    3,X
       DECA   
       BNE    D1610
       LDA    #$16
D1620  LDB    ,X
       BPL    D1620
       LDB    #$4E
       STB    3,X
       DECA   
       BNE    D1620
       LDA    #$0C
D1630  LDB    ,X
       BPL    D1630
       CLR    3,X
       DECA   
       BNE    D1630
D1640  LDB    ,X
       BPL    D1640
       LDD    #$A10A
       STD    3,X
D1650  LDB    ,X
       BPL    D1650
       STA    3,X
D1660  LDB    ,X
       BPL    D1660
       STA    3,X
D1670  LDB    ,X
       BPL    D1670
       LDD    #$FBFF
       STD    3,X
       CLRA   
D1680  LDB    ,X
       BPL    D1680
       LDB    #$E5
       STB    3,X
       DECA   
       BNE    D1680
D1690  LDB    ,X
       BPL    D1690
       LDB    #$78
       STB    3,X
D1700  LDB    ,X
       BPL    D1700
       LDB    #$27
       STB    3,X
       LDA    #$2C
D1710  LDB    ,X
       BPL    D1710
       LDB    #$4E
       STB    3,X
       DECA   
       BNE    D1710
       DEC    ,S
       LBNE   D1550
       LBRA   D1870
D1720  LBSR   D0890
       LBSR   D1490
       LDD    #$FFFF
       STD    3,X
       LDB    #$24
       STB    ,X
       LDA    #$10
D1730  LDB    ,X
       BPL    D1730
       LDB    #$FF
       STB    3,X
       DECA   
       BNE    D1730
D1740  LDA    #$06
D1750  LDB    ,X
       BPL    D1750
       CLR    3,X
       DECA   
       BNE    D1750
D1760  LDB    ,X
       BPL    D1760
       LDD    #$FEC7
       STD    3,X
D1770  LDB    ,X
       BPL    D1770
       LDB    #$FF
       LDA    ,U+
       STD    3,X
       LDA    #$05
D1780  LDB    ,X
       BPL    D1780
       LDB    ,U+
       STB    3,X
       DECA   
       BNE    D1780
       LDA    #$0C
D1790  LDB    ,X
       BPL    D1790
       LDB    #$FF
       STB    3,X
       DECA   
       BNE    D1790
       LDA    #$06
D1800  LDB    ,X
       BPL    D1800
       CLR    3,X
       DECA   
       BNE    D1800
D1810  LDB    ,X
       BPL    D1810
       LDD    #$FBC7
       STD    3,X
D1820  LDB    ,X
       BPL    D1820
       LDD    #D1530    #$E5FF
       STD    3,X
       LDA    #$7F
D1830  LDB    ,X
       BPL    D1830
       LDB    #$E5
       STB    3,X
       DECA   
       BNE    D1830
D1840  LDB    ,X
       BPL    D1840
       LDB    #$5D
       STB    3,X
D1850  LDB    ,X
       BPL    D1850
       LDB    #$30
       STB    3,X
       LDA    #$16
D1860  LDB    ,X
       BPL    D1860
       LDB    #$FF
       STB    3,X
       DECA   
       BNE    D1860
       DEC    ,S
       LBNE   D1740
D1870  LDA    1,X
       BITA   #$40
       BNE    D1890
D1880  LDA    ,X
       BPL    D1880
       STB    3,X
       BRA    D1870
D1890  PULS   A
       CLR    ,X
       TST    <$48
       BPL    D1930
       LDA    #$E5
       BSR    D1940
       LDU    #$60D3
       LBSR   D1120
D1900  LDA    ,U+
       BEQ    D1930
       STA    <$4C
       PSHS   U
       LDA    <$58
       BEQ    D1910
       LBSR   D0750
       BRA    D1920
D1910  LBSR   D0560
D1920  PULS   U
       BCC    D1900
D1930  RTS    
D1940  LDU    <$4F
       LDB    <$58
       ANDB   #$80
D1950  STA    ,U+
       DECB   
       BNE    D1950
       RTS
D1960  LDA    #$14
       STA    <$4B
       LBSR   D1160
       LDA    #$FF
       BSR    D1940
       LDA    #$10
       STA    <$4C
D1970  LBSR   D1120
       LBSR   D0420
       BCS    D1980
       DEC    <$4C
       BNE    D1970
       LDU    <$4F
       CLR    ,U
       LDD    #$FEFE
       STD    $29,U
       LDA    #$02
       STA    <$4C
       LBSR   D0420
       BCS    D1980
       CLRA
D1980  RTS
