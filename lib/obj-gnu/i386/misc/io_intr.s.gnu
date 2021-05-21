/ Translated from ack to gnu by asmconv 1.12
# 7 "io_intr.s"
.text
.globl	_intr_disable
_intr_disable:
	cli
	ret

.globl	_intr_enable
_intr_enable:
	sti
	ret
