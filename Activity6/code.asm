; code.asm

displaySomething PROTO

.CODE

asmMain PROC
	mov rax, 10
	call displaySomething
	ret
asmMain ENDP

END