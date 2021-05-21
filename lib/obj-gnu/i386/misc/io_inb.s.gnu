/ Translated from ack to gnu by asmconv 1.12
# 5 "io_inb.s"
.text
.globl	_inb
_inb:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	xorl	%eax, %eax
	inb	%dx, %al
	popl	%ebp
	ret
