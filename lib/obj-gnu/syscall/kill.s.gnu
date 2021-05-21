/ Translated from ack to gnu by asmconv 1.12
# 1 "kill.s"
.text
.globl	__kill
.globl	_kill
.balign	2

_kill:
	jmp	__kill
