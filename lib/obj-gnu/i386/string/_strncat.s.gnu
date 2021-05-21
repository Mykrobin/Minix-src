/ Translated from ack to gnu by asmconv 1.12
# 3 "_strncat.s"
.text; .data; .data; .bss




.text
.globl	__strncat
.balign	16
__strncat:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movl	8(%ebp), %edi
	movl	$-1, %ecx
	xorb	%al, %al
	cld

	repne; scasb
	decl	%edi
	pushl	%edi
	movl	12(%ebp), %edi
	movl	%edx, %ecx

	repne; scasb
	jne	no0
	incl	%ecx
no0:; subl	%ecx, %edx
	movl	%edx, %ecx
	movl	12(%ebp), %esi
	popl	%edi

	rep; movsb
	stosb
	movl	8(%ebp), %eax
	popl	%edi
	popl	%esi
	popl	%ebp
	ret
