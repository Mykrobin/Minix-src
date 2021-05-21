/ Translated from ack to gnu by asmconv 1.12
# 5 "io_outl.s"
.text
.globl	_outl
_outl:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	8+4(%ebp), %eax
	outl	%ax, %dx
	popl	%ebp
	ret
