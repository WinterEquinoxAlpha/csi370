; code.asm

_getDouble PROTO
_printString PROTO
_printDouble PROTO

.CODE

_asmMain PROC
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	call _getDouble;
	mov mm0, [rcx]

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret
_asmMain ENDP

END