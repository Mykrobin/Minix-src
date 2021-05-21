/ Translated from ack to gnu by asmconv 1.12
# 1 "time.s"
.text
.globl	__time
.globl	_time
.balign	2

_time:
	jmp	__time
