/ Translated from ack to gnu by asmconv 1.12
# 3 "strrchr.s"
.text; .data; .data; .bss




.text
.globl	_strrchr
.balign	16
_strrchr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	movl	8(%ebp), %edi
	movl	$-1, %ecx
	xorb	%al, %al
	cld

	repne; scasb
	notl	%ecx
	decl	%edi
	movb	12(%ebp), %al
	std

	repne; scasb
	cld
	jne	failure
	leal	1(%edi), %eax
	popl	%edi
	popl	%ebp
	ret
failure:; xorl	%eax, %eax
	popl	%edi
	popl	%ebp
	ret
