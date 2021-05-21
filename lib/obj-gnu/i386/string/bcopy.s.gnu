/ Translated from ack to gnu by asmconv 1.12
# 3 "bcopy.s"
.text; .data; .data; .bss





.text
.globl	_bcopy
.balign	16
_bcopy:
	movl	4(%esp), %eax
	xchgl	8(%esp), %eax
	movl	%eax, 4(%esp)
	jmp	__memmove
