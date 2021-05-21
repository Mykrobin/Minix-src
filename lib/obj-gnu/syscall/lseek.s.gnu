/ Translated from ack to gnu by asmconv 1.12
# 1 "lseek.s"
.text
.globl	__lseek
.globl	_lseek
.balign	2

_lseek:
	jmp	__lseek
