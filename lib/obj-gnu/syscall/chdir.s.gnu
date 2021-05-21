/ Translated from ack to gnu by asmconv 1.12
# 1 "chdir.s"
.text
.globl	__chdir
.globl	_chdir
.globl	__fchdir
.globl	_fchdir
.balign	2

_chdir:
	jmp	__chdir
_fchdir:
	jmp	__fchdir
