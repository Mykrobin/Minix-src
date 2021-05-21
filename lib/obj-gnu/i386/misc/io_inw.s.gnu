/ Translated from ack to gnu by asmconv 1.12
# 5 "io_inw.s"
.text
.globl	_inw
_inw:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	xorl	%eax, %eax
	inw	%dx, %ax
	popl	%ebp
	ret
