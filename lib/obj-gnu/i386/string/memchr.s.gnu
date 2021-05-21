/ Translated from ack to gnu by asmconv 1.12
# 3 "memchr.s"
.text; .data; .data; .bss




.text
.globl	_memchr
.balign	16
_memchr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	movl	8(%ebp), %edi
	movb	12(%ebp), %al
	movl	16(%ebp), %ecx
	cmpb	$1, %cl
	cld

	repne; scasb
	jne	failure
	leal	-1(%edi), %eax
	popl	%edi
	popl	%ebp
	ret
failure:; xorl	%eax, %eax
	popl	%edi
	popl	%ebp
	ret
