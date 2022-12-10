getInput PROTO
printBoard PROTO
printString PROTO

asmPrintBoard PROTO
asmUpdateBoard PROTO
asmCheckLine PROTO lineNumber:QWORD, character:BYTE

.data
boardValues BYTE "    X X  ", 0
board BYTE  "   |   |  ", 13, 10, "---+---+---", 13, 10, "   |   |  ", 13, 10, "---+---+---", 13, 10, "   |   |  ", 13, 10, 13, 10, 0
boardIndices QWORD 1, 5, 9, 26, 30, 34, 51, 55, 59

playerMove QWORD ?
specificValue BYTE ?

inputPrompt BYTE "Enter Move (0-8): ", 0

.code
asmMain PROC
	
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	call asmUpdateBoard
	call asmPrintBoard

	newMove:
	; Get the player input
	call getInput
	mov playerMove, rax
	
	; Check if the board value at the point 
	lea rsi, boardValues
	mov rdx, playerMove
	cmp BYTE PTR [rsi + rdx], 32
	jne newMove

	lea rdi, boardValues
	add rdi, playerMove
	mov BYTE PTR [rdi], 88

	call asmUpdateBoard
	call asmPrintBoard

	push 88
	push 7
	call asmCheckLine

	call asmUpdateBoard
	call asmPrintBoard

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret

asmMain ENDP



asmPrintBoard PROC
	
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Print the board
	lea rcx, board
	call printBoard

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret

asmPrintBoard ENDP



asmUpdateBoard PROC
	
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Run a loop through the positions in the board and fill them in with the appropriate values
	mov rcx, 9
	lea rax, boardIndices			; The indices in the board we need to change
	updateLoop:
		dec rcx						; Decrease rcx for indexing purposes
		lea rsi, boardValues		; Load the address of the first board value into the source index
		add rsi, rcx				; Increment that address until the correct value is reached
		lea rdi, board				; Load the address of the first board element into the destination index
		add rdi, [rax + 8 * rcx]	; Increment that address until the correct spot on the board is reached
		movsb						; Copy the byte from the values array to the display board array
		inc rcx						; Return rcx to the correct value
	loop updateLoop

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret

asmUpdateBoard ENDP



asmCheckLine PROC lineNumber:QWORD, character:BYTE

	lea rsi, boardValues

	cmp lineNumber, 3
	jl verticalLine

	cmp lineNumber, 6
	jl horizontalLine

	jmp diagonalLine
	
	verticalLine:
	mov rcx, 3
	movzx rbx, character
	verCmpStart:
		mov rax, rcx
		dec rax
		mov rdx, 3
		mul rdx
		add rax, lineNumber
		movzx rdx, BYTE PTR [rsi + rax]
		cmp rbx, rdx
		jne checkLineEnd
	loop verCmpStart
	jmp checkLineEnd

	horizontalLine:
	mov rcx, 3
	movzx rbx, character
	horCmpStart:
		mov rax, lineNumber
		sub rax, 3
		mov rdx, 3
		mul rdx
		add rax, rcx
		dec rax
		movzx rdx, BYTE PTR [rsi + rax]
		cmp rbx, rdx
		jne checkLineEnd
	loop horCmpStart
	jmp checkLineEnd

	diagonalLine:
	mov rcx, 3
	diaCmpStart:
		; 4a+4c-(2ac+4)

		; 4c
		mov rdx, 4
		mov rax, rcx
		mul rdx
		mov rbx, rax

		; 4a
		mov rax, lineNumber
		sub rax, 6
		mov rdx, 4
		mul rdx
		
		; 4a+4c
		add rbx, rax

		; 2ac+4
		mov rax, lineNumber
		sub rax, 6
		mov rdx, rcx
		mul rdx
		mov rdx, 2
		mul rdx
		add rax, 4

		; 4a+4c-(2ac+4)
		mov rdx, rax
		mov rax, rbx
		sub rax, rdx

		movzx rbx, character

		movzx rdx, BYTE PTR [rsi + rax]
		cmp rbx, rdx
		jne checkLineEnd
	loop diaCmpStart
	jmp checkLineEnd

	checkLineEnd:
	ret

asmCheckLine ENDP

END