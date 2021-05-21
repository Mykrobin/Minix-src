/ Translated from ack to gnu by asmconv 1.12
# 3 "memcmp.s"
.text; .data; .data; .bss




.text
.globl	_memcmp
.balign	16
_memcmp:
	cld
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movl	8(%ebp), %esi
	movl	12(%ebp), %edi
	movl	16(%ebp), %ecx
	cmpl	$16, %ecx
	jb	cbyte
	movl	%esi, %eax
	orl	%edi, %eax
	testb	$1, %al
	jne	cbyte
	testb	$2, %al
	jne	cword
clword:; shrdl	$2, %ecx, %eax
	shrl	$2, %ecx

	repe; cmpsl
	subl	$4, %esi
	subl	$4, %edi
	incl	%ecx
	shldl	$2, %eax, %ecx
	jmp	last
cword:; shrdl	$1, %ecx, %eax
	shrl	$1, %ecx

	repe; cmpsw
	subl	$2, %esi
	subl	$2, %edi
	incl	%ecx
	shldl	$1, %eax, %ecx
cbyte:; testl	%ecx, %ecx
last:
	repe; cmpsb
	setab	%al
	setbb	%ah
	subb	%ah, %al
	movsbl	%al, %eax
	movl	%esi, %edx
	popl	%edi
	popl	%esi
	popl	%ebp
	ret
