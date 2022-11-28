; Assignment 11
; Adapted from Program 10.8 Copyright (c) 2017 Hall & Slonka
; Adapted by Michael Kashian

extrn ExitProcess : proc
extrn MessageBoxA : proc
extrn CreateFileA : proc
extrn ReadFile : proc
extrn WriteFile : proc
extrn CloseHandle : proc
extrn GetLastError : proc

.DATA
bufferSize QWORD 2047
inputFile BYTE "Input.txt", 0
outputFile BYTE "Output.txt", 0
messageBoxTitle BYTE "File Copy", 0

failInputText BYTE "Could not open Input.txt", 0
failOutputText BYTE "Could not create Output.txt", 0
failReadText BYTE "Could not read Intput.txt", 0
failWriteText BYTE "Could not write to Output.txt", 0
successText BYTE "Successful", 0

buffer BYTE 2048 DUP (0)

inputHandle QWORD ?
outputHandle QWORD ?
readSuccess QWORD ?
writeSuccess QWORD ?
charsRead QWORD 0
charsWritten QWORD 0
buttonClicked QWORD ?
inputClosed QWORD ?
outputClosed QWORD ?

.CODE
_main PROC

	sub rsp, 48h						; reserve for return and rbp, parameters, and shadow space

	; OPEN INPUT FILE
	lea rcx, inputFile					; load the address of the input file name
	mov rdx, 80000000h					; load the flag for GENERIC_READ
	xor r8, r8							; 0 share mode
	xor r9, r9							; 0 security
	mov QWORD PTR [rsp+48h-28h], 3		; reverse order, 3 open existing
	mov QWORD PTR [rsp+48h-20h], 80h	; flags FILE_ATTRIBUTE_NORMAL
	mov QWORD PTR [rsp+48h-18h], 0		; 0 template
	call CreateFileA					; open the file (call windows function)
	mov inputHandle, rax				; save handle
	cmp inputHandle, -1					; check if the handle exists
	jz inputOpenFail					; if not, end early and inform user

	; CREATE OUTPUT FILE
	lea rcx, outputFile					; load the address of the output file name
	mov rdx, 0C0000000h					; load the flag for GENERIC_READ_WRITE
	xor r8, r8							; 0 share mode
	xor r9, r9							; 0 security
	mov QWORD PTR [rsp+48h-28h], 2		; reverse order, 2 create new always
	mov QWORD PTR [rsp+48h-20h], 80h	; flags FILE_ATTRIBUTE_NORMAL
	mov QWORD PTR [rsp+48h-18h], 0		; 0 template
	call CreateFileA					; create the file (call windows function)
	mov outputHandle, rax				; save handle
	cmp outputHandle, -1				; check if the handle exists
	jz outputOpenFail					; if not, end early and inform user

	; READ INPUT FILE
	mov rcx, inputHandle				; pass input file handle
	lea rdx, buffer						; pass address of buffer
	mov r8, bufferSize					; pass buffer size
	lea r9, charsRead					; pass address of charsRead
	mov QWORD PTR [rsp+48h-28h], 0		; 0 overlap
	call ReadFile						; read the contents of the file into the buffer (call windows function)
	mov readSuccess, rax				; save the success status of the file read
	cmp readSuccess, 0					; check if the read was successful
	jz readFail							; if not, end early and inform user

	; WRITE TO OUTPUT FILE
	mov rcx, outputHandle				; pass output file handle
	lea rdx, buffer						; pass address of buffer
	mov r8, bufferSize					; pass buffer size
	lea r9, charsWritten				; pass address of charsWritten
	mov QWORD PTR [rsp+48h-28h], 0		; 0 overlap
	call WriteFile						; write the contents of the buffer to the file (call windows function)
	mov writeSuccess, rax				; save the success status of the file write
	cmp writeSuccess, 0					; check if the write was successful
	jz writeFail						; if not, end early and inform user
	jmp success							; if everything succeeded, inform the user

	; INFORM USER OF STATUS
	inputOpenFail:
	lea rdx, failInputText				; pass input fail text address
	jmp messageBox						; jump to the message box

	outputOpenFail:
	lea rdx, failOutputText				; pass output fail text address
	jmp messageBox						; jump to the message box

	readFail:
	lea rdx, failReadText				; pass read fail text address
	jmp messageBox						; jump to the message box

	writeFail:
	lea rdx, failWriteText				; pass write fail text address
	jmp messageBox						; jump to the message box

	success:
	lea rdx, successText				; pass success text address

	messageBox:
	xor rcx, rcx						; 0 handle owner
	lea r8, messageBoxTitle				; pass title address
	xor r9, r9							; 0 MB_OK
	call MessageBoxA					; create the message box (call windows function)
	mov buttonClicked, rax				; save button clicked

	; CLOSE OUTPUT FILE
	mov rcx, outputHandle				; pass output file handle
	call CloseHandle					; close the input file handle (call windows function)
	mov outputClosed, rax				; save success status of handle close

	; CLOSE INPUT FILE
	mov rcx, inputHandle				; pass input file handle
	call CloseHandle					; close the input file handle (call windows function)
	mov inputClosed, rax				; save success status of handle close

	mov rcx, 0							; clear return register (return 0)
	call ExitProcess					; exit process (call windows function)

_main ENDP
END