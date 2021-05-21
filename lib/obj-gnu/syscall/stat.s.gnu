/ Translated from ack to gnu by asmconv 1.12
# 1 "stat.s"
.text
.globl	__stat
.globl	_stat
.balign	2

_stat:
	jmp	__stat
