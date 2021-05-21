/ Translated from ack to gnu by asmconv 1.12
# 1 "getpid.s"
.text
.globl	__getpid
.globl	_getpid
.balign	2

_getpid:
	jmp	__getpid
