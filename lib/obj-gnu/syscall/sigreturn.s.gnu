/ Translated from ack to gnu by asmconv 1.12
# 1 "sigreturn.s"
.text
.globl	__sigreturn
.globl	_sigreturn
.balign	2

_sigreturn:
	jmp	__sigreturn
