/ Translated from ack to gnu by asmconv 1.12
# 1 "setsid.s"
.text
.globl	__setsid
.globl	_setsid
.balign	2

_setsid:
	jmp	__setsid
