/ Translated from ack to gnu by asmconv 1.12
# 4 "mul64u.s"
.text
.globl	_mul64u

_mul64u:
	movl	4(%esp), %ecx
	movl	8(%esp), %eax
	mull	12(%esp)
	movl	%eax, (%ecx)
	movl	%edx, 4(%ecx)
	movl	%ecx, %eax
	ret
