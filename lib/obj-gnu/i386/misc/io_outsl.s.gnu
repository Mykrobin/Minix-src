/ Translated from ack to gnu by asmconv 1.12
# 5 "io_outsl.s"
.text
.globl	_outsl
_outsl:
	pushl	%ebp
	movl	%esp, %ebp
	cld
	pushl	%esi
	movl	8(%ebp), %edx
	movl	12(%ebp), %esi
	movl	16(%ebp), %ecx
	shrl	$2, %ecx
	rep; outsl
	popl	%esi
	popl	%ebp
	ret
