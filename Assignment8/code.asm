; code.asm

_getDouble PROTO
_printString PROTO
_printDouble PROTO

.DATA
radius REAL8 ?
height REAL8 ?
answer REAL8 ?
radiusPrompt BYTE "Radius: ", 0
heightPrompt BYTE "Height: ", 0
answerString BYTE "Answer: ", 0

.CODE

_asmMain PROC
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; initialize the FPU
	finit

	; prompt the user for radius and store it in the appropriate variable
	lea rcx, radiusPrompt
	call _printString
	call _getDouble
	movsd radius, xmm0
	
	; prompt the user for height and store it in the appropriate variable
	lea rcx, heightPrompt
	call _printString
	call _getDouble
	movsd height, xmm0

	; load the necessary values into the FPU stack
	fldpi
	fld height
	fld radius
	
	; perform the multiplications to get V=pi*r^2*h
	fmul ST(0), ST(0)
	fmul ST(0), ST(1)
	fmul ST(0), ST(2)

	; store the answer in the appropriate variable
	fstp answer

	; move the answer to the appropriate coprocessor register to be used as a paramater for the function call
	lea rcx, answerString
	call _printString
	movsd xmm0, answer
	call _printDouble

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret
_asmMain ENDP

END