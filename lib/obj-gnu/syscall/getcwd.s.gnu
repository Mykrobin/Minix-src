/ Translated from ack to gnu by asmconv 1.12
# 1 "getcwd.s"
.text
.globl	__getcwd
.globl	_getcwd
.balign	2

_getcwd:
	jmp	__getcwd
