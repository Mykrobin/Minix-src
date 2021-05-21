/ Translated from ack to gnu by asmconv 1.12
# 5 "io_insw.s"
.text
.globl	_insw
_insw:
	pushl	%ebp
	movl	%esp, %ebp
	cld
	pushl	%edi
	movl	8(%ebp), %edx
	movl	12(%ebp), %edi
	movl	16(%ebp), %ecx
	shrl	$1, %ecx
	rep; insw
	popl	%edi
	popl	%ebp
	ret
