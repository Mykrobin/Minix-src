/ Translated from ack to gnu by asmconv 1.12
# 1 "waitpid.s"
.text
.globl	__waitpid
.globl	_waitpid
.balign	2

_waitpid:
	jmp	__waitpid
