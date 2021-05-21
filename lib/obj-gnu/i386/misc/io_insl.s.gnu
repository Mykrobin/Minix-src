/ Translated from ack to gnu by asmconv 1.12
# 5 "io_insl.s"
.text
.globl	_insl
_insl:
	pushl	%ebp
	movl	%esp, %ebp
	cld
	pushl	%edi
	movl	8(%ebp), %edx
	movl	12(%ebp), %edi
	movl	16(%ebp), %ecx
	shrl	$2, %ecx
	rep; insl
	popl	%edi
	popl	%ebp
	ret
