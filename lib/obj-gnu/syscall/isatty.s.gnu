/ Translated from ack to gnu by asmconv 1.12
# 1 "isatty.s"
.text
.globl	__isatty
.globl	_isatty
.balign	2

_isatty:
	jmp	__isatty
