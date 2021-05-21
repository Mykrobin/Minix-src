/ Translated from ack to gnu by asmconv 1.12
# 1 "wait.s"
.text
.globl	__wait
.globl	_wait
.balign	2

_wait:
	jmp	__wait
