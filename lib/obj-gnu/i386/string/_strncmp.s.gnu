/ Translated from ack to gnu by asmconv 1.12
# 3 "_strncmp.s"
.text; .data; .data; .bss




.text
.globl	__strncmp
.balign	16
__strncmp:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%edi
	testl	%ecx, %ecx
	je	done
	movl	8(%ebp), %esi
	movl	12(%ebp), %edi
	cld
compare:
	cmpsb
	jne	done
	cmpb	$0, -1(%esi)
	je	done
	decl	%ecx
	jne	compare
done:; setab	%al
	setbb	%ah
	subb	%ah, %al
	movsbl	%al, %eax
	popl	%edi
	popl	%esi
	popl	%ebp
	ret
