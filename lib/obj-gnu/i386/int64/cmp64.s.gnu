/ Translated from ack to gnu by asmconv 1.12
# 3 "cmp64.s"
.text
.globl	_cmp64, _cmp64u, _cmp64ul

_cmp64:
	movl	%esp, %ecx
cmp64:; xorl	%eax, %eax
	movl	4(%ecx), %edx
	subl	12(%ecx), %edx
	movl	8(%ecx), %edx
	sbbl	16(%ecx), %edx
	sbbl	%eax, %eax
	movl	12(%ecx), %edx
	subl	4(%ecx), %edx
	movl	16(%ecx), %edx
	sbbl	8(%ecx), %edx
	adcl	$0, %eax
	ret

_cmp64u:
_cmp64ul:
	movl	%esp, %ecx
	pushl	16(%ecx)
	movl	$0, 16(%ecx)
	call	cmp64
	popl	16(%ecx)
	ret
