/ Translated from ack to gnu by asmconv 1.12
# 1 "umask.s"
.text
.globl	__umask
.globl	_umask
.balign	2

_umask:
	jmp	__umask
