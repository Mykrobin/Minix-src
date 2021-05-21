/ Translated from ack to gnu by asmconv 1.12
# 1 "setuid.s"
.text
.globl	__setuid
.globl	_setuid
.globl	_seteuid
.balign	2

_setuid:
	jmp	__setuid

_seteuid:
	jmp	__seteuid
