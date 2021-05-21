/ Translated from ack to gnu by asmconv 1.12
# 1 "stime.s"
.text
.globl	__stime
.globl	_stime
.balign	2

_stime:
	jmp	__stime
