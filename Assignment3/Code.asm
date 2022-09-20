; Assignemt 3.4 MASM 64-bit

extrn ExitProcess : proc				; forward declare the exit function

.DATA									; section header to define variables
ans QWORD ?								; define variable "ans" of side QWORD (8 bytes) with unspecified value
outputText BYTE "The answer is: ", 0	; devine string "outputText"

.CODE									; section headerr to write code

_main PROC								; define _main function
   mov rax, 4							; move the value 4 into the rax register
   mov rbx, 3							; move the value 3 into the rbx register
   mov rcx, 2							; move the value 2 into the rcx register
   mov rdx, 1							; move the value 1 into the rdx register

   add rax, rbx							; add rbx (4) to rax (3)
   add rcx, rdx							; add rcx (2) to rdx (1)
   sub rax, rcx							; subtract rcx (3) from rax (7)

   mov ans, rax							; move the result of the subtraction (rax, should be 4) into the variable ans

xor rcx, rcx							; clear return register (return 0)
call ExitProcess						; call the exit process function (defined by Windows and declared earlier

_main ENDP								; end of the _main function

END										; end the script