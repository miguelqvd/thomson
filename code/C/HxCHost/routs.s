	.module asm_routs
	.area .text
	.globl _delay

; Short delay used in disk operation to wait for FDC to handle commands
_delay:
	BSR hop
	BSR hop
	BSR hop
	BSR hop
	BSR hop
hop: RTS

