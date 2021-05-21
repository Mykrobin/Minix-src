/ Translated from ack to gnu by asmconv 1.12
# 1 "pause.s"
.text
.globl	__pause
.globl	_pause
.balign	2

_pause:
	jmp	__pause
