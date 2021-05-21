/ Translated from ack to gnu by asmconv 1.12
# 1 "fork.s"
.text
.globl	__fork
.globl	_fork
.balign	2

_fork:
	jmp	__fork
