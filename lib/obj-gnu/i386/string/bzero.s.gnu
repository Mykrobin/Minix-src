/ Translated from ack to gnu by asmconv 1.12
# 3 "bzero.s"
.text; .data; .data; .bss





.text
.globl	_bzero
.balign	16
_bzero:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	12(%ebp)
	pushl	$0
	pushl	8(%ebp)
	call	_memset
	leave
	ret
