; code.asm

getInput PROTO
dispOutput PROTO

.CODE

asmMain PROC
	mov rax, 10
	call getInput
	mov ebx, [rax]
	mov ecx, [rax + 4]
	add ecx, ebx
	call dispOutput
	ret
asmMain ENDP

END