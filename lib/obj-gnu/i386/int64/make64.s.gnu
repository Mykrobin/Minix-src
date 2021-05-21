/ Translated from ack to gnu by asmconv 1.12
# 4 "make64.s"
.text
.globl	_make64

_make64:
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	movl	%edx, (%eax)
	movl	12(%esp), %edx
	movl	%edx, 4(%eax)
	ret
