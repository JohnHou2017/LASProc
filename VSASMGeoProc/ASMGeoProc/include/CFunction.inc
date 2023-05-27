;
; C function prototypes from C Runtime (crt) Library 
; "C:\Program Files\Microsoft Visual Studio 10.0\VC\lib\msvcrt.lib"
; Defination is from online MSDN
;
; The source codes of these C functions are in
; "C:\Program Files\Microsoft Visual Studio 10.0\VC\crt\src"
;

printf PROTO, ; return printed bytes in eax
    formatString: PTR BYTE, ; format string address
    printList: VARARG ; variable arguments

malloc PROTO, ; return allocated memory pointer address in eax
	bytesSize: DWORD

calloc PROTO, ; return allocated memory pointer address in eax
	num: DWORD, 
	elementSize: DWORD

realloc PROTO, ; return reallocated memory pointer address in eax
	memBlock : PTR,
	newSize : DWORD

memmove PROTO, ; return value of dest if success in eax
	dest : PTR,
	src : PTR,
	count : DWORD

free PROTO,
	ptrBlock : PTR

; FILE is a struct, its defination is in 
; "C:\Program Files\Microsoft Visual Studio 10.0\VC\include\stdio.h"
fopen PROTO, ; return (PTR FILE)
   filename : PTR BYTE,
   mode : PTR BYTE

fread PROTO, ; return count to read in eax
   buffer : PTR,
   unitsize : DWORD,
   count : DWORD, ; return this value in eax if success
   stream : PTR FILE

fwrite PROTO, ; return bytes count to write to binary file in eax
   buffer : PTR,
   unitsize : DWORD,
   count : DWORD, ; ; return this value in eax if success
stream : PTR FILE

fseek PROTO, ; return 0 in eax if success
   stream : PTR FILE,
   pos : DWORD,
   origin : DWORD

fclose PROTO, ; return 0 in eax if success
   stream : PTR FILE

fprintf PROTO, ; return bytes count to write to text file in eax based on format, if fail then return 0 in eax
   stream : PTR FILE,
   format : PTR BYTE, ; "%15.6f " will return 0x00000010 in eax because format "%15.6f " has 16 bytes to write
   varlist : VARARG
   