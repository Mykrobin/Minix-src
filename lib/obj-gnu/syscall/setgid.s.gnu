/ Translated from ack to gnu by asmconv 1.12
# 1 "setgid.s"
.text
.globl	__setgid
.globl	_setgid
.globl	_setegid
.balign	2

_setgid:
	jmp	__setgid

_setegid:
	jmp	__setegid
