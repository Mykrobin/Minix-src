/ Translated from ack to gnu by asmconv 1.12
# 1 "pipe.s"
.text
.globl	__pipe
.globl	_pipe
.balign	2

_pipe:
	jmp	__pipe
