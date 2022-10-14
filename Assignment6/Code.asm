; code.asm

getInput PROTO
dispOutput PROTO

.CODE

asmMain PROC
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; call the getInput function in C++. the result passed into rax is a pointer to the beginning of an array that contains the user inputs
	call getInput

	; retieve the values returned by getInput
	mov ebx, [rax]
	mov ecx, [rax + 4]

	; add the two numbers
	add ecx, ebx
	
	; call the dispOutput in C++ to display the value in rcx
	call dispOutput

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret
asmMain ENDP

END