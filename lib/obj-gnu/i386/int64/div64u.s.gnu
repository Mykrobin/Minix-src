/ Translated from ack to gnu by asmconv 1.12
# 4 "div64u.s"
.text
.globl	_div64u, _rem64u

_div64u:
	xorl	%edx, %edx
	movl	8(%esp), %eax
	divl	12(%esp)
	movl	4(%esp), %eax
	divl	12(%esp)
	ret

_rem64u:
	popl	%ecx
	call	_div64u
	movl	%edx, %eax
	jmp	*%ecx
