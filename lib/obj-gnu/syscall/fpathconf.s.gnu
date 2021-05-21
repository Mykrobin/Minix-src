/ Translated from ack to gnu by asmconv 1.12
# 1 "fpathconf.s"
.text
.globl	__fpathconf
.globl	_fpathconf
.balign	2

_fpathconf:
	jmp	__fpathconf
