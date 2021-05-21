/ Translated from ack to gnu by asmconv 1.12
# 1 "getgroups.s"
.text
.globl	__getgroups
.globl	_getgroups
.balign	2

_getgroups:
	jmp	__getgroups
