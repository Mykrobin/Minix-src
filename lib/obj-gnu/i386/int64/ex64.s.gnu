/ Translated from ack to gnu by asmconv 1.12
# 4 "ex64.s"
.text
.globl	_ex64lo, _ex64hi

_ex64lo:
	movl	4(%esp), %eax
	ret

_ex64hi:
	movl	8(%esp), %eax
	ret
