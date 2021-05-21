/ Translated from ack to gnu by asmconv 1.12
# 7 "get_bp.s"
.text; .data; .data; .bss

.text
.globl	_get_bp
_get_bp:
	movl	%ebp, %eax
	ret
