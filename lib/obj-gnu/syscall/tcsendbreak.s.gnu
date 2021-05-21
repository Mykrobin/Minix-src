/ Translated from ack to gnu by asmconv 1.12
# 1 "tcsendbreak.s"
.text
.globl	__tcsendbreak
.globl	_tcsendbreak
.balign	2

_tcsendbreak:
	jmp	__tcsendbreak
