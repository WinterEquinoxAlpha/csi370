; Assignemt 4.4 MASM 64-bit

extrn ExitProcess : proc				; forward declare the exit function

.DATA									; section header to define variables
array WORD 5, 10, 15, 20
arrayD DWORD ?
multiplier BYTE 8

.CODE									; section headerr to write code

_main PROC								; define _main function
   movzx rax, WORD PTR [array]
   mul multiplier
   mov [arrayD], eax

   movzx rax, WORD PTR [array+2]
   mul multiplier
   mov [arrayD+4], eax

   movzx rax, WORD PTR [array+4]
   mul multiplier
   mov [arrayD+8], eax

   movzx rax, WORD PTR [array+6]
   mul multiplier
   mov [arrayD+12], eax

xor rcx, rcx							; clear return register (return 0)
call ExitProcess						; call the exit process function (defined by Windows and declared earlier

_main ENDP								; end of the _main function

END										; end the script