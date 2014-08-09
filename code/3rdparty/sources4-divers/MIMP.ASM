       ORG    $A000

       LDA    #&64
       STA    $602B
       JSR    $E812
       LDX    #$A000
       STX    $9033
BCL4   LDA    #&08
       STA    $602B
       LDB    #&27
       JSR    $E812
       LDB    #&71
       JSR    $E812
       LDB    #&57
       JSR    $E812
       LDB    #&54
       JSR    $E812
       LDB    #&48
       JSR    $E812
       LDX    $9033
       LEAX   $78,X
       STX    $9037
BCL3   LDX    $9033
       LEAX   $3C0,X
       STX    $9035
       LDA    #$80
       STA    $9032
BCL2   LDX    $9033
       LDA    #$01
       STA    $9031
       CLR    $9030
BCL1   LDA    ,X
       ANDA   $9032
       CMPA   $9032
       BNE    J1
       LDB    $9031
       ADDB   $9030
       STB    $9030
J1     LEAX   $78,X
       LDB    $9031
       LDA    #$02
       MUL
       STB    $9031
       CMPX   $9035
       BNE    BCL1
       LDB    $9030
       JSR    $E812
       LDA    $9032
       LSRA
       STA    $9032
       CMPA   #$00
       BNE    BCL2
       LDX    $9033
       LEAX   $01,X
       STX    $9033
       CMPX   $9037
       BNE    BCL3
       LDB    #&10
       JSR    $E812
       LDX    $9033
       LEAX   $348,X
       STX    $9033
       CMPX   #$DC00
       LBNE   BCL4
       LDA    #&16
       STA    $602B
       JSR    $E812
       RTS
       END
