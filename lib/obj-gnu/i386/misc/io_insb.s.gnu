/ Translated from ack to gnu by asmconv 1.12
# 5 "io_insb.s"
.text
.globl	_insb
_insb:
	pushl	%ebp
	movl	%esp, %ebp
	cld
	pushl	%edi
	movl	8(%ebp), %edx
	movl	12(%ebp), %edi
	movl	16(%ebp), %ecx
	rep; insb
	popl	%edi
	popl	%ebp
	ret
