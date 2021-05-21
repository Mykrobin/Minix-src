/ Translated from ack to gnu by asmconv 1.12
# 1 "rewinddir.s"
.text
.globl	__rewinddir
.globl	_rewinddir
.balign	2

_rewinddir:
	jmp	__rewinddir
