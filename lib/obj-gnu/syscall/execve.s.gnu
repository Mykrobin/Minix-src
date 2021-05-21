/ Translated from ack to gnu by asmconv 1.12
# 1 "execve.s"
.text
.globl	__execve
.globl	_execve
.balign	2

_execve:
	jmp	__execve
