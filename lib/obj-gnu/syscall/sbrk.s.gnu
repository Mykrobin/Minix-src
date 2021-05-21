/ Translated from ack to gnu by asmconv 1.12
# 1 "sbrk.s"
.text
.globl	__sbrk
.globl	_sbrk
.balign	2

_sbrk:
	jmp	__sbrk
