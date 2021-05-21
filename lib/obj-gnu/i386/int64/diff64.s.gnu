/ Translated from ack to gnu by asmconv 1.12
# 3 "diff64.s"
.text
.globl	_diff64

_diff64:
	movl	4(%esp), %eax
	subl	12(%esp), %eax
	ret
