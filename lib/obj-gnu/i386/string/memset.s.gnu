/ Translated from ack to gnu by asmconv 1.12
# 3 "memset.s"
.text; .data; .data; .bss




.text
.globl	_memset
.balign	16
_memset:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	movl	8(%ebp), %edi
	movzbl	12(%ebp), %eax
	movl	16(%ebp), %ecx
	cld
	cmpl	$16, %ecx
	jb	sbyte
	testl	$1, %edi
	jne	sbyte
	testl	$2, %edi
	jne	sword
slword:; movb	%al, %ah
	movl	%eax, %edx
	sall	$16, %edx
	orl	%edx, %eax
	shrdl	$2, %ecx, %edx
	shrl	$2, %ecx

	rep; stosl
	shldl	$2, %edx, %ecx
sword:; movb	%al, %ah
	shrl	$1, %ecx

	rep; stosw
	adcl	%ecx, %ecx
sbyte:
	rep; stosb
done:; movl	8(%ebp), %eax
	popl	%edi
	popl	%ebp
	ret
