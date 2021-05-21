/ Translated from ack to gnu by asmconv 1.12
# 3 "add64u.s"
.text
.globl	_add64u, _add64ul

_add64u:
_add64ul:
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	addl	16(%esp), %edx
	movl	%edx, (%eax)
	movl	12(%esp), %edx
	adcl	$0, %edx
	movl	%edx, 4(%eax)
	ret
