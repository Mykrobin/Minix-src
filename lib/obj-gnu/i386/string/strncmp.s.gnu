/ Translated from ack to gnu by asmconv 1.12
# 3 "strncmp.s"
.text; .data; .data; .bss




.text
.globl	_strncmp
.balign	16
_strncmp:
	movl	12(%esp), %ecx
	jmp	__strncmp
