/ Translated from ack to gnu by asmconv 1.12
# 1 "uname.s"
.text
.globl	__uname
.globl	_uname
.balign	2

_uname:
	jmp	__uname
