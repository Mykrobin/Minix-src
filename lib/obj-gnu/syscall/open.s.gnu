/ Translated from ack to gnu by asmconv 1.12
# 1 "open.s"
.text
.globl	__open
.globl	_open
.balign	2

_open:
	jmp	__open
