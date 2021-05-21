/ Translated from ack to gnu by asmconv 1.12
# 1 "ptrace.s"
.text
.globl	__ptrace
.globl	_ptrace
.balign	2

_ptrace:
	jmp	__ptrace
