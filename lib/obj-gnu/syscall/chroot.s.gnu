/ Translated from ack to gnu by asmconv 1.12
# 1 "chroot.s"
.text
.globl	__chroot
.globl	_chroot
.balign	2

_chroot:
	jmp	__chroot
