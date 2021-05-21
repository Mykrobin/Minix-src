/ Translated from ack to gnu by asmconv 1.12
# 3 "strcpy.s"
.text; .data; .data; .bss




.text
.globl	_strcpy
.balign	16
_strcpy:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movl	$-1, %ecx
	call	__strncpy
	movl	8(%ebp), %eax
	popl	%edi
	popl	%esi
	popl	%ebp
	ret
