/ Translated from ack to gnu by asmconv 1.12
# 3 "_strnlen.s"
.text; .data; .data; .bss




.text
.globl	__strnlen
.balign	16
__strnlen:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	movl	8(%ebp), %edi
	xorb	%al, %al
	movl	%ecx, %edx
	cmpb	$1, %cl
	cld

	repne; scasb
	jne	no0
	incl	%ecx
no0:; movl	%edx, %eax
	subl	%ecx, %eax
	popl	%edi
	popl	%ebp
	ret
