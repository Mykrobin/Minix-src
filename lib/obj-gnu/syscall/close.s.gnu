/ Translated from ack to gnu by asmconv 1.12
# 1 "close.s"
.text
.globl	__close
.globl	_close
.balign	2

_close:
	jmp	__close
