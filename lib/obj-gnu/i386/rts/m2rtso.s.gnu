/ Translated from ack to gnu by asmconv 1.12
# 5 "m2rtso.s"
.text; .data; .data; .bss

.globl	begtext, begdata, begbss
.text
begtext:
.data
begrom:
.data
begdata:
.bss
begbss:

.globl	m2rtso, hol0, __penviron, __penvp, __fpu_present
.text
m2rtso:
	xorl	%ebp, %ebp
	movl	(%esp), %eax
	leal	4(%esp), %edx
	leal	8(%esp,%eax,4), %ecx



	movl	$_environ, %ebx
	cmpl	$__edata, %ebx
	jae	0f
	testb	$3, %bl
	jne	0f
	cmpl	$0x53535353, (%ebx)
	jne	0f
	movl	%ebx, __penviron
0:; movl	__penviron, %ebx
	movl	%ecx, (%ebx)

	pushl	%ecx
	pushl	%edx
	pushl	%eax



	smsw	%ax
	testb	$0x4, %al
	seteb	__fpu_present

	call	__m_a_i_n

	pushl	%eax
	call	__exit

	hlt

.data
.long	0


.data
__penviron:
.long	__penvp

.bss
.lcomm	__penvp, 4
.lcomm	__fpu_present, 4

.globl	endtext
