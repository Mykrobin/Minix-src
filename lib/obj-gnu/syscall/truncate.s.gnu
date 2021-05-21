/ Translated from ack to gnu by asmconv 1.12
# 1 "truncate.s"
.text
.globl	__truncate
.globl	__ftruncate
.globl	_truncate
.globl	_ftruncate
.balign	2

_truncate:
	jmp	__truncate

.balign	2
_ftruncate:
	jmp	__ftruncate
