include List.inc

; private function prototpyes

; C function prototypes from C Runtime Library 
; "C:\Program Files\Microsoft Visual Studio 10.0\VC\lib\msvcrt.lib"
; From MSDN defination

calloc PROTO, ; return allocated memory pointer address in eax
	num: DWORD, 
	elementSize: DWORD

realloc PROTO, ; return reallocated memory pointer address in eax
	memBlock : PTR,
	newSize : DWORD

memmove PROTO,
	dest : PTR,
	src : PTR,
	count : DWORD

free PROTO,
	ptrBlock : PTR

; local functions
SizeOfDPI PROTO,
	list2d: PTR List2DI ; pointer of 2D list

CopyFirstI PROTO,
	list2d: PTR List2DI, ; pointer of 2D list
	elAddr : DWORD,
	elBytes : DWORD,
	elNumber : DWORD

CopyNPI PROTO,
	list2d: PTR List2DI, ; pointer of 2D list
	elNumber : DWORD

CopyDPI PROTO,
	list2d: PTR List2DI, ; pointer of 2D list
	elAddr : DWORD,
	elBytes : DWORD

SizeOfDPR PROTO,
	list2d: PTR List2DR ; pointer of 2D list

CopyFirstR PROTO,
	list2d: PTR List2DR, ; pointer of 2D list
	elAddr : DWORD,
	elBytes : DWORD,
	elNumber : DWORD

CopyNPR PROTO,
	list2d: PTR List2DR, ; pointer of 2D list
	elNumber : DWORD

CopyDPR PROTO,
	list2d: PTR List2DR, ; pointer of 2D list
	elAddr : DWORD,
	elBytes : DWORD

.code

; push an integer into a list, 
; return ListI member p new memory address in eax, list value (address) is unchanged
PushI proc uses ebx esi ecx,
list : PTR ListI, ; check the value in this address to locate the address of ListI struct object list
element : DWORD
	
	local endPos : DWORD	
	local count : DWORD
	
	; set esi to list
	; [esi] is the value in esi address, which is the beginning address of ListI object list,
	; it is also the address of the ListI object first member p
	; (ListI PTR [esi]) is the reference to the struct object list	
	; (ListI PTR [esi]).p is the pointer to beginning address of list.p
	; (ListI PTR [esi]).n is the value of list.n

	mov esi, list

	; check if list.p is null via esi
	cmp (ListI PTR [esi]).p, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.p is null
	invoke calloc, 0, TYPE DWORD ; return allocated memory pointer in eax
	mov (ListI PTR [esi]).p, eax ; initialize list.p
	mov (ListI PTR [esi]).n, 0 ; initialize list.n

NOT_NULL:

	; get new size in bytes	
	mov esi, list ; address value of the ListI object	
	mov ebx, (ListI PTR [esi]).n ; 
	
	mov count, ebx ; original count of elements
	imul ebx, TYPE DWORD ; convert to bytes count
	mov endPos, ebx ; save original last element position
	add ebx, TYPE DWORD ; get new bytes length for realloc
	
	; realloc to new bytes size for ListI member p, its new pointer address is in eax	
	invoke realloc, (ListI PTR [esi]).p, ebx		
	
	; set to new memory location
	mov (ListI PTR [esi]).p, eax

	; append new element
	mov esi, eax ; set ListI member p new pointer offset in esi	
	add esi, endPos ; move esi to the original list last element position
	mov ebx, element ; set new element in ebx
	mov [esi], ebx ; append the new element to the original list last element position	
	
	; set new count
	mov esi, list ; get original list address from its pointer
	mov ebx, count ; original count of elements
	inc ebx ; get new count of elements
	mov (ListI PTR [esi]).n, ebx ; set new count of list to ListI member n
				
	ret
PushI endp

; push a real8 into a list, return ListR member p new memory address in eax, list value (address) is unchanged
PushR proc uses ebx esi ecx,
list : PTR ListR, ; check the value in this address to locate the address of ListR struct object list
element : REAL8
	
	local endPos : DWORD	
	local count : DWORD

	; set esi to list
	; [esi] is the value in esi address, which is the beginning address of ListR object list,
	; it is also the address of the ListR object first member p
	; (ListR PTR [esi]) is the reference to the struct object list
	; (ListR PTR [esi]).p is the pointer to beginning address of list.p
	; (ListR PTR [esi]).n is the value of list.n

	mov esi, list

	; check if list.p is null via esi
	cmp (ListR PTR [esi]).p, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.p is null
	invoke calloc, 0, TYPE REAL8 ; return allocated memory pointer in eax
	mov (ListR PTR [esi]).p, eax ; initialize list.p
	mov (ListR PTR [esi]).n, 0 ; initialize list.n

NOT_NULL:

	; get new size in bytes
	mov esi, list ; address value of the ListR object
	mov ebx, (ListR PTR [esi]).n ; [esi] is the value in esi address, which is the beginning address of ListR member p
	mov count, ebx ; original count of elements
	imul ebx, TYPE REAL8 ; convert to bytes count
	mov endPos, ebx ; save original last element position
	add ebx, TYPE REAL8 ; get new bytes length for realloc
	
	; realloc to new bytes size for ListR member p, its new pointer address is in eax	
	invoke realloc, (ListR PTR [esi]).p, ebx		
	
	; set to new memory location
	mov (ListR PTR [esi]).p, eax

	; append new element
	mov esi, eax ; set ListD member p new pointer offset in esi	
	add esi, endPos ; move esi to the original list last element position
	fld element ; save new element at ST(0)	
	fstp REAL8 PTR[esi] ; append the new element to the original list last element position	
	
	; set new count
	mov esi, list ; get original list address from its pointer
	mov ebx, count ; original count of elements
	inc ebx ; get new count of elements
	mov (ListR PTR [esi]).n, ebx ; set new count of list to ListR member n
				
	ret
PushR endp

; push a 1D list to a 2D list
Push2di proc uses ebx esi ecx,
list2d: PTR List2DI, ; pointer of 2D list
element : PTR ListI ; the new 1D list element

	local list2dNumber : DWORD
	local elNumber, elBytes, elAddr, elEndAddr : DWORD
	local dpBytes, dpAddr, dpEndAddr : DWORD
	local npBytes, npAddr, npEndAddr : DWORD
	
	; get new element info

	; get elBytes
	mov esi, element
	mov ebx, (ListI PTR [esi]).n
	mov elNumber, ebx
	imul ebx, TYPE DWORD
	mov elBytes, ebx
	
	; get elAddr	
	mov ebx, [esi]
	mov elAddr, ebx

	; get elEndAddr
	mov ebx, elAddr
	add ebx, elBytes 
	mov elEndAddr, ebx

	; check if list2d.p is null 
	mov esi, list2d
	cmp (List2DI PTR [esi]).dp, 0

	JNE NOT_NULL ; skip list2d.p initialization if list2d.p is not null
	
	invoke CopyFirstI, list2d, elAddr, elBytes, elNumber
		
	JMP BLANK

NOT_NULL:

	invoke CopyDPI,list2d, elAddr, elBytes

	invoke CopyNPI, list2d, elNumber

	; set list2d.n
	mov esi, list2d
	inc (List2DI PTR [esi]).n

BLANK:

	ret
Push2di endp

CopyFirstI proc uses eax ebx esi,
list2d: PTR List2DI, ; pointer of 2D list
elAddr : DWORD,
elBytes : DWORD,
elNumber : DWORD

	; initialize list2d.dp
	invoke calloc, elNumber, TYPE DWORD ; return allocated memory pointer in eax
	mov esi, list2d
	mov (List2DI PTR [esi]).dp, eax ; initialize list2d.p
			
	; initialize list2.np	
	invoke calloc, 1, TYPE DWORD ; return allocated memory pointer in eax
	mov esi, list2d
	mov (List2DI PTR [esi]).np, eax ; initialize list2d.p

	; initialize list2d.n
	mov esi, list2d
	mov (List2DI PTR [esi]).n, 1 ; initialize list2d.n

	; set list2d.np
	mov esi, list2d
	mov esi, (List2DI PTR [esi]).np ; get np address
	mov ebx, elNumber
	mov [esi], ebx

	; copy element to list2d.dp
	mov esi, list2d
	mov esi, (List2DI PTR [esi]).dp ; get dp address
	invoke memmove, esi, elAddr, elBytes

	ret
CopyFirstI endp

CopyDPI proc uses eax ebx esi,
list2d: PTR List2DI, ; pointer of 2D list
elAddr : DWORD,
elBytes : DWORD

	local dpBytes, dpAddr, dpEndAddr, newLen : DWORD

	; get dpBytes
	invoke SizeOfDPI, list2d	
	mov dpBytes, eax

	; get dpAddr to realloc
	mov esi, list2d
	mov esi, (List2DI PTR [esi]).dp ; get np address
	mov dpAddr, esi		

	; extend dp with more elBytes bytes
	mov ebx, dpBytes
	add ebx, elBytes
	mov newLen, ebx 

	invoke realloc, dpAddr, newLen

	; get new dp address which could be different with original npAddr
	mov esi, list2d
	mov (List2DI PTR [esi]).dp, eax	
	mov dpAddr, eax 
	
	; get new dp end address
	mov ebx, dpAddr
	add ebx, dpBytes
	mov dpEndAddr, ebx

	; copy element to list2d.dp	
	invoke memmove, dpEndAddr, elAddr, elBytes

	ret
CopyDPI endp

CopyNPI proc uses eax ebx esi,
list2d: PTR List2DI, ; pointer of 2D list
elNumber : DWORD

	local list2dNumber, npBytes, npAddr, npEndAddr, newLen : DWORD

	; get list2dNumber
	mov esi, list2d
	mov ebx, (List2DI PTR [esi]).n
	mov list2dNumber, ebx

	; get npBytes
	mov ebx, list2dNumber
	imul ebx, TYPE DWORD
	mov npBytes, ebx
		
	; get npAddr to realloc
	mov esi, list2d
	mov esi, (List2DI PTR [esi]).np ; get np address
	mov npAddr, esi	
	
	; extend np with one new DWORD item
	mov ebx, npBytes
	add ebx, TYPE DWORD
	mov newLen, ebx

	invoke realloc, npAddr, newLen

	; get new np address which could be different with original npAddr
	mov esi, list2d
	mov (List2DI PTR [esi]).np, eax
	mov npAddr, eax 

	; get new np end address
	mov ebx, npAddr
	add ebx, npBytes
	mov npEndAddr, ebx

	; set list2d.np
	mov esi, list2d
	mov esi, npEndAddr
	mov ebx, elNumber
	mov [esi], ebx

	ret

CopyNPI endp

; get sum of list2d.dp in eax
SizeOfDPI proc uses esi ecx ebx,
list2d: PTR List2DI ; pointer of 2D list
	
	local dpBytes : DWORD
			
	mov dpBytes, 0 ; initial countBytes

	mov esi, list2d		
	mov ecx, (List2DI PTR [esi]).n ; loop count : rows in list2d
	
	JCXZ BLANK ; if ecx == 0 then skip

	mov esi, list2d		
	mov esi, (List2DI PTR [esi]).np ; get np address

L1:	
		
		mov ebx, [esi] ; get current DWORD elements number in this row
					
		imul ebx, TYPE DWORD ; convert to bytes

		add dpBytes, ebx ; save total bytes
		
		add esi, TYPE DWORD ; move to next row

	LOOP L1


BLANK:
	
	mov eax, dpBytes

	ret

SizeOfDPI endp

; get element at row index 
GetListIElement proc uses esi ecx ebx,
list2d: PTR List2DI, ; pointer of 2D list
rowIndex : DWORD,
element : PTR ListI
	
	local dpBytes, count, lastdpBytes : DWORD

	mov dpBytes, 0 
	mov count, 0 

	mov esi, element

	; check if element.p is null via esi
	cmp (ListI PTR [esi]).p, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.p is null
	invoke calloc, 0, TYPE DWORD ; return allocated memory pointer in eax
	mov (ListI PTR [esi]).p, eax ; initialize list.p
	mov (ListI PTR [esi]).n, 0 ; initialize list.n
			
	NOT_NULL:
	
	mov esi, list2d		
	mov ebx, (List2DI PTR [esi]).n ; loop count : rows in list2d
	cmp ebx, rowIndex
	JLE INDEX_EXCEED
	
	mov ecx, rowIndex 	;rowIndex start from 0, this ensure loop count is 1 if rowIndex == 0
	inc ecx

	mov esi, list2d		
	mov esi, (List2DI PTR [esi]).np ; get np address

L1:	
		
		mov ebx, [esi] ; get current DWORD elements number in this row
		
		mov count, ebx

		imul ebx, TYPE DWORD ; convert to bytes

		mov lastdpBytes, ebx

		add dpBytes, ebx ; save total bytes
		
		add esi, TYPE DWORD ; move to next row

	LOOP L1

FIRST_ITEM:

	; get dp address for rowIndex
	mov esi, list2d		
	mov ebx, (List2DI PTR [esi]).dp ; get np address
	add ebx, dpBytes
	sub ebx, lastdpBytes

	; return element.p
	mov esi, element	
	mov (ListI PTR [esi]).p, ebx

	; return element.n
	mov ebx, count
	mov (ListI PTR [esi]).n, ebx

INDEX_EXCEED:		

	ret

GetListIElement endp

; push a 1D list to a 2D list
Push2dR proc uses ebx esi ecx,
list2d: PTR List2DR, ; pointer of 2D list
element : PTR ListR ; the new 1D list element

	local list2dNumber : DWORD
	local elNumber, elBytes, elAddr, elEndAddr : DWORD
	local dpBytes, dpAddr, dpEndAddr : DWORD
	local npBytes, npAddr, npEndAddr : DWORD
	
	; get new element info

	; get elBytes
	mov esi, element
	mov ebx, (ListR PTR [esi]).n
	mov elNumber, ebx
	imul ebx, TYPE REAL8
	mov elBytes, ebx
	
	; get elAddr	
	mov ebx, [esi]
	mov elAddr, ebx

	; get elEndAddr
	mov ebx, elAddr
	add ebx, elBytes 
	mov elEndAddr, ebx

	; check if list2d.dp is null 
	mov esi, list2d
	cmp (List2DR PTR [esi]).dp, 0

	JNE NOT_NULL ; skip list2d.p initialization if list2d.p is not null
	
	invoke CopyFirstR, list2d, elAddr, elBytes, elNumber
		
	JMP BLANK

NOT_NULL:

	invoke CopyDPR,list2d, elAddr, elBytes

	invoke CopyNPR, list2d, elNumber

	; set list2d.n
	mov esi, list2d
	inc (List2DR PTR [esi]).n

BLANK:

	ret
Push2dR endp

CopyFirstR proc uses eax ebx esi,
list2d: PTR List2DR, ; pointer of 2D list
elAddr : DWORD,
elBytes : DWORD,
elNumber : DWORD

	; initialize list2d.dp
	invoke calloc, elNumber, TYPE REAL8 ; return allocated memory pointer in eax
	mov esi, list2d
	mov (List2DR PTR [esi]).dp, eax ; initialize list2d.p
			
	; initialize list2.np	
	invoke calloc, 1, TYPE DWORD ; return allocated memory pointer in eax
	mov esi, list2d
	mov (List2DR PTR [esi]).np, eax ; initialize list2d.p

	; initialize list2d.n
	mov esi, list2d
	mov (List2DR PTR [esi]).n, 1 ; initialize list2d.n

	; set list2d.np
	mov esi, list2d
	mov esi, (List2DR PTR [esi]).np ; get np address
	mov ebx, elNumber
	mov [esi], ebx

	; copy element to list2d.dp
	mov esi, list2d
	mov esi, (List2DR PTR [esi]).dp ; get dp address
	invoke memmove, esi, elAddr, elBytes

	ret
CopyFirstR endp

CopyDPR proc uses eax ebx esi,
list2d: PTR List2DR, ; pointer of 2D list
elAddr : DWORD,
elBytes : DWORD

	local dpBytes, dpAddr, dpEndAddr, newLen : DWORD

	; get dpBytes
	invoke SizeOfDPR, list2d	
	mov dpBytes, eax

	; get dpAddr to realloc
	mov esi, list2d
	mov esi, (List2DR PTR [esi]).dp ; get np address
	mov dpAddr, esi		

	; extend dp with more elBytes bytes
	mov ebx, dpBytes
	add ebx, elBytes
	mov newLen, ebx 

	invoke realloc, dpAddr, newLen

	; get new dp address which could be different with original npAddr
	mov esi, list2d
	mov (List2DR PTR [esi]).dp, eax	
	mov dpAddr, eax 
	
	; get new dp end address
	mov ebx, dpAddr
	add ebx, dpBytes
	mov dpEndAddr, ebx

	; copy element to list2d.dp	
	invoke memmove, dpEndAddr, elAddr, elBytes

	ret
CopyDPR endp

CopyNPR proc uses eax ebx esi,
list2d: PTR List2DR, ; pointer of 2D list
elNumber : DWORD

	local list2dNumber, npBytes, npAddr, npEndAddr, newLen : DWORD

	; get list2dNumber
	mov esi, list2d
	mov ebx, (List2DR PTR [esi]).n
	mov list2dNumber, ebx

	; get npBytes
	mov ebx, list2dNumber
	imul ebx, TYPE DWORD
	mov npBytes, ebx
		
	; get npAddr to realloc
	mov esi, list2d
	mov esi, (List2DR PTR [esi]).np ; get np address
	mov npAddr, esi	
	
	; extend np with one new DWORD item
	mov ebx, npBytes
	add ebx, TYPE DWORD
	mov newLen, ebx

	invoke realloc, npAddr, newLen

	; get new np address which could be different with original npAddr
	mov esi, list2d
	mov (List2DR PTR [esi]).np, eax
	mov npAddr, eax 

	; get new np end address
	mov ebx, npAddr
	add ebx, npBytes
	mov npEndAddr, ebx

	; set list2d.np
	mov esi, list2d
	mov esi, npEndAddr
	mov ebx, elNumber
	mov [esi], ebx

	ret

CopyNPR endp

; get sum of list2d.dp in eax
SizeOfDPR proc uses esi ecx ebx,
list2d: PTR List2DR ; pointer of 2D list
	
	local dpBytes : DWORD
			
	mov dpBytes, 0 ; initial countBytes

	mov esi, list2d		
	mov ecx, (List2DI PTR [esi]).n ; loop count : rows in list2d
	
	JCXZ BLANK ; if ecx == 0 then skip

	mov esi, list2d		
	mov esi, (List2DR PTR [esi]).np ; get np address

L1:	
		
		mov ebx, [esi] ; get current DWORD elements number in this row
					
		imul ebx, TYPE REAL8 ; convert to bytes offset in dp

		add dpBytes, ebx ; save total bytes
		
		add esi, TYPE DWORD ; move to next row

	LOOP L1


BLANK:
	
	mov eax, dpBytes

	ret

SizeOfDPR endp

; get element at row index 
GetListRElement proc uses esi ecx ebx,
list2d: PTR List2DR, ; pointer of 2D list
rowIndex : DWORD,
element : PTR ListR
	
	local dpBytes, count, lastdpBytes : DWORD

	mov dpBytes, 0 
	mov count, 0 

	mov esi, element

	; check if element.p is null via esi
	cmp (ListR PTR [esi]).p, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.p is null
	invoke calloc, 0, TYPE REAL8 ; return allocated memory pointer in eax
	mov (ListR PTR [esi]).p, eax ; initialize list.p
	mov (ListR PTR [esi]).n, 0 ; initialize list.n
			
	NOT_NULL:
	
	mov esi, list2d		
	mov ebx, (List2DR PTR [esi]).n ; loop count : rows in list2d
	cmp ebx, rowIndex
	JLE INDEX_EXCEED
	
	mov ecx, rowIndex 	;rowIndex start from 0, this ensure loop count is 1 if rowIndex == 0
	inc ecx

	mov esi, list2d		
	mov esi, (List2DR PTR [esi]).np ; get np address

L1:	
		
		mov ebx, [esi] ; get current DWORD elements number in this row
		
		mov count, ebx

		imul ebx, TYPE REAL8 ; convert to bytes offset in dp

		mov lastdpBytes, ebx

		add dpBytes, ebx ; save total bytes
		
		add esi, TYPE DWORD ; move to next row

	LOOP L1

FIRST_ITEM:

	; get dp address for rowIndex
	mov esi, list2d		
	mov ebx, (List2DR PTR [esi]).dp ; get np address
	add ebx, dpBytes
	sub ebx, lastdpBytes

	; return element.p
	mov esi, element	
	mov (ListR PTR [esi]).p, ebx

	; return element.n
	mov ebx, count
	mov (ListR PTR [esi]).n, ebx

INDEX_EXCEED:		

	ret

GetListRElement endp

; copy list to newList
CopyListI proc uses esi eax ebx,
list : PTR ListI,
newList : PTR ListI ; newList need to initialize with default n value, i.e. declare as global varaible "newList ListI <?>"

	local count, srcAddr, oriAddr, oriCount, copyBytes : DWORD

	; get copy source address
	mov esi, list
	mov ebx, (ListI PTR [esi]).n
	mov count, ebx
	mov ebx, (ListI PTR [esi]).p
	mov srcAddr, ebx

	; get free original address 
	mov esi, newList
	mov ebx, (ListI PTR [esi]).p
	mov oriAddr, ebx

	; this n value could be a wild value if newList is declared a local variable or
	; or declared a global variable as "newList ListI <>" rather than "newList ListI <?>"
	; declare newList as a global with "newList ListI <?>" is correct way, 
	; which always uses n default value 0 in ListI struct defination to initialize ListI.n
	; while "newList ListI <>" declaration does not
	mov ebx, (ListI PTR [esi]).n 
	mov oriCount, ebx

	; initialize or reset list.p and list.n 
	invoke calloc, count, TYPE DWORD ; return allocated memory pointer in eax
	mov esi, newList
	mov (ListI PTR [esi]).p, eax ; initialize list.p
	mov ebx, count
	mov (ListI PTR [esi]).n, ebx ; initialize list.n
	
	; free original newList.p here to avoid memory leak
	mov ebx, oriCount
	cmp ebx, 0
	JE SKIP_FREE ; if oriCount == 0
	invoke free, oriAddr ; if oriCount != 0, free could fail if the oriCount is a wild n value above

SKIP_FREE:

	; get bytes count to copy
	mov ebx, count
	imul ebx, TYPE DWORD
	mov copyBytes, ebx

	; copy
	mov esi, newList
	invoke memmove, (ListI PTR [esi]).p, srcAddr, copyBytes

	ret

CopyListI endp

; clone array
CopyListR proc, 
	srcList : PTR ListR,
	destList : PTR ListR
	
	local i, count, srcAddr, destAddr, oriAddr, oriCount, newAddr : DWORD 	
	local tempR : REAL8

	pushad ; save all registers

	mov esi, srcList
	mov ebx, (ListR PTR[esi]).n
	mov count, ebx
	mov ebx, (ListR PTR[esi]).p
	mov srcAddr, ebx

	; initialize or reset destList.p and destList.n
	invoke calloc, count, TYPE REAL8 ; return allocated memory pointer in eax	
	cmp eax, 0 

	; calloc return null, calloc fails. 
	; this is usually not caused by running out of continous heap memory block
	; this is usually caused by a bug somewhere in the functions calling chains
	; trace back the functions to see if somewhere having a unexpected global variable overwritting
	JE CALLOC_ERROR_ZERO 

	mov destAddr, eax 
		
	; get original address to be freed
	mov esi, destList
	mov ebx, (ListR PTR [esi]).n
	mov oriCount, ebx
	mov ebx, (ListR PTR [esi]).p
	mov oriAddr, ebx ; this oriAddr maybe 0 if destList is first time referenced after its declaration
	 	
	mov esi, destList
	mov ebx, destAddr
	mov (ListR PTR [esi]).p, ebx ; initialize list.p with new allocated memory address	
	mov ebx, count
	mov (ListR PTR [esi]).n, ebx ; initialize list.n same as srcList
	
	; free original destList.p here to avoid memory leak
	mov ebx, oriCount
	cmp ebx, 0
	
	; if oriCount == 0 then skip free.
	; this is usually when destList is first time referenced and its p member is still blank without memory allocated
	; in this situation, oriAddr == 0x00000000, which cause free crash
	JE SKIP_FREE 

	; free invokation may crash if oriAddr is 0 (null) or an in-use address, i.e. stack memory address
	invoke free, oriAddr ; if oriCount != 0

SKIP_FREE:

	mov esi, destList
	mov esi, (ListR PTR[esi]).p	
	mov ebx, esi ; save destination array offset address in ebx

	mov i, 0
	mov ecx, count
	
L1:
		mov edi, i ; edi as index

		; copy
		mov esi, srcAddr						
		fld REAL8 PTR[esi + edi * 8]		
		mov esi, destAddr
		fstp REAL8 PTR[esi + edi * 8]

		inc i ; i++

	LOOP L1

	popad ; restore all registers
	JMP DONE

CALLOC_ERROR_ZERO:

		; if return eax == -2, then calloc fails
		mov eax, -2

DONE:

	ret
CopyListR endp

end