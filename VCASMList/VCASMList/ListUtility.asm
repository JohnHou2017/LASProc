include List.inc

TRUE EQU 1
FALSE EQU 0

.data

tempListI ListI <?>
listCopyI ListI <?>
tempListR ListR <?>
listCopyR ListR <?>

MinRealCompareError REAL8 1.0E-12

.code

BubbleSortListI proc uses eax ecx esi ebx,
list : PTR ListI

	local pData : DWORD ; offset address of 1d pDataay		
    local count : DWORD ; number of elements 	
	
	mov esi, list
	mov ebx, (ListI PTR [esi]).p
	mov pData, ebx
	mov ebx, (ListI PTR [esi]).n
	mov count, ebx

	; the following code is from the book "assembly language for x86 processors" by Kip Irvine
	mov ecx,count
	dec ecx 
L1: 
	push ecx 
	mov esi,pData 
L2: 
	mov eax,[esi] 
	cmp [esi+4],eax 
	jg L3 
	xchg eax,[esi+4] 
	mov [esi],eax
L3: 
	add esi,4
	loop L2 
	pop ecx 
	loop L1 
L4: 
	
	ret

BubbleSortListI endp

CompareListI proc uses ecx ebx esi, 
list1 : PTR ListI,
list2 : PTR ListI

	local array1 : DWORD ; offset array1
	local array2 : DWORD ; offset array2
	local array1Len : DWORD ; length of array    
	local array2Len : DWORD ; length of array  	

	local i : DWORD
	local retEqual : DWORD
	
	mov esi, list1
	mov ebx, (ListI PTR [esi]).p
	mov array1, ebx
	mov ebx, (ListI PTR [esi]).n
	mov array1Len, ebx

	mov esi, list2
	mov ebx, (ListI PTR [esi]).p
	mov array2, ebx
	mov ebx, (ListI PTR [esi]).n
	mov array2Len, ebx

	cmp ebx, array1Len

	JNE DONE_NOT_EQUAL ; if 2 array length is different

	; set initial return value TRUE
	mov retEqual, TRUE
	
	mov i, 0
	mov ecx, array1Len

L1:		
        mov esi, array1
		mov ebx, [esi]
		mov esi, array2
		cmp [esi], ebx

		JNE DONE_NOT_EQUAL
		
		add array1, 4
		add array2, 4
		
	LOOP L1

	JMP DONE_EQUAL

DONE_NOT_EQUAL:

		mov retEqual, FALSE

DONE_EQUAL:
		
		; return retEqual 
		mov eax, retEqual		

		ret

CompareListI endp

; check if list2d contains list with ignoring list elements order 
ContainsListI proc uses ebx esi,
list2d : PTR List2DI,
list : PTR ListI
		
	local isContains, rows, i : DWORD	
		
	; initialize return value
	mov isContains, FALSE

	; copy list to avoid modify original list with sorting
	invoke CopyListI, list, ADDR listCopyI

	; sort list
	invoke BubbleSortListI, ADDR listCopyI

	; get rows
	mov esi, list2d
	mov ebx, (List2DI PTR [esi]).n
	mov rows, ebx
		
	mov i, 0
	mov ecx,rows 	
L1: 
		invoke GetListIElement, list2d, i, ADDR tempListI

		invoke BubbleSortListI, ADDR tempListI

		invoke CompareListI, ADDR tempListI, ADDR listCopyI

		cmp eax, TRUE

		JE DONE_TRUE		

		inc i
				
	loop L1

	JMP DONE_FALSE

DONE_TRUE:	

		mov isContains, TRUE	

DONE_FALSE:

		; return value in eax
		mov eax, isContains

		ret
ContainsListI endp

; check if a 2d real array contains a 1d real array
ContainsListR proc,
list2d : PTR List2DR,
list : PTR ListR

	local isContains, rows, i : DWORD	
		
	; initialize return value
	mov isContains, FALSE

	; copy list to avoid modify original list with sorting
	invoke CopyListR, list, ADDR listCopyR

	; sort list
	invoke BubbleSortListR, ADDR listCopyR

	; get rows
	mov esi, list2d
	mov ebx, (List2DR PTR [esi]).n
	mov rows, ebx
		
	mov i, 0
	mov ecx,rows 	
L1: 
		invoke GetListRElement, list2d, i, ADDR tempListR

		invoke BubbleSortListR, ADDR tempListR

		invoke CompareListR, ADDR tempListR, ADDR listCopyR

		cmp eax, TRUE

		JE DONE_TRUE		

		inc i
				
	loop L1

	JMP DONE_FALSE

DONE_TRUE:

		mov isContains, TRUE	

DONE_FALSE:
		
		; return value in eax
		mov eax, isContains

		ret
ContainsListR endp

; check if two 1d array equal
; return true or false in eax
CompareListR proc, 
list1 : PTR ListR,
list2 : PTR ListR

	local array1 : DWORD ; offset array1
	local array2 : DWORD ; offset array2
	local array1Len : DWORD ; length of array    
	local array2Len : DWORD ; length of array  
	local dummy1, dummy2 : REAL8

	local i : DWORD
	local retEqual : DWORD
	
	; set initial return value TRUE
	mov retEqual, TRUE

	mov esi, list1
	mov ebx, (ListR PTR [esi]).p
	mov array1, ebx
	mov ebx, (ListR PTR [esi]).n
	mov array1Len, ebx

	mov esi, list2
	mov ebx, (ListR PTR [esi]).p
	mov array2, ebx
	mov ebx, (ListR PTR [esi]).n
	mov array2Len, ebx

	cmp ebx, array1Len

	JNE DONE_NOT_EQUAL ; if 2 array length is different
			
	mov i, 0
	mov ecx, array1Len

L1:		
		; push minimum error at ST(1)
		fld MinRealCompareError

		; push array1[i] at ST(0)
		mov esi, array1
		fld REAL8 PTR[esi]

		; operate array1[i] - array2[i] at ST(0)
		mov esi, array2
		fsub REAL8 PTR[esi]

		; operate fabs(array1[i] - array2[i]) at ST(0)
		fabs

		; compare 
		fcomi ST(0), ST(1)

		; return false if difference abs value is above error
		JA DONE_NOT_EQUAL

		; continue if difference abs value is not above error, the 2 value are equal	
		fstp dummy2
		fstp dummy1		
		
		add array1, 8
		add array2, 8
		
	LOOP L1

	JMP DONE_EQUAL

DONE_NOT_EQUAL:

		mov retEqual, FALSE

DONE_EQUAL:

		; return retEqual 
		mov eax, retEqual		

		ret
		
CompareListR endp

; Bubble Sort 1d REAL8 array 
;	for(i = 0; i< count ; i++)
;		for (j= i + 1; j< count , j++)				
;			if(array[i] > array[j]) 
;           {
;				temp = array[j];
;				array[j] = array[i];
;				array[i] = temp;		
;           }
BubbleSortListR proc,
list : PTR ListR
		
    local i, j : DWORD ; number of elements 		
	local dummy1, dummy2 : REAL8	

	pushad ; save all general registers

	; initialize esi with arr array address	
	mov esi, list
	mov edx, (ListR PTR[esi]).n
	mov esi, (ListR PTR[esi]).p
	
	mov i, 0 ; i = 0
		
L1:
		cmp i, edx 
		JAE DONE ; i < count
			
		; j = i + 1		
		mov ebx, i
		add ebx, 1
		mov j, ebx ; j = i + 1
						
L2:			
			cmp j, edx
			JAE CONT_L1 ; j < count

			; push array[i] at ST(1)
			mov edi, i
			fld REAL8 PTR[esi + edi*8] ; get current real8 value, st(1)
			
			; push array[j] at ST(0)
			mov edi, j
			fld REAL8 PTR[esi + edi* 8] ; get next real8 value, st(0)
			
			fcomi ST(0),ST(1) ; compare array[j] with array[i]
						
			; if array[i] <= array[j] then continue
			JNB CONT_POP_L2 
			
			; if array[i] > array[j] then swap array[i] and array[j]
			
			; pop ST(0) to array[i]
			mov edi, i
			fstp REAL8 PTR[esi + edi * 8]

			; pop ST(1) to array[j]
			mov edi, j
			fstp REAL8 PTR[esi + edi * 8]

			JMP CONT_L2 ; continue without 2 fstp pop

			CONT_POP_L2: ; continue with 2 fstp pop for cleaning the 2 pushed array[j] and array[i]
				fstp dummy2
				fstp dummy1

CONT_L2:

		inc j ; j++	
		JMP L2		

CONT_L1:

		inc i ; i++		
		JMP L1
		
DONE:
		
		popad ; restore all general registers

		ret

BubbleSortListR endp

end