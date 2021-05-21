/ Translated from ack to gnu by asmconv 1.12
# 1 "sigaction.s"
.text
.globl	__sigaction
.globl	_sigaction
.balign	2

_sigaction:
	jmp	__sigaction
