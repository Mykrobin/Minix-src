/ Translated from ack to gnu by asmconv 1.12
# 3 "add64.s"
.text
.globl	_add64

_add64:
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	addl	16(%esp), %edx
	movl	%edx, (%eax)
	movl	12(%esp), %edx
	adcl	20(%esp), %edx
	movl	%edx, 4(%eax)
	ret
