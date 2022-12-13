getInput PROTO
printString PROTO
queryAI PROTO

asmPrintBoard PROTO
asmUpdateBoard PROTO
asmUpdateTutorialBoard PROTO
asmCheckLine PROTO
asmCheckGameOver PROTO
asmMinimax PROTO
asmFindBestMove PROTO

.data
boardValues BYTE "          ", 0
board BYTE  "   |   |  ", 13, 10, "---+---+---", 13, 10, "   |   |  ", 13, 10, "---+---+---", 13, 10, "   |   |  ", 13, 10, 13, 10, 0
boardTutorial BYTE  " 0 | 1 | 2", 13, 10, "---+---+---", 13, 10, " 3 | 4 | 5", 13, 10, "---+---+---", 13, 10, " 6 | 7 | 8", 13, 10, 13, 10, 0
boardIndices QWORD 1, 5, 9, 26, 30, 34, 51, 55, 59
xWinsMessage BYTE "X Wins", 13, 10, 0
oWinsMessage BYTE "O Wins", 13, 10, 0
drawMessage BYTE "Draw", 13, 10, 0
moveTakenMessage BYTE "Position taken", 13, 10, 13, 10, 0
outOfRangeMessage BYTE "Move out of range 0-8", 13, 10, 13, 10, 0
invalidAIInputMessage BYTE "Please input 0 or 1", 13, 10, 0

playerMove QWORD ?
specificValue BYTE ?
lineNumber QWORD ?
character BYTE ?
gameOver BYTE 0
xTurn BYTE 1
bestMove QWORD ?
bestMoveScore QWORD -10
moveEval QWORD ?
maximizer BYTE ?
;bestValueSoFar QWORD ?

noAI QWORD 0

inputPrompt BYTE "Enter Move (0-8): ", 0

.code
asmMain PROC
	
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Ask the player if they want to use AI
	invalidAIInput:
	call queryAI
	mov noAI, rax
	cmp noAI, 0
	je turnOffAI
	jl invalidAIInput
	cmp noAI, 1
	je turnOnAI
	jg invalidAIInput

	turnOffAI:
	mov noAI, 1
	jmp gameBeginLoop
	turnOnAI:
	mov noAI, 0
	jmp gameBeginLoop

	; -------- Main Game Loop --------
	gameBeginLoop:

	newMove:
	; Check whose turn it is
	movzx rax, xTurn
	or rax, noAI
	cmp rax, 0
	je oAITurnLabel

	; Display the boards
	call asmUpdateTutorialBoard
	lea rcx, boardTutorial
	call printString

	call asmUpdateBoard
	call asmPrintBoard

	; Get the player input
	call getInput
	mov playerMove, rax

	cmp playerMove, 0
	jl outOfRangeLabel
	cmp playerMove, 8
	jg outOfRangeLabel

	; Check if the board value at the point is valid
	lea rsi, boardValues
	mov rdx, playerMove
	cmp BYTE PTR [rsi + rdx], 32
	jne moveTakenLabel

	jmp moveGoodLabel

	outOfRangeLabel:
	lea rcx, outOfRangeMessage
	call printString
	jmp newMove

	moveTakenLabel:
	lea rcx, moveTakenMessage
	call printString
	jmp newMove

	moveGoodLabel:
	cmp xTurn, 0
	je oTurnLabel

	xTurnLabel:
	; Run the turn operations
	mov xTurn, 0
	lea rdi, boardValues
	add rdi, playerMove
	mov BYTE PTR [rdi], 88

	; Check if the game is over
	mov character, 88
	call asmCheckGameOver
	cmp gameOver, 0
	je gameBeginLoop
	jmp mainGameOver

	oTurnLabel:
	; Run the turn operations
	mov xTurn, 1
	lea rdi, boardValues
	add rdi, playerMove
	mov BYTE PTR [rdi], 79

	; Check if the game is over
	mov character, 79
	call asmCheckGameOver
	cmp gameOver, 0
	je gameBeginLoop
	jmp mainGameOver



	oAITurnLabel:
	; Run the turn operations
	mov xTurn, 1

	; Find the best move and take that
	mov character, 79
	call asmFindBestMove
	lea rdi, boardValues
	add rdi, bestMove
	mov BYTE PTR [rdi], 79

	; Reset the related variable for the minimax
	mov bestMoveScore, -10

	; Check if the game is over
	mov character, 79
	call asmCheckGameOver
	cmp gameOver, 0
	je gameBeginLoop
	jmp mainGameOver


	mainGameOver:
	; If the game is over update and print the board
	call asmUpdateBoard
	call asmPrintBoard

	; and display the appropriate message
	cmp gameOver, 1
	je xWinsLabel
	cmp gameOver, 2
	je oWinsLabel

	lea rcx, drawMessage
	jmp printFinalMessageLabel

	xWinsLabel:
	lea rcx, xWinsMessage
	jmp printFinalMessageLabel

	oWinsLabel:
	lea rcx, oWinsMessage
	jmp printFinalMessageLabel

	printFinalMessageLabel:
	call printString

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	ret

asmMain ENDP



asmPrintBoard PROC
	
	push rcx
	; save the base pointer for later and update the stack pointer
	push rbp
	sub rsp, 20h
	lea rbp, [rsp + 20h]
	
	; Print the board
	lea rcx, board
	call printString

	; reset the base and stack pointers
	lea rsp, [rbp]
	pop rbp
	pop rcx
	ret

asmPrintBoard ENDP



asmUpdateBoard PROC
	
	push rcx
	; Run a loop through the positions in the board and fill them in with the appropriate values
	mov rcx, 9
	lea rax, boardIndices				; The indices in the board we need to change
	updateLoop:
		dec rcx							; Decrease rcx for indexing purposes
		lea rsi, boardValues			; Load the address of the first board value into the source index
		add rsi, rcx					; Increment that address until the correct value is reached
		movzx rbx, BYTE PTR [rsi]		; Get the value at that point
		cmp rbx, 32						; If the value is null, don't update it (added in case I want to display the box index in the board)
		je dontChangeBoardValueLabel
		lea rdi, board					; Load the address of the first board element into the destination index
		add rdi, [rax + 8 * rcx]		; Increment that address until the correct spot on the board is reached
		movsb							; Copy the byte from the values array to the display board array
		dontChangeBoardValueLabel:
		inc rcx							; Return rcx to the correct value
	loop updateLoop

	pop rcx
	ret

asmUpdateBoard ENDP



asmUpdateTutorialBoard PROC
	
	push rcx
	; Run a loop through the positions in the board and fill them in with the appropriate values
	mov rcx, 9
	lea rax, boardIndices				; The indices in the board we need to change
	updateLoop:
		dec rcx							; Decrease rcx for indexing purposes
		lea rdi, boardValues
		cmp BYTE PTR [rdi + rcx], 32
		je dontChangeTutBoardValueLabel
		lea rdi, boardTutorial
		add rdi, [rax + 8 * rcx]
		mov BYTE PTR [rdi], 32
		dontChangeTutBoardValueLabel:
		inc rcx							; Return rcx to the correct value
	loop updateLoop

	pop rcx
	ret

asmUpdateTutorialBoard ENDP



asmCheckLine PROC

	push rcx
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
	jmp checkLineFull

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
	jmp checkLineFull

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
	jmp checkLineFull

	checkLineFull:
	cmp character, 88
	jne oFullLine
	mov gameOver, 1
	jmp checkLineEnd
	oFullLine:
	mov gameOver, 2

	checkLineEnd:
	pop rcx
	ret

asmCheckLine ENDP


; 0 = none, 1 = X wins, 2 = O wins, 3 = tie
asmCheckGameOver PROC
	
	push rcx
	; Run a loop through all possible winning lines and see if the game is over
	mov rcx, 8
	checkRowsLoop:
		mov lineNumber, rcx
		dec lineNumber

		mov character, 88
		call asmCheckLine
		cmp gameOver, 0
		jne gameOverLabel

		mov character, 79
		call asmCheckLine
		cmp gameOver, 0
		jne gameOverLabel
	loop checkRowsLoop

	; Check if the whole board is full
	mov rcx, 9
	mov rbx, 32
	lea rsi, boardValues
	fullBoardLoop:
		dec rcx
		movzx rax, BYTE PTR [rsi + rcx]
		cmp rax, rbx
		je gameOverLabel
		inc rcx
	loop fullBoardLoop

	mov gameOver, 3
	jmp gameOverLabel

	gameOverLabel:
	pop rcx
	ret

asmCheckGameOver ENDP



asmMinimax PROC
	LOCAL bestValueSoFar:QWORD

	push rcx
	; Check for end condition
	call asmCheckGameOver
	cmp gameOver, 3
	je minimaxTieLabel
	cmp gameOver, 1
	je minimaxXWinLabel
	cmp gameOver, 2
	je minimaxOWinLabel

	; Determine if maximizing or minimizing
	cmp maximizer, 0
	je notMazimizerLabel

	mov bestValueSoFar, -10
	mov rcx, 9
	maximizerLoop:
		; Check to make sure the move is available
		lea rdi, boardValues
		dec rcx
		cmp BYTE PTR [rdi + rcx], 32
		jne skipMaximizerLoopLabel

		; Make the move
		lea rdi, boardValues
		add rdi, rcx
		mov BYTE PTR [rdi], 79

		; Run the minimax algorithm
		mov maximizer, 0
		call asmMinimax

		; Undo the move
		lea rdi, boardValues
		add rdi, rcx
		mov BYTE PTR [rdi], 32

		mov rax, bestValueSoFar
		cmp moveEval, rax
		jle skipMaximizerLoopLabel		; Find the max of the two values
		mov rax, moveEval
		mov bestValueSoFar, rax

		skipMaximizerLoopLabel:
		inc rcx
	loop maximizerLoop
	jmp minimaxUpdateMoveEvalLabel

	notMazimizerLabel:
	mov bestValueSoFar, 10
	mov rcx, 9
	minimizerLoop:
		; Check to make sure the move is available
		lea rdi, boardValues
		dec rcx
		cmp BYTE PTR [rdi + rcx], 32
		jne skipMinimizerLoopLabel

		; Make the move
		lea rdi, boardValues
		add rdi, rcx
		mov BYTE PTR [rdi], 88

		; Run the minimax algorithm
		mov maximizer, 1
		call asmMinimax

		; Undo the move
		lea rdi, boardValues
		add rdi, rcx
		mov BYTE PTR [rdi], 32

		mov rax, bestValueSoFar
		cmp moveEval, rax
		jge skipMinimizerLoopLabel		; Find the min of the two values
		mov rax, moveEval
		mov bestValueSoFar, rax

		skipMinimizerLoopLabel:
		inc rcx
	loop minimizerLoop
	jmp minimaxUpdateMoveEvalLabel

	minimaxTieLabel:
	mov moveEval, 0
	mov gameOver, 0
	jmp mininmaxEndLabel

	minimaxXWinLabel:
	mov moveEval, -10
	mov gameOver, 0
	jmp mininmaxEndLabel

	minimaxOWinLabel:
	mov moveEval, 10
	mov gameOver, 0
	jmp mininmaxEndLabel

	minimaxUpdateMoveEvalLabel:
	mov rax, bestValueSoFar
	mov moveEval, rax

	mininmaxEndLabel:
	pop rcx
	ret

asmMinimax ENDP



asmFindBestMove PROC

	mov rcx, 9
	findBestMoveLoop:
		; Check if the board value at the point is valid
		lea rdi, boardValues
		dec rcx
		cmp BYTE PTR [rdi + rcx], 32
		jne skipBestMoveLoopLabel

		; Make the move
		lea rdi, boardValues
		add rdi, rcx
		mov BYTE PTR [rdi], 79

		; Run the minimax algorithm
		mov maximizer, 0
		call asmMinimax

		; Undo the move
		lea rdi, boardValues
		add rdi, rcx
		mov BYTE PTR [rdi], 32

		; Update the best move/score
		mov rax, bestMoveScore
		cmp moveEval, rax
		jle skipBestMoveLoopLabel
		mov bestMove, rcx
		mov rax, moveEval
		mov bestMoveScore, rax

		skipBestMoveLoopLabel:
		inc rcx
	loop findBestMoveLoop

	ret

asmFindBestMove ENDP

END