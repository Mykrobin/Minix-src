/ Translated from ack to gnu by asmconv 1.12
# 5 "io_outsb.s"
.text
.globl	_outsb
_outsb:
	pushl	%ebp
	movl	%esp, %ebp
	cld
	pushl	%esi
	movl	8(%ebp), %edx
	movl	12(%ebp), %esi
	movl	16(%ebp), %ecx
	rep; outsb
	popl	%esi
	popl	%ebp
	ret
