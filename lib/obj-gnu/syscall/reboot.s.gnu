/ Translated from ack to gnu by asmconv 1.12
# 1 "reboot.s"
.text
.globl	__reboot
.globl	_reboot
.balign	2

_reboot:
	jmp	__reboot
