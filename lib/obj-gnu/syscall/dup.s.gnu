/ Translated from ack to gnu by asmconv 1.12
# 1 "dup.s"
.text
.globl	__dup
.globl	_dup
.balign	2

_dup:
	jmp	__dup
