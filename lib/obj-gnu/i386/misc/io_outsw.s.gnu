/ Translated from ack to gnu by asmconv 1.12
# 5 "io_outsw.s"
.text
.globl	_outsw
_outsw:
	pushl	%ebp
	movl	%esp, %ebp
	cld
	pushl	%esi
	movl	8(%ebp), %edx
	movl	12(%ebp), %esi
	movl	16(%ebp), %ecx
	shrl	$1, %ecx
	rep; outsw
	popl	%esi
	popl	%ebp
	ret
