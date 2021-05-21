/ Translated from ack to gnu by asmconv 1.12
# 1 "write.s"
.text
.globl	__write
.globl	_write
.balign	2

_write:
	jmp	__write
