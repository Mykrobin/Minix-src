/ Translated from ack to gnu by asmconv 1.12
# 3 "_strncpy.s"
.text; .data; .data; .bss




.text
.globl	__strncpy
.balign	16
__strncpy:
	movl	12(%ebp), %edi
	xorb	%al, %al
	movl	%ecx, %edx
	cld

	repne; scasb
	subl	%ecx, %edx
	xchgl	%edx, %ecx
	movl	12(%ebp), %esi
	movl	8(%ebp), %edi

	rep; movsb
	ret
