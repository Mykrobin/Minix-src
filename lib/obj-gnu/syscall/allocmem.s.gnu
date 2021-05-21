/ Translated from ack to gnu by asmconv 1.12
# 1 "allocmem.s"
.text
.globl	__allocmem
.globl	_allocmem
.balign	2

_allocmem:
	jmp	__allocmem
