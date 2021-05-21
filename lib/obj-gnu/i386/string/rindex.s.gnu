/ Translated from ack to gnu by asmconv 1.12
# 3 "rindex.s"
.text; .data; .data; .bss





.text
.globl	_rindex
.balign	16
_rindex:
	jmp	_strrchr
