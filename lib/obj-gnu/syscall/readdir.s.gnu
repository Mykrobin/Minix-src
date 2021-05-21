/ Translated from ack to gnu by asmconv 1.12
# 1 "readdir.s"
.text
.globl	__readdir
.globl	_readdir
.balign	2

_readdir:
	jmp	__readdir
