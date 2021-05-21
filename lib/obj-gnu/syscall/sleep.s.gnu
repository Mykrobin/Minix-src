/ Translated from ack to gnu by asmconv 1.12
# 1 "sleep.s"
.text
.globl	__sleep
.globl	_sleep
.balign	2

_sleep:
	jmp	__sleep
