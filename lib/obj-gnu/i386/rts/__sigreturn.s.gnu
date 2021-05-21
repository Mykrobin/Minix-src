/ Translated from ack to gnu by asmconv 1.12
# 4 "__sigreturn.s"
.text; .data; .data; .bss
.text
.globl	___sigreturn
.globl	__sigreturn
___sigreturn:
	addl	$16, %esp
	jmp	__sigreturn
