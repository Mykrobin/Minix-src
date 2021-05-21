/ Translated from ack to gnu by asmconv 1.12
# 4 "getprocessor.s"
.text; .data; .data; .bss
.text




.globl	_getprocessor

_getprocessor:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$0xFFFFFFFC, %esp
	movl	$0x00040000, %ecx
	call	flip
	movl	$386, %eax
	je	gotprocessor
	movl	$0x00200000, %ecx
	call	flip
	movl	$486, %eax
	je	gotprocessor
	pushfl
	pushal
	movl	$1, %eax
.byte	0x0F, 0xA2
	andb	$0x0F, %ah
	movzbl	%ah, %eax
	cmpl	$15, %eax
	jne	direct
	movl	$6, %eax
direct:
	imull	$100, %eax
	addl	$86, %eax
	movl	%eax, 7*4(%esp)
	popal
	popfl
gotprocessor:
	leave
	ret

flip:
	pushfl
	popl	%eax
	movl	%eax, %edx
	xorl	%ecx, %eax
	pushl	%eax
	popfl
	pushfl
	popl	%eax
	pushl	%edx
	popfl
	xorl	%edx, %eax
	testl	%ecx, %eax
	ret
