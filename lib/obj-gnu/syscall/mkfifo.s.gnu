/ Translated from ack to gnu by asmconv 1.12
# 1 "mkfifo.s"
.text
.globl	__mkfifo
.globl	_mkfifo
.balign	2

_mkfifo:
	jmp	__mkfifo
