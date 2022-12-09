getInput PROTO
printBoard PROTO
printString PROTO

asmPrintBoard PROTO
asmUpdateBoard PROTO

.data
boardValues BYTE "         ", 0
board BYTE  "   |   |  ", 13, 10, "---+---+---", 13, 10, "   |   |  ", 13, 10, "---+---+---", 13, 10, "   |   |  ", 13, 10, 13, 10, 0

playerMove QWORD ?

inputPrompt BYTE "Enter Move (0-8): ", 0

.code
asmMain PROC
	
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

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

	; mov rcx, 9
	; mov rsi, 88
	; lea rdi, board
	; cld
	; rep movsb
	; mov BYTE PTR [rsi + 1], 88
	; mov BYTE PTR [rsi + 5], 88
	; mov BYTE PTR [rsi + 9], 88
	; mov BYTE PTR [rsi + 26], 88
	; mov BYTE PTR [rsi + 30], 88
	; mov BYTE PTR [rsi + 34], 88
	; mov BYTE PTR [rsi + 51], 88
	; mov BYTE PTR [rsi + 55], 88
	; mov BYTE PTR [rsi + 59], 88

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret

asmUpdateBoard ENDP

END