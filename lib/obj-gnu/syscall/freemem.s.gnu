/ Translated from ack to gnu by asmconv 1.12
# 1 "freemem.s"
.text
.globl	__freemem
.globl	_freemem
.balign	2

_freemem:
	jmp	__freemem
