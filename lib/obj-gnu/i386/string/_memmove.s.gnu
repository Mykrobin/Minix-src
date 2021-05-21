/ Translated from ack to gnu by asmconv 1.12
# 3 "_memmove.s"
.text; .data; .data; .bss




.text
.globl	__memmove, __memcpy
.balign	16
__memmove:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movl	8(%ebp), %edi
	movl	12(%ebp), %esi
	movl	16(%ebp), %ecx
	movl	%edi, %eax
	subl	%esi, %eax
	cmpl	%ecx, %eax
	jb	downwards
__memcpy:
	cld
	cmpl	$16, %ecx
	jb	upbyte
	movl	%esi, %eax
	orl	%edi, %eax
	testb	$1, %al
	jne	upbyte
	testb	$2, %al
	jne	upword
uplword:; shrdl	$2, %ecx, %eax
	shrl	$2, %ecx

	rep; movsl
	shldl	$2, %eax, %ecx
upword:; shrl	$1, %ecx

	rep; movsw
	adcl	%ecx, %ecx
upbyte:
	rep; movsb
done:; movl	8(%ebp), %eax
	popl	%edi
	popl	%esi
	popl	%ebp
	ret


downwards:
	std
	leal	-1(%esi,%ecx,1), %esi
	leal	-1(%edi,%ecx,1), %edi

	rep; movsb
	cld
	jmp	done
