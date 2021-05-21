/ Translated from ack to gnu by asmconv 1.12
# 3 "bcmp.s"
.text; .data; .data; .bss







.text
.globl	_bcmp
.balign	16
_bcmp:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	16(%ebp)
	pushl	12(%ebp)
	pushl	8(%ebp)
	call	_memcmp
	testl	%eax, %eax
	je	equal
	subl	8(%ebp), %edx
	decl	%edx
	movl	16(%ebp), %eax
	subl	%edx, %eax
equal:; leave
	ret
