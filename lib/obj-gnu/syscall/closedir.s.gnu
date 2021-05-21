/ Translated from ack to gnu by asmconv 1.12
# 1 "closedir.s"
.text
.globl	__closedir
.globl	_closedir
.balign	2

_closedir:
	jmp	__closedir
