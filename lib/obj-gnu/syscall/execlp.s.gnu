/ Translated from ack to gnu by asmconv 1.12
# 1 "execlp.s"
.text
.globl	__execlp
.globl	_execlp
.balign	2

_execlp:
	jmp	__execlp
