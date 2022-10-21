; Assignemt 5, Alternative 2 MASM 64-bit

extrn ExitProcess : proc			; forward declare the exit function

.DATA								; section header to define variables
String1 BYTE "Try harder" ,0		; define first string to compare
String2 BYTE "Try harder still" ,0	; define second string to compare
StringLength BYTE 16				; define the length of the longer string to ensure we compare properly

.CODE								; section header to write code

_main PROC							; define _main function

lea rsi, String1					; load the strings into the apporpriate registers
lea rdi, String2
mov rcx, QWORD PTR StringLength		; load the string length into the counter register for the rep

cmpsb								; compare the first letter of the string. If it's different, we know the string is totally different and don't even have to compare the rest
jnz totally_different

cld									; clear the direction flag
repz cmpsb							; compare each letter of the two strings. If a difference is found, it will stop and rcx will hold string length minus the index of the difference
jnz different_at_index

mov rax, QWORD PTR StringLength		; if the strings are identical, move the length of the string to rax to indicate it and jump to the end of the program
jmp finish

totally_different:					; if the strings are totally different, move 0 (index of difference) to rax to indicate it and jump to the end of the program
mov rax, 0
jmp finish

different_at_index:					; if the strings are different at a specific index, move the index of difference (string length - rcx) to rax to indicate it and jump to the end of the program
mov rax, QWORD PTR StringLength
sub rax, rcx
jmp finish							; this jump is technically not necessary, but I left it in for consistency

finish:
xor rcx, rcx						; clear return register (return 0)
call ExitProcess					; call the exit process function (defined by Windows and declared earlier)

_main ENDP							; end of the _main function

END									; end the script