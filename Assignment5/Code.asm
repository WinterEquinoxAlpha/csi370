; Assignemt 5, Alternative 2 MASM 64-bit

extrn ExitProcess : proc			; forward declare the exit function

.DATA								; section header to define variables
pin WORD 1, 2, 3, 4
ranges WORD 3, 6, 1, 4, 7, 9, 2, 5
valid BYTE 0

.CODE								; section header to write code

_main PROC							; define _main function

mov rcx, 4
loopBegin:
	lea rax, pin
	lea rbx, ranges
	dec rcx
	movzx rax, WORD PTR [rax + rcx * 2]
	movzx rdx, WORD PTR [rbx + rcx * 4]
	movzx rbx, WORD PTR [rbx + rcx * 4 + 2]
	inc rcx

	cmp rax, rdx
	jnge endLoop

	cmp rax, rbx
	jnle endLoop
loop loopBegin

endLoop:

xor rcx, rcx						; clear return register (return 0)
call ExitProcess					; call the exit process function (defined by Windows and declared earlier

_main ENDP							; end of the _main function

END									; end the script