/ Translated from ack to gnu by asmconv 1.12
# 3 "strlen.s"
.text; .data; .data; .bss




.text
.globl	_strlen
.balign	16
_strlen:
	movl	$-1, %ecx
	jmp	__strnlen
