/ Translated from ack to gnu by asmconv 1.12
# 3 "strnlen.s"
.text; .data; .data; .bss




.text
.globl	_strnlen
.balign	16
_strnlen:
	movl	8(%esp), %ecx
	jmp	__strnlen
