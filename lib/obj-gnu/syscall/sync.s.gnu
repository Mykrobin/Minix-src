/ Translated from ack to gnu by asmconv 1.12
# 1 "sync.s"
.text
.globl	__sync
.globl	_sync
.balign	2

_sync:
	jmp	__sync
