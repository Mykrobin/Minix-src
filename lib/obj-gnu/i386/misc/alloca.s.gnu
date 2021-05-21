/ Translated from ack to gnu by asmconv 1.12
# 4 "alloca.s"
.text; .data; .data; .bss

.text
.balign	16
.globl	_alloca
_alloca:
# 25 "alloca.s"
	popl	%ecx
	popl	%eax
	addl	$3, %eax
	andb	$0xFC, %al
	subl	%eax, %esp
	movl	%esp, %eax
	pushl	%eax
	jmp	*%ecx
