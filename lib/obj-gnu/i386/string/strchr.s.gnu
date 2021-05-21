/ Translated from ack to gnu by asmconv 1.12
# 3 "strchr.s"
.text; .data; .data; .bss




.text
.globl	_strchr
.balign	16
_strchr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	cld
	movl	8(%ebp), %edi
	movl	$16, %edx
next:; shll	$1, %edx
	movl	%edx, %ecx
	xorb	%al, %al

	repne; scasb
	pushfl
	subl	%edx, %ecx
	negl	%ecx
	subl	%ecx, %edi
	movb	12(%ebp), %al

	repne; scasb
	je	found
	popfl
	jne	next
	xorl	%eax, %eax
	popl	%edi
	popl	%ebp
	ret
found:; popl	%eax
	leal	-1(%edi), %eax
	popl	%edi
	popl	%ebp
	ret
