/ Translated from ack to gnu by asmconv 1.12
# 5 "io_outw.s"
.text
.globl	_outw
_outw:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	8+4(%ebp), %eax
	outw	%ax, %dx
	popl	%ebp
	ret
