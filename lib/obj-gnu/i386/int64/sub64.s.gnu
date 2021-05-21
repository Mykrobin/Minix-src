/ Translated from ack to gnu by asmconv 1.12
# 3 "sub64.s"
.text
.globl	_sub64

_sub64:
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	subl	16(%esp), %edx
	movl	%edx, (%eax)
	movl	12(%esp), %edx
	sbbl	20(%esp), %edx
	movl	%edx, 4(%eax)
	ret
