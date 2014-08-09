       ORG    $A000

       LDY    $9003
       LEAY   $27,Y
       STY    $9007
       LDX    #$4667
       LDD    $9009
       LEAX   D,X
       STX    $9005
       LDD    #-$28
       LEAX   D,X
       STX    $900B
       LDX    $9005
BCL    CLRA
AFF    LDB    ,Y
       STB    ,X
       LEAY   $78,Y
       LEAX   $28,X
       INCA
       CMPA   #$40
       BNE    AFF
       LDX    $9005
       LEAX   -1,X
       STX    $9005
       LDY    $9007
       LEAY   -1,Y
       STY    $9007
       CMPX   $900B
       BNE    BCL
       RTS
       END
