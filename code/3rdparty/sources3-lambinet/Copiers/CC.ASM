C0000  BSR    C0010
       LBRA   C0150
C0010  PSHS   B
       PSHS   X
       LDB    #$1B
       JSR    $E803
       LDB    #$41
       JSR    $E803
       LDB    #$1F
       JSR    $E803
       PULS   B
       JSR    $E803
       PULS   B
       JSR    $E803
       PULS   B
       CLRA   
       STD    >$6150
       BEQ    C0030
       LDA    #$02
       STA    >$6105
       LDY    #$6150
       CLR    >$617C
       LDB    #$42
       JSR    $EC0C
       LDX    #$6155
C0020  LDB    ,X+
       BEQ    C0040
       CMPB   #$20
       BLS    C0020
       JSR    $E803
       BRA    C0020
C0030  LDB    #$30
       JSR    $E803
C0040  RTS    
       LDY    #$00FF
       LDA    #$01
       JSR    $EC00
       LDB    #$80
       PSHS   B
C0050  DEC    ,S
       BEQ    C0090
       LDX    #$0BBB
C0060  LEAX   -1,X
       BNE    C0060
       LDX    #$FFFF
       LDY    #$0000
       LDA    #$01
       JSR    $EC00
       CMPX   #$F000
       BNE    C0070
       LDD    #$0011
       STD    >$8428
C0070  CMPX   #$F0FF
       BNE    C0080
       LDD    #$FFEF
       STD    >$8428
C0080  TFR    X,D
       ADDD   >$8428
       TFR    D,X
       CLRA   
       TFR    D,Y
       LDA    #$01
       JSR    $EC00
       BRA    C0050
C0090  LDX    #$F0FF
       LDY    #$00FF
       LDA    #$01
       JSR    $EC00
       PULS   B
       RTS    
C0100  BSR    C0130
       LDA    >$E7C3
       ANDA   #$FE
       STA    >$E7C3
       LDX    #$5E27
       LDD    #$04C8
C0110  STB    ,X
       LEAX   <$28,X
       DECA   
       BNE    C0110
       LDA    >$E7C3
       ORA    #$01
       STA    >$E7C3
       LDX    #$5E27
       LDD    #$0310
C0120  STB    ,X
       LEAX   <$28,X
       DECA   
       BNE    C0120
       LDB    #$F0
       STB    ,X
       RTS    
C0130  LDB    ,U+
       BEQ    C0140
       JSR    $E803
       BRA    C0130
C0140  RTS    
C0150  JSR    $E806
       BCS    C0150
       LDX    #$F0FF
       LDY    #$00FF
       LDA    #$01
       JSR    $EC00
C0160  LDX    #$0BBB
C0170  LEAX   -1,X
       BNE    C0170
       LDX    #$FFFF
       LDY    #$0000
       LDA    #$01
       JSR    $EC00
       CMPX   #$F000
       BNE    C0180
       LDD    #$0011
       STD    >$8428
C0180  CMPX   #$F0FF
       BNE    C0190
       LDD    #$FFEF
       STD    >$8428
C0190  TFR    X,D
       ADDD   >$8428
       TFR    D,X
       CLRA   
       TFR    D,Y
       LDA    #$01
       JSR    $EC00
       JSR    $E809
       BCC    C0160
       JSR    $E806
       LDX    #$F0FF
       LDY    #$00FF
       LDA    #$01
       JSR    $EC00
       RTS    
C0200  LDU    #C2180    #$7700
       LBSR   C0100
C0210  BSR    C0150
       ANDB   #$DF
C0220  CMPB   #$48
       BHI    C0210
       CMPB   #$41
       BLT    C0210
       SUBB   #$41
       ASLB   
       ASLB   
       ASLB   
       PSHS   B
       LDA    #$50
       MUL    
       ADDD   #$4703
       TFR    D,U
       LDA    >$E7C3
       ORA    #$01
       STA    >$E7C3
       LDD    #$1F0F
C0230  STA    ,U
       LEAU   <$28,U
       DECB   
       BNE    C0230
       LEAU   >-ç0257,U
       LDD    #$FF0F
C0240  STA    ,U
       LEAU   <$28,U
       DECB   
       BNE    C0240
       LEAU   >-ç0257,U
       LDB    #$0F
C0250  COM    ,U
       LEAU   <$28,U
       DECB   
       BNE    C0250
       LEAU   >-ç0257,U
       LDD    #$FF0F
C0260  STA    ,U
       LEAU   <$28,U
       DECB   
       BNE    C0260
       LEAU   >-ç0257,U
       LDD    #$F00F
C0270  STA    ,U
       LEAU   <$28,U
       DECB   
       BNE    C0270
       PULS   B
       LDU    #$83C0
       LEAU   B,U
       LDX    #$8412
       LDB    #$07
C0280  LDA    ,U+
       STA    ,X+
       DECB   
       BNE    C0280
       LDA    >$8412
       BNE    C0290
       LDU    #$7922
       LBSR   C0130
       LDB    >$8400
       LDX    #$574B
       LBSR   C0000
C0290  LDU    #$795C
       LBSR   C0130
C0300  LBSR   C0150
       CMPB   #$30
       BLT    C0300
       CMPB   #$39
       BHI    C0300
       JSR    $E803
       SUBB   #$30
       STB    >$8401
       LDA    #$0A
       MUL    
       STB    >$840B
C0310  LBSR   C0150
       CMPB   #$0D
       BEQ    C0320
       CMPB   #$30
       BLT    C0310
       CMPB   #$39
       BHI    C0310
       JSR    $E803
       SUBB   #$30
       ADDB   >$840B
       STB    >$8401
C0320  LDB    >$8412
       BNE    C0330
       LDB    >$8401
       CMPB   >$8400
       BHI    C0290
C0330  LDU    #$7988
       LBSR   C0100
C0340  LBSR   C0150
       CMPB   #$4E
       LBEQ   C0200
       CMPB   #$6E
       LBEQ   C0200
       CMPB   #$4F
       BEQ    C0350
       CMPB   #$6F
       BNE    C0340
C0350  LDB    >$8412
       BNE    C0360
       LDB    >$8400
       SUBB   >$8401
       STB    >$8400
C0360  LDU    >$8417
       LBSR   C0130
       TST    >$8412
       BEQ    C0370
       LDU    #$7A9A
       BRA    C0380
C0370  LDU    #$7AC6
C0380  LBSR   C0130
       LDA    #$00
       STA    >$8408
C0390  LDA    >$8408
       CMPA   #$50
       LBEQ   C0200
       STA    >$8407
C0400  LDU    #$7AF2
       LBSR   C0130
       LBSR   C0150
       JSR    $E09D
       JSR    $E0A7
       JSR    $E452
       BCS    C0410
       LDA    1,X
       BITA   #$04
       BNE    C0420
C0410  JSR    $E0B9
       LDU    #$7BAA
       LBSR   C0130
       LBSR   C0150
       BRA    C0400
C0420  JSR    $E0B9
       LDU    #$7C66
       LBSR   C0130
       LBSR   C0520
       CMPA   #$00
       BEQ    C0430
       LDU    #$7C9D
       LBSR   C0130
       LBSR   C0150
       LBRA   C0200
C0430  CLR    >$83FF
C0440  LDA    >$604B
       CMPA   #$50
       BNE    C0450
       DEC    >$604B
C0450  INC    >$83FF
       LDA    >$83FF
       CMPA   >$8401
       BHI    C0390
C0460  LDU    #$7D55
       LBSR   C0130
       LDB    >$83FF
       LDX    #$4F4D
       LBSR   C0010
       LBSR   C0150
       JSR    $E09D
       JSR    $E0A7
       JSR    $E452
       BCS    C0470
       LDA    1,X
       BITA   #$04
       BEQ    C0480
C0470  JSR    $E0B9
       LDU    #$7E0B
       LBSR   C0130
       LBSR   C0150
       BRA    C0460
C0480  JSR    $E0B9
       LDU    #$7EC7
       LBSR   C0130
       LBSR   C1170
       CMPA   #$00
       BEQ    C0440
       LDU    #$7EFF
       LBSR   C0130
C0490  LBSR   C0150
       CMPB   #$41
       BEQ    C0510
       CMPB   #$61
       BEQ    C0510
       CMPB   #$52
       BEQ    C0500
       CMPB   #$72
       BNE    C0490
C0500  BRA    C0460
C0510  LBRA   C0220
C0520  TST    >$8412
       LBNE   C0970
       LDX    #$A000
       STX    >$8402
       LDA    #$02
       STA    >$E7E5
       LDA    >$8407
       STA    >$604B
       LDX    #$8450
       STX    >$8419
C0530  CLR    >$6049
       LDA    #$40
       STA    >$6048
       JSR    $E004
       LDA    >$8413
       BEQ    C0540
       BSR    C0580
       CMPA   #$01
       BEQ    C0570
C0540  INC    >$6049
       LDA    >$8414
       BEQ    C0550
       BSR    C0580
       CMPA   #$01
       BEQ    C0570
C0550  LDA    >$604B
       INCA   
       STA    >$604B
       CMPA   #$50
       BNE    C0530
C0560  STA    >$8408
       CLRA   
       RTS    
C0570  LDA    >$604B
       BRA    C0560
C0580  LDA    #$0F
       STA    >$7098,PCR=C0810+1
       JSR    $E09D
       JSR    $E0A7
       JSR    $E45A
       JSR    $E341
       PSHS   CC
       LDB    #$1B
       JSR    $E394
       LDD    #$E718
       TFR    A,DP
       STB    <$D0
       LDA    #$02
       STA    >$6200
C0590  LDY    #$1858
       LDU    #$8600
       LDX    #$85FD
       LDA    #$40
C0600  BITA   <$D1
       BEQ    C0600
C0610  BITA   <$D1
       BNE    C0610
       LDA    <$D3
C0620  LDB    <$D0
       BPL    C0620
       LEAY   -1,Y
       LBEQ   $715B    =C0950+1
       LDA    <$D3
       BITB   #$01
       BEQ    C0620
       TFR    Y,D
       ADDD   #$8600
       STD    <$702E,PCR=C0730+1
C0630  LDA    <$D0
       BPL    C0630
C0640  LDA    <$D3
       CMPA   #$A1
       BEQ    C0660
       STA    ,X+
C0650  LDD    <$D0
       BPL    C0650
       BITA   #$01
       BEQ    C0700
       LDA    <$D3
       CMPA   #$A1
       BNE    C0680
       BITB   #$40
       BNE    C0710
       LEAX   -1,X
C0660  LEAX   3,X
       PSHU   X
C0670  LDD    <$D0
       BPL    C0670
       LDA    <$D3
       BITB   #$40
       BNE    C0710
       CMPA   #$A1
       BEQ    C0670
C0680  STA    ,X+
C0690  LDD    <$D0
       BPL    C0690
       BITA   #$01
       BNE    C0640
C0700  LDA    <$D3
       BITB   #$40
       BEQ    C0680
C0710  STA    ,X+
C0720  LDB    <$D0
       BPL    C0720
       BITB   #$01
       BNE    C0740
       LDA    <$D3
C0730  CMPX   #$0000
       BCS    C0710
C0740  CMPU   #$85FB
       BCS    C0750
       DEC    >$6200
       LBNE   C0590
       LBRA   $715E    =C0960+1
C0750  LDY    #$A000
       LDD    #$0001
       STD    ,--Y
       TFR    X,D
       SUBD   #$8600
       CMPD   >$840E
       BMI    C0780
       PSHS   U,B,A
       LDD    #$8600
       SUBD   2,S
       LSRA   
       RORB   
       PSHS   B,A
       LDD    2,S
C0760  DEC    <$7098,PCR=C0810+1
       BPL    C0770
       LEAS   6,S
       LBRA   $715E    =C0960+1
C0770  SUBD   ,S
       CMPD   >$840E
       BHI    C0760
       LEAS   4,S
       PULS   U
C0780  STD    ,--Y
C0790  PSHS   Y
C0800  LDA    ,-X
       STA    ,-Y
       CMPX   ,U
       BHI    C0800
       PULS   A,B
       SUBD   #$0001
       STD    ,--Y
       PULU   X
       CMPU   #$8600
       BEQ    C0820
       LEAX   <-$1E,X
C0810  LEAX   12,X
       BRA    C0790
C0820  TFR    Y,X
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       NOP    
       STY    >$8500
       TFR    Y,X
       LDY    #$8502
       STY    >$8405
       LDU    #$8504
C0830  LDY    #$0000
C0840  LDA    ,X+
       CMPX   #$9FFF
       BEQ    C0890
       CMPA   ,X
       BNE    C0850
       CMPA   1,X
       BNE    C0850
       CMPA   2,X
       BEQ    C0860
C0850  STA    ,U+
       LEAY   1,Y
       BRA    C0840
C0860  TFR    Y,D
       LDY    >$8405
       STD    ,Y
       LDB    #$00
       LDA    ,X
       STA    ,U+
C0870  LDA    ,X+
       CMPX   #$9FFF
       BEQ    C0900
       INCB   
       BEQ    C0880
       CMPA   -1,U
       BEQ    C0870
C0880  DECB   
       STB    ,U+
       STU    >$8405
       LEAU   2,U
       LEAX   -1,X
       BRA    C0830
C0890  TFR    Y,D
       LDY    >$8405
       STD    ,Y
       BRA    C0910
C0900  STB    ,U+
C0910  STU    >$8405
       LDX    #$8500
       LDY    >$8402
C0920  LDA    ,X+
       STA    ,Y+
       CMPY   #$E000
       BNE    C0930
       LDY    #$A000
       LDA    >$E7E5
       INCA   
       CMPA   >$8404
       BEQ    $7158    =C0940+1
       STA    >$E7E5
C0930  CMPX   >$8405
       BNE    C0920
       STY    >$8402
       CLRA   
C0940  TST    >$8601
C0950  TST    >$86FE
C0960  TST    >$86FF
       PULS   CC
       CLR    <$D0
       LDB    #$40
       STB    <$D2
       LDU    >$8419
       STA    ,U+
       STU    >$8419
       RTS    
C0970  PSHS   CC
       ORCC   #$50
       LDX    #$A000
       STX    >$8402
       LDA    #$02
       STA    >$E7E5
       LDA    >$8407
       STA    >$604B
       LDX    #$8440
       STX    >$8420
       LDX    #$8580
       STX    >$8422
C0980  CLR    >$6049
       LDA    #$40
       STA    >$6048
       JSR    $E004
       LDA    >$8413
       BEQ    C0990
       BSR    C1010
C0990  INC    >$6049
       LDA    >$8414
       BEQ    C1000
       BSR    C1010
C1000  LDA    >$604B
       INCA   
       STA    >$604B
       CMPA   #$50
       BNE    C0980
       STA    >$8408
       CLRA   
       PULS   CC,PC
C1010  STA    >$E7D2
       LDX    #$83B0
       LDB    #$10
C1020  LDA    ,X+
       PSHS   A
       DECB   
       BNE    C1020
       LDA    #$E7
       TFR    A,DP
       LDX    >$8402
       LDU    >$8422
       LDA    #$01
C1030  CLR    <$D0
       STA    <$D5
       LDA    #$0A
       STA    <$D4
       LDA    #$A1
       STA    <$D3
       LDD    #$041B
       STB    <$D0
       CMPX   #$E000
       BNE    C1040
       LDX    #$A000
       LDB    <$E5
       INCB   
       CMPB   >$8404
       BEQ    C1150
       STB    <$E5
       NOP    
C1040  LDY    #C1720    #$7500
C1050  LEAY   -1,Y
       BEQ    C1140
       LDB    <$D0
       BITB   #$02
       BEQ    C1050
       LDB    <$D3
C1060  DECA   
       BEQ    C1140
C1070  LDB    <$D0
       BPL    C1070
       LDB    <$D3
       CMPB   #$FB
       BNE    C1060
       CLRA   
C1080  LDB    <$D0
       BPL    C1080
       LDB    <$D3
       STB    ,X+
       STB    ,U
       DECA   
C1090  LDB    <$D0
       BPL    C1090
       LDB    <$D3
       STB    ,X+
       CMPB   ,U
       BNE    C1110
       DECA   
       BNE    C1090
       LEAX   >-ç0100,X
       DECA   
       BRA    C1120
C1100  LDB    <$D0
       BPL    C1100
       LDB    <$D3
       STB    ,X+
C1110  DECA   
       BNE    C1100
C1120  LDB    <$D0
       BITB   #$08
       BEQ    C1120
       BITB   #$04
       BNE    C1140
       LEAU   1,U
       STA    ,U+
       PULS   A
       TSTA   
       LBNE   C1030
       STU    >$8422
       STX    >$8402
C1130  LDD    #$4000
       STB    <$D0
       STA    <$D2
       RTS    
C1140  BSR    C1130
       LDA    #$FF
       BRA    C1160
C1150  BSR    C1130
       LDA    >$604B
       STA    >$8408
       CLRA   
C1160  PULS   B
       TSTB   
       BNE    C1160
       LEAS   2,S
       PULS   CC,PC
       NOP    
       NOP    
       NOP    
C1170  TST    >$8412
       LBNE   C1710
       LDX    #$A000
       STX    >$8402
       LDA    #$02
       STA    >$E7E5
       LDA    >$8407
       STA    >$604B
       LDX    #$8450
       STX    >$8419
C1180  LDX    >$840E
       STX    >$8410
       JSR    $E09D
       JSR    $E452
       LDD    #$0020
       STD    <$49
       LDA    >$8415
       BEQ    C1190
       BSR    C1210
C1190  INC    >$6049
       LDA    >$8416
       BEQ    C1200
       BSR    C1210
C1200  LDA    >$604B
       INCA   
       STA    >$604B
       CMPA   >$8408
       BNE    C1180
       CLRA   
       RTS    
C1210  LDU    >$8419
       LDA    ,U+
       STU    >$8419
       TSTA   
       LBEQ   C1370
       CMPA   #$FF
       BEQ    C1260
       JSR    $E09D
       JSR    $E0A7
       JSR    $E341
       LDA    #$E7
       TFR    A,DP
       PSHS   CC
       ORCC   #$50
C1220  LDA    <$D1
       BITA   #$40
       BEQ    C1220
C1230  LDA    <$D3
       LDA    <$D0
       BPL    C1230
C1240  LDA    <$D0
       BPL    C1240
       LDD    #$4EFF
       STD    <$D3
       LDB    #$04
       STB    <$D0
       LDD    #$A00A
       STD    <$D3
       LDX    #$1900
C1250  LDA    <$D0
       BPL    C1250
       LDA    #$FE
       STA    <$D3
       LEAX   -1,X
       BNE    C1250
       PULS   CC
       LDA    #$00
       STA    <$D0
       LDA    #$40
       STA    <$D2
       RTS    
C1260  JSR    $E09D
       JSR    $E0A7
       JSR    $E341
       LDA    #$E7
       TFR    A,DP
       PSHS   A,CC
       ORCC   #$50
C1270  LDA    <$D1
       BITA   #$40
       BEQ    C1270
C1280  LDA    <$D3
       LDA    <$D0
       BPL    C1280
C1290  LDA    <$D0
       BPL    C1290
       LDD    #$4EFF
       STD    <$D3
       LDB    #$04
       STB    <$D0
       LDB    #$0C
C1300  LDA    <$D0
       BPL    C1300
       CLR    <$D3
       DECB   
       BNE    C1300
C1310  LDA    <$D0
       BPL    C1310
       LDD    #$A10A
       STD    <$D3
C1320  LDB    <$D0
       BPL    C1320
       STA    <$D3
C1330  LDB    <$D0
       BPL    C1330
       STA    <$D3
C1340  LDA    <$D0
       BPL    C1340
       LDD    #$FEFF
       STD    <$D3
       LDX    #$1900
C1350  LDA    <$D0
       BPL    C1350
       LDA    #$FF
       STA    <$D3
       LEAX   -1,X
       BNE    C1350
       LDA    #$00
       STA    <$D0
       LDA    #$40
       STA    <$D2
C1360  PULS   CC,A
       RTS    
C1370  LDX    >$8402
       BSR    C1430
       TFR    B,A
       BSR    C1430
       TFR    D,U
       PSHS   U
C1380  BSR    C1430
       TFR    B,A
       BSR    C1430
       TFR    D,Y
       CMPD   #$0000
       BEQ    C1400
C1390  BSR    C1430
       STB    ,U+
       LEAY   -1,Y
       BNE    C1390
C1400  CMPU   #$9FFE
       BEQ    C1420
       BSR    C1430
       TFR    B,A
       BSR    C1430
       STA    ,U+
C1410  STA    ,U+
       DECB   
       BNE    C1410
       CMPU   #$9FFE
       BNE    C1380
C1420  STX    >$8402
       BRA    C1450
C1430  LDB    ,X+
       CMPX   #$E000
       BNE    C1440
       LDX    #$A000
       INC    >$E7E5
C1440  RTS    
C1450  JSR    $E09D
       DEC    <$4A
       BEQ    C1360
       JSR    $E0A7
       JSR    $E45A
       JSR    $E341
       LDD    >$9FFC
       SUBD   >$8410
       BMI    C1460
       LDD    #$FFFF
C1460  TFR    D,Y
       LDA    #$E7
       TFR    A,DP
       LDX    ,S
       PSHS   CC
       ORCC   #$50
C1470  LDA    <$D1
       BITA   #$40
       BEQ    C1470
C1480  LDA    <$D3
       LDA    <$D0
       BPL    C1480
C1490  LDA    <$D0
       BPL    C1490
       LDD    #$4EFF
       STD    <$D3
       LDB    #$04
       STB    <$D0
       LDA    #$4E
C1500  LDB    <$D0
       BPL    C1500
       STA    <$D3
       LEAY   1,Y
       BNE    C1500
C1510  LDA    <$D0
       BPL    C1510
       CLR    <$D3
       LDU    ,X++
C1520  LDA    <$D0
       BPL    C1520
       CLR    <$D3
       STU    <$748A,PCR=C1620+1
C1530  LDA    <$D0
       BPL    C1530
       CLR    <$D3
       LDB    ,X+
C1540  LDA    <$D0
       BPL    C1540
       CLR    <$D3
       STB    <$747D,PCR=C1600+1
       LDB    #$08
C1550  LDA    <$D0
       BPL    C1550
       CLR    <$D3
       DECB   
       BNE    C1550
C1560  LDA    <$D0
       BPL    C1560
       LDD    #$A10A
       STD    <$D3
C1570  LDB    <$D0
       BPL    C1570
       STA    <$D3
C1580  LDB    <$D0
       BPL    C1580
       STA    <$D3
C1590  LDA    <$D0
       BPL    C1590
C1600  LDD    #$20FF
       STD    <$D3
C1610  LDA    <$D0
       BPL    C1610
       LDA    ,X+
       STA    <$D3
C1620  CMPX   #$F8F8
       BCS    C1610
       LDX    <$758A,PCR=C1820+3
C1630  LDA    <$D0
       BPL    C1630
       LDA    ,X+
       STA    <$D3
       CMPX   #$9FFC
       BCS    C1510
C1640  LDD    <$D0
       BPL    C1640
       BITB   #$40
       BEQ    C1670
       LDD    #$A10A
       STD    <$D3
C1650  LDA    <$D0
       BPL    C1650
       LDD    #$FBFF
       STD    <$D3
       NOP    
       NOP    
       PULS   CC,X
C1660  CLR    <$D0
       LDA    #$40
       STA    <$D2
       RTS    
C1670  CLRB   
C1680  INCB   
       BEQ    C1690
       PSHS   X
       PULS   X
       NOP    
       NOP    
       LDA    <$D1
       BITA   #$40
       BEQ    C1680
       CLRA   
       ADDD   >$8410
       SUBD   #$0001
       BRA    C1700
C1690  LDD    >$840E
C1700  STD    >$8410
       PULS   CC
       BSR    C1660
       LBRA   C1450
C1710  PSHS   CC
       ORCC   #$50
       LDX    #$A000
       STX    >$8402
       LDA    #$02
       STA    >$83F7
       LDA    >$8407
       STA    >$604B
       LDX    #$8440
       STX    >$8420
C1720  LDX    #$8580
       STX    >$8422
C1730  LDA    #$40
       STA    >$6048
       JSR    $E004
       CLR    >$6049
       LDA    >$8415
       BEQ    C1740
       BSR    C1770
C1740  INC    >$6049
       LDA    >$8416
       BEQ    C1750
       BSR    C1770
C1750  LDA    >$604B
       INCA   
       STA    >$604B
       CMPA   >$8408
       BNE    C1730
       CLRA   
C1760  PULS   CC,PC
C1770  STA    >$E7D2
       STA    >$841F
       LDA    #$03
       STA    >$841E
C1780  DEC    >$841E
       BNE    C1790
       COMA   
       LEAS   2,S
       BRA    C1760
C1790  LDX    #$83B0
       LDB    #$10
C1800  LDA    ,X+
       PSHS   A
       DECB   
       BNE    C1800
       LDA    #$E7
       TFR    A,DP
       LDX    >$8402
       LDA    >$83F7
       STA    >$E7E5
       LDU    >$8422
       LDA    #$01
C1810  CLR    <$D0
       STA    <$D5
       LDA    #$0A
       STA    <$D4
       LDA    #$A1
       STA    <$D3
       LDB    #$19
       STB    <$D0
       CMPX   #$E000
       BNE    C1820
       LDX    #$A000
       INC    >$E7E5
       LDB    >$E7E5
       CMPB   >$8404
       BEQ    C1920
C1820  LDY    #$5D00
C1830  LEAY   -1,Y
       BEQ    C1890
       LDB    <$D0
       BITB   #$02
       BEQ    C1830
       STA    <$D3
C1840  LDB    <$D0
       BPL    C1840
       STA    <$D3
C1850  LDB    <$D0
       BPL    C1850
       LDA    #$FB
       STA    <$D3
       LDD    ,U++
       TSTB   
       BEQ    C1870
       CLRB   
C1860  TST    <$D0
       BPL    C1860
       STA    <$D3
       DECB   
       BNE    C1860
       BRA    C1880
C1870  LDA    <$D0
       BPL    C1870
       LDA    ,X+
       STA    <$D3
       DECB   
       BNE    C1870
C1880  LDB    <$D0
       BITB   #$08
       BEQ    C1880
       PULS   A
       TSTA   
       BNE    C1810
       STU    >$8422
       STX    >$8402
       LDA    >$E7E5
       STA    >$83F7
       LDD    #$4000
       STB    <$D0
       STA    <$D2
       RTS    
C1890  PULS   A
       CMPA   #$00
       BNE    C1890
       LDX    #$83B0
       LDB    #$10
C1900  LDA    ,X+
       PSHS   A
       DECB   
       BNE    C1900
       LDA    #$01
       PSHS   A
       LDU    #$9A00
C1910  PULS   A
       CMPA   #$00
       BEQ    C1930
C1920  LDB    #$01
       STD    2,U
       LDA    >$604B
       CLRB   
       STD    ,U
       LDY    #$0004
       LDD    #$B230
       JSR    $E364
       STD    ,U++
       BRA    C1910
C1930  LDA    #$40
       STA    >$6048
       JSR    $E004
       LDA    >$841F
       STA    >$E7D2
       LDU    #$9A00
       LDA    #$10
       PSHS   A
C1940  LDA    <$D1
       BITA   #$40
       BEQ    C1940
C1950  LDA    <$D3
       LDA    <$D0
       BPL    C1950
C1960  LDA    <$D0
       BPL    C1960
       LDD    #$4EFF
       STD    <$D3
       LDB    #$04
       STB    <$D0
       LDA    #$1E
C1970  LDB    <$D0
       BPL    C1970
       LDB    #$4E
       STB    <$D3
       DECA   
       BNE    C1970
C1980  LDA    #$0C
C1990  LDB    <$D0
       BPL    C1990
       CLR    <$D3
       DECA   
       BNE    C1990
C2000  LDB    <$D0
       BPL    C2000
       LDD    #$A10A
       STD    <$D3
C2010  LDB    <$D0
       BPL    C2010
       STA    <$D3
C2020  LDB    <$D0
       BPL    C2020
       STA    <$D3
C2030  LDA    <$D0
       BPL    C2030
       LDD    #$FEFF
       STD    <$D3
       LDA    #$06
C2040  LDB    <$D0
       BPL    C2040
       LDB    ,U+
       STB    <$D3
       DECA   
       BNE    C2040
       LDA    #$16
C2050  LDB    <$D0
       BPL    C2050
       LDB    #$4E
       STB    <$D3
       DECA   
       BNE    C2050
       LDA    #$0C
C2060  LDB    <$D0
       BPL    C2060
       CLR    <$D3
       DECA   
       BNE    C2060
C2070  LDB    <$D0
       BPL    C2070
       LDD    #$A10A
       STD    <$D3
C2080  LDB    <$D0
       BPL    C2080
       STA    <$D3
C2090  LDB    <$D0
       BPL    C2090
       STA    <$D3
C2100  LDA    <$D0
       BPL    C2100
       LDD    #$FBFF
       STD    <$D3
       CLRA   
C2110  LDB    <$D0
       BPL    C2110
       LDB    #$E5
       STB    <$D3
       DECA   
       BNE    C2110
C2120  LDB    <$D0
       BPL    C2120
       LDB    #$78
       STB    <$D3
C2130  LDB    <$D0
       BPL    C2130
       LDB    #$27
       STB    <$D3
       LDA    #$2C
C2140  LDB    <$D0
       BPL    C2140
       LDB    #$4E
       STB    <$D3
       DECA   
       BNE    C2140
       DEC    ,S
       LBNE   C1980
C2150  LDA    <$D1
       BITA   #$40
       BNE    C2170
C2160  LDA    <$D0
       BPL    C2160
       STB    <$D3
       BRA    C2150
C2170  PULS   A
       LBRA   C1780
C2180  TFR    Y,D
       BCS    $771F
       ASRA   
       INC    <$14
       BLS    $7769
       NOP    
