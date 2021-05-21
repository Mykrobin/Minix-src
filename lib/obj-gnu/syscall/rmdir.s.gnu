/ Translated from ack to gnu by asmconv 1.12
# 1 "rmdir.s"
.text
.globl	__rmdir
.globl	_rmdir
.balign	2

_rmdir:
	jmp	__rmdir
