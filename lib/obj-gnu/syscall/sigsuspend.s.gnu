/ Translated from ack to gnu by asmconv 1.12
# 1 "sigsuspend.s"
.text
.globl	__sigsuspend
.globl	_sigsuspend
.balign	2

_sigsuspend:
	jmp	__sigsuspend
