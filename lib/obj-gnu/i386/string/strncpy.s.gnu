/ Translated from ack to gnu by asmconv 1.12
# 3 "strncpy.s"
.text; .data; .data; .bss




.text
.globl	_strncpy
.balign	16
_strncpy:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movl	16(%ebp), %ecx
	call	__strncpy
	movl	%edx, %ecx

	rep; stosb
	movl	8(%ebp), %eax
	popl	%edi
	popl	%esi
	popl	%ebp
	ret
