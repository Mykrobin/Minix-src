/ Translated from ack to gnu by asmconv 1.12
# 1 "_ipcnew.s"
.text; .data; .data; .bss
.globl	__ipc_request, __ipc_reply, __ipc_notify, __ipc_receive


	IPC_REQUEST = 16
	IPC_REPLY = 32
	IPC_NOTIFY = 64
	IPC_RECEIVE = 128

	SYSVEC = 33


	SRC_DST = 8
	SEND_MSG = 12
	EVENT_SET = 12
	RECV_MSG = 16






.globl	__ipc_request, __ipc_reply, __ipc_notify, __ipc_receive
.text

__ipc_request:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	SEND_MSG(%ebp), %ebx
	movl	$IPC_REQUEST, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__ipc_reply:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	SEND_MSG(%ebp), %ebx
	movl	$IPC_REPLY, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__ipc_receive:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	EVENT_SET(%ebp), %edx
	movl	RCV_MSG(%ebp), %ebx
	movl	$IPC_RECEIVE, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret

__ipc_notify:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	SRC_DST(%ebp), %eax
	movl	EVENT_SET(%ebp), %edx
	movl	$IPC_NOTIFY, %ecx
	int	$SYSVEC
	popl	%ebx
	popl	%ebp
	ret
