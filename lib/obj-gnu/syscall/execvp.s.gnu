/ Translated from ack to gnu by asmconv 1.12
# 1 "execvp.s"
.text
.globl	__execvp
.globl	_execvp
.balign	2

_execvp:
	jmp	__execvp
