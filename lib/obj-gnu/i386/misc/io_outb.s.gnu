/ Translated from ack to gnu by asmconv 1.12
# 5 "io_outb.s"
.text
.globl	_outb
_outb:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	8+4(%ebp), %eax
	outb	%al, %dx
	popl	%ebp
	ret
