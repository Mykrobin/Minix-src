/ Translated from ack to gnu by asmconv 1.12
# 6 "oneC_sum.s"
.text

.globl	_oneC_sum
.balign	16
_oneC_sum:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	movzwl	8(%ebp), %eax
	movl	12(%ebp), %esi
	movl	16(%ebp), %edi

	xorl	%edx, %edx
	xorb	%cl, %cl
align:; testl	$3, %esi
	je	aligned
	testl	%edi, %edi
	je	0f
	movb	(%esi), %dl
	decl	%edi
0:; incl	%esi
	rorl	$8, %edx
	rorl	$8, %eax
	addb	$8, %cl
	jmp	align
aligned:; addl	%edx, %eax
	adcl	$0, %eax

	jmp	add6test
.balign	16
add6:; addl	(%esi), %eax
	adcl	4(%esi), %eax
	adcl	8(%esi), %eax
	adcl	12(%esi), %eax
	adcl	16(%esi), %eax
	adcl	20(%esi), %eax
	adcl	$0, %eax
	addl	$24, %esi
add6test:
	subl	$24, %edi
	jae	add6
	addl	$24, %edi

	jmp	add1test
.balign	16
add1:; addl	(%esi), %eax
	adcl	$0, %eax
	addl	$4, %esi
add1test:
	subl	$4, %edi
	jae	add1
	addl	$4, %edi

	je	done
	movl	(%esi), %edx
	andl	mask-4(,%edi,4), %edx
	addl	%edx, %eax
	adcl	$0, %eax
done:; roll	%cl, %eax
	movl	%eax, %edx
	shrl	$16, %eax
	addw	%dx, %ax
	adcw	$0, %ax
	popl	%edi
	popl	%esi
	popl	%ebp
	ret

.data
.balign	4
mask:; .long	0x000000FF, 0x0000FFFF, 0x00FFFFFF
