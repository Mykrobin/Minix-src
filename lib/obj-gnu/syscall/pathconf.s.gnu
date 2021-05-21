/ Translated from ack to gnu by asmconv 1.12
# 1 "pathconf.s"
.text
.globl	__pathconf
.globl	_pathconf
.balign	2

_pathconf:
	jmp	__pathconf
