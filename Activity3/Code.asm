; Assignment 3.3
; Syntax Translation - MASM, Visual C++ on Windows 10 (64-bit)
; Copyright (c) 2019 Hall & Slonka

extern ExitProcess : proc

.data
letter BYTE ?
r DWORD ?
s DWORD ?
t DWORD ?
x WORD ?
y WORD ?
z WORD ?

.code
_main PROC

mov letter, 77h
mov r, 5h
mov s, 2h
mov x, 0ah
mov y, 4h

mov ax, x
add ax, y
mov z, ax

mov ax, x
sub ax, y
mov z, ax

mov edx, 0h
mov eax, r
mov ecx, s
div ecx
mov t, eax

mov edx, 0h
mov eax, r
mov ecx, s
div ecx
mov t, edx

xor rcx, rcx
call ExitProcess
_main ENDP

END