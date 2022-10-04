; Assignemt 4.4 MASM 64-bit

extrn ExitProcess : proc			; forward declare the exit function

.DATA								; section header to define variables
array WORD 5, 10, 15, 20			; create a WORD array with the given values
multiplier BYTE 8					; create a BYTE to hold the value that multiplies

arrayD DWORD ?						; create a DWORD array with undelcared values. this is created after the declared memory to prevent it from overriding values

.CODE								; section headerr to write code

_main PROC							; define _main function
   movzx rax, WORD PTR [array]		; move the first element of array into rax
   mul multiplier					; multiply rax by the multiplier
   mov [arrayD], eax				; save the result cast as a DWORD into the first element of arrayD

   movzx rax, WORD PTR [array+2]	; move the second element of array into rax
   mul multiplier					; multiply rax by the multiplier
   mov [arrayD+4], eax				; save the result cast as a DWORD into the second element of arrayD

   movzx rax, WORD PTR [array+4]	; move the third element of array into rax
   mul multiplier					; multiply rax by the multiplier
   mov [arrayD+8], eax				; save the result cast as a DWORD into the third element of arrayD

   movzx rax, WORD PTR [array+6]	; move the fourth element of array into rax
   mul multiplier					; multiply rax by the multiplier
   mov [arrayD+12], eax				; save the result cast as a DWORD into the fourth element of arrayD

xor rcx, rcx						; clear return register (return 0)
call ExitProcess					; call the exit process function (defined by Windows and declared earlier

_main ENDP							; end of the _main function

END									; end the script