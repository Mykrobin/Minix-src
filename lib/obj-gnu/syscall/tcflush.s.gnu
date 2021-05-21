/ Translated from ack to gnu by asmconv 1.12
# 1 "tcflush.s"
.text
.globl	__tcflush
.globl	_tcflush
.balign	2

_tcflush:
	jmp	__tcflush
