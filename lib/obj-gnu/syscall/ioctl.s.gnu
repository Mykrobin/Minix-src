/ Translated from ack to gnu by asmconv 1.12
# 1 "ioctl.s"
.text
.globl	__ioctl
.globl	_ioctl
.balign	2

_ioctl:
	jmp	__ioctl
