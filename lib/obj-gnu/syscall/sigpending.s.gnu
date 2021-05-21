/ Translated from ack to gnu by asmconv 1.12
# 1 "sigpending.s"
.text
.globl	__sigpending
.globl	_sigpending
.balign	2

_sigpending:
	jmp	__sigpending
