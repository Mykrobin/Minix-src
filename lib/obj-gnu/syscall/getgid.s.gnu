/ Translated from ack to gnu by asmconv 1.12
# 1 "getgid.s"
.text
.globl	__getgid
.globl	_getgid
.balign	2

_getgid:
	jmp	__getgid
