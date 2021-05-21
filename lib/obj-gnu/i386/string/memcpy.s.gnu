/ Translated from ack to gnu by asmconv 1.12
# 3 "memcpy.s"
.text; .data; .data; .bss








.text
.globl	_memcpy
.balign	16
_memcpy:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movl	8(%ebp), %edi
	movl	12(%ebp), %esi
	movl	16(%ebp), %ecx

	jmp	__memcpy
