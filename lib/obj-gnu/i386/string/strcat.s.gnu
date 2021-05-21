/ Translated from ack to gnu by asmconv 1.12
# 3 "strcat.s"
.text; .data; .data; .bss




.text
.globl	_strcat
.balign	16
_strcat:
	movl	$-1, %edx
	jmp	__strncat
