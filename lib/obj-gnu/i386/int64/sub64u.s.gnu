/ Translated from ack to gnu by asmconv 1.12
# 3 "sub64u.s"
.text
.globl	_sub64u, _sub64ul

_sub64u:
_sub64ul:
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	subl	16(%esp), %edx
	movl	%edx, (%eax)
	movl	12(%esp), %edx
	sbbl	$0, %edx
	movl	%edx, 4(%eax)
	ret
