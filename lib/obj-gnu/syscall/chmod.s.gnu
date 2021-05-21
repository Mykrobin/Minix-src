/ Translated from ack to gnu by asmconv 1.12
# 1 "chmod.s"
.text
.globl	__chmod
.globl	_chmod
.balign	2

_chmod:
	jmp	__chmod
