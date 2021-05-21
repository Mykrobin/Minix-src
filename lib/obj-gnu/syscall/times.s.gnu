/ Translated from ack to gnu by asmconv 1.12
# 1 "times.s"
.text
.globl	__times
.globl	_times
.balign	2

_times:
	jmp	__times
