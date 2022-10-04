; Assignemt 5, Alternative 2 MASM 64-bit

extrn ExitProcess : proc						; forward declare the exit function

.DATA											; section header to define variables
pin WORD 7, 4, 9, 5								; define array for the pin
ranges WORD 3, 6, 1, 4, 7, 9, 2, 5				; define array which holds the mins and maxs for the corresponding digit of the pin
valid BYTE 0									; define flag for if the pin is valid. 0 is invalid, 1 is valid

.CODE											; section header to write code

_main PROC										; define _main function

mov rcx, 4										; set rcx to keep track of how many times we want to loop. in this case, there are 4 digits, so we loop 4 times
loopBegin:										; label for the beginning of the loop
	lea rax, pin								; load the address of the pin array into the rax register for access later
	lea rbx, ranges								; load the address of the ranges array into the rbx register for access later
	dec rcx										; decrement rcx for index math
	movzx rax, WORD PTR [rax + rcx * 2]			; get the value of the pin at the appropriate location in the array and load it into rax
	movzx rdx, WORD PTR [rbx + rcx * 4]			; get the low value of the range and load it into rdx
	movzx rbx, WORD PTR [rbx + rcx * 4 + 2]		; get the high value of the range and load it into rbx
	inc rcx										; increment rcx to regain the correct loop counter

	cmp rax, rdx								; compare the pin value with the lower range
	jnge testFail								; immediately exit the loop if the pin value is too low

	cmp rax, rbx								; compare the pin value with the higher range
	jnle testFail								; immediately exit the loop if the pin value is too high
loop loopBegin									; instruction for the loop

mov valid, 1									; if all the tests passed, set the valid flag to signify a valid pin

testFail:										; label for when a test fails
xor rcx, rcx									; clear return register (return 0)
call ExitProcess								; call the exit process function (defined by Windows and declared earlier

_main ENDP										; end of the _main function

END												; end the script