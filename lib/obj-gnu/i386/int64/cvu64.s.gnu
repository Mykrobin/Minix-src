/ Translated from ack to gnu by asmconv 1.12
# 3 "cvu64.s"
.text
.globl	_cvu64, _cvul64

_cvu64:
_cvul64:
	movl	4(%esp), %eax
	movl	8(%esp), %edx
	movl	%edx, (%eax)
	movl	$0, 4(%eax)
	ret
