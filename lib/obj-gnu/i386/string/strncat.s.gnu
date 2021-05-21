/ Translated from ack to gnu by asmconv 1.12
# 3 "strncat.s"
.text; .data; .data; .bss




.text
.globl	_strncat
.balign	16
_strncat:
	movl	12(%esp), %edx
	jmp	__strncat
