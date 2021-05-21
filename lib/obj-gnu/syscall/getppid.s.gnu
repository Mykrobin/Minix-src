/ Translated from ack to gnu by asmconv 1.12
# 1 "getppid.s"
.text
.globl	__getppid
.globl	_getppid
.balign	2

_getppid:
	jmp	__getppid
