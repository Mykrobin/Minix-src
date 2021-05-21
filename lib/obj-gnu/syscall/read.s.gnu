/ Translated from ack to gnu by asmconv 1.12
# 1 "read.s"
.text
.globl	__read
.globl	_read
.balign	2

_read:
	jmp	__read
