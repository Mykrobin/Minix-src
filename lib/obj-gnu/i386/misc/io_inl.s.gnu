/ Translated from ack to gnu by asmconv 1.12
# 5 "io_inl.s"
.text
.globl	_inl
_inl:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	inl	%dx, %ax
	popl	%ebp
	ret
