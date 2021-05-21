/ Translated from ack to gnu by asmconv 1.12
# 1 "brk.s"
.text
.globl	__brk
.globl	_brk
.balign	2

_brk:
	jmp	__brk
