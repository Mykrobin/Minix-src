/ Translated from ack to gnu by asmconv 1.12
# 1 "geteuid.s"
.text
.globl	__geteuid
.globl	_geteuid
.balign	2

_geteuid:
	jmp	__geteuid
