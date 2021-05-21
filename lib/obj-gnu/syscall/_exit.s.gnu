/ Translated from ack to gnu by asmconv 1.12
# 1 "_exit.s"
.text
.globl	___exit
.globl	__exit
.balign	2

__exit:
	jmp	___exit
