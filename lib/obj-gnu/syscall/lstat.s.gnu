/ Translated from ack to gnu by asmconv 1.12
# 1 "lstat.s"
.text
.globl	__lstat
.globl	_lstat
.balign	2

_lstat:
	jmp	__lstat
