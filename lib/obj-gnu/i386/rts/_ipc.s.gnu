/ Translated from ack to gnu by asmconv 1.12
# 1 "_ipc.s"
.text; .data; .data; .bss
.globl	__echo, __notify, __send, __receive, __sendrec


	SEND = 1
	RECEIVE = 2
	SENDREC = 3
	NOTIFY = 4
	ECHO = 8
	SYSVEC = 33

	SRC_DST = 8
	ECHO_MESS = 8
	MESSAGE = 12





.globl	__echo, __notify, __send, __receive, __sendrec
.text
__send:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	MESSAGE(%ebp), %ebx
	movl	$SEND, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__receive:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	MESSAGE(%ebp), %ebx
	movl	$RECEIVE, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__sendrec:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	MESSAGE(%ebp), %ebx
	movl	$SENDREC, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__notify:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	$NOTIFY, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__echo:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	ECHO_MESS(%ebp), %ebx
	movl	$ECHO, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret
