/ Translated from ack to gnu by asmconv 1.12
# 3 "cv64u.s"
.text
.globl	_cv64u, _cv64ul

_cv64u:
_cv64ul:
	movl	4(%esp), %eax
	cmpl	$0, 8(%esp)
	je	0f
	movl	$-1, %eax
0:; ret
