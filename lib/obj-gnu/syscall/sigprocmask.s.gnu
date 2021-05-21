/ Translated from ack to gnu by asmconv 1.12
# 1 "sigprocmask.s"
.text
.globl	__sigprocmask
.globl	_sigprocmask
.balign	2

_sigprocmask:
	jmp	__sigprocmask
