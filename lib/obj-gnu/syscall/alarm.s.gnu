/ Translated from ack to gnu by asmconv 1.12
# 1 "alarm.s"
.text
.globl	__alarm
.globl	_alarm
.balign	2

_alarm:
	jmp	__alarm
