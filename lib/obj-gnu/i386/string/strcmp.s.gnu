/ Translated from ack to gnu by asmconv 1.12
# 3 "strcmp.s"
.text; .data; .data; .bss




.text
.globl	_strcmp
.balign	16
_strcmp:
	movl	$-1, %ecx
	jmp	__strncmp
