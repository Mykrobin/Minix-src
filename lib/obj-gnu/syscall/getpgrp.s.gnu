/ Translated from ack to gnu by asmconv 1.12
# 1 "getpgrp.s"
.text
.globl	__getpgrp
.globl	_getpgrp
.balign	2

_getpgrp:
	jmp	__getpgrp
