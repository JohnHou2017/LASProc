.686p
.model flat, c ; use c calling convention 

include ListGeoProc.inc
include GeoPlane.inc
include GeoFace.inc

GetListFaceSize PROTO,
list : PTR ListFace

.code 

; push a GeoPoint into a list, return List member p new memory address in eax
PushPoint proc uses ebx esi,
list : PTR ListPoint, 
element : GeoPoint
	
	local endPos, newSize : DWORD	
	local count : DWORD
	
	mov esi, list
	
	; check if list.n is 0
	cmp (ListPoint PTR [esi]).n, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.n is 0
	invoke calloc, 1, TYPE GeoPoint ; return allocated memory pointer in eax
	mov (ListPoint PTR [esi]).p, eax ; initialize list.p
	mov (ListPoint PTR [esi]).n, 0 ; initialize list.n

NOT_NULL:

	mov esi, list
	mov ebx, (ListPoint PTR [esi]).n
	cmp ebx, 0
	JNE NOT_BLANK

	mov esi, list
	mov ebx, (ListPoint PTR [esi]).p
	invoke memmove, ebx, ADDR element, TYPE GeoPoint

	mov ebx, 1
	mov (ListPoint PTR [esi]).n, ebx

	JMP DONE

NOT_BLANK:
	; get new size in bytes
	mov esi, list ; address value of the ListR object
	mov ebx, (ListPoint PTR [esi]).n ; [esi] is the value in esi address, which is the beginning address of ListR member p
	mov count, ebx ; original count of elements
	imul ebx, TYPE GeoPoint ; convert to bytes count
	mov endPos, ebx ; save original last element position
	add ebx, TYPE GeoPoint ; get new bytes length for realloc
	mov newSize, ebx
	
	; realloc to new bytes size for ListR member p, its new pointer address is in eax	
	mov esi, list
	mov ebx, (ListPoint PTR [esi]).p

	; realloc will free the original memory if the new memory is different
	invoke realloc, ebx, newSize
	
	; set to new memory location
	mov (ListPoint PTR [esi]).p, eax

	; append new element after endPos
	mov ebx, (ListPoint PTR [esi]).p
	add ebx, endPos
	invoke memmove, ebx, ADDR element, TYPE GeoPoint
	
	; set new count
	mov esi, list ; get original list address from its pointer
	mov ebx, count ; original count of elements
	inc ebx ; get new count of elements
	mov (ListPoint PTR [esi]).n, ebx ; set new count of list to ListR member n
				
DONE:

	ret
PushPoint endp

; push a GeoPlane into a list, return List member p new memory address in eax
PushPlane proc uses ebx esi,
list : PTR ListPlane, 
element : GeoPlane
	
	local endPos, newSize : DWORD	
	local count : DWORD
	
	mov esi, list
	
	; check if list.n is 0
	cmp (ListPlane PTR [esi]).n, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.n is 0
	invoke calloc, 1, TYPE GeoPlane ; return allocated memory pointer in eax
	mov (ListPlane PTR [esi]).p, eax ; initialize list.p
	mov (ListPlane PTR [esi]).n, 0 ; initialize list.n

NOT_NULL:

	mov esi, list
	mov ebx, (ListPlane PTR [esi]).n
	cmp ebx, 0
	JNE NOT_BLANK

	mov esi, list
	mov ebx, (ListPlane PTR [esi]).p
	invoke memmove, ebx, ADDR element, TYPE GeoPlane

	mov ebx, 1
	mov (ListPlane PTR [esi]).n, ebx

	JMP DONE

NOT_BLANK:
	; get new size in bytes
	mov esi, list ; address value of the ListR object
	mov ebx, (ListPlane PTR [esi]).n ; [esi] is the value in esi address, which is the beginning address of ListR member p
	mov count, ebx ; original count of elements
	imul ebx, TYPE GeoPlane ; convert to bytes count
	mov endPos, ebx ; save original last element position
	add ebx, TYPE GeoPlane ; get new bytes length for realloc
	mov newSize, ebx
	
	; realloc to new bytes size for ListR member p, its new pointer address is in eax	
	mov esi, list
	mov ebx, (ListPlane PTR [esi]).p

	; realloc will free the original memory if the new memory is different
	invoke realloc, ebx, newSize
	
	; set to new memory location
	mov (ListPlane PTR [esi]).p, eax

	; append new element after endPos
	mov ebx, (ListPlane PTR [esi]).p
	add ebx, endPos
	invoke memmove, ebx, ADDR element, TYPE GeoPlane
	
	; set new count
	mov esi, list ; get original list address from its pointer
	mov ebx, count ; original count of elements
	inc ebx ; get new count of elements
	mov (ListPlane PTR [esi]).n, ebx ; set new count of list to ListR member n
				
DONE:

	ret
PushPlane endp

; push a GeoFace into a list, return List member p new memory address in eax
PushFace proc uses ebx edx eax esi,
list : PTR ListFace, 
element : PTR GeoFace

	local numberOfPoints : DWORD ; new element GeoFace.n
	local ptsAddr, idxAddr : DWORD ; new element head address for GeoFace.ptsAddr and GeoFace.idxAddr
	local ptsSize, idxSize: DWORD ; new element size			
	local newGeoFaceAddr : DWORD ; new GeoFace address to copy to
	
	mov esi, list
	
	; check if list.n is 0
	cmp (ListFace PTR [esi]).n, 0

	JNE NOT_NULL ; skip list.p initialization if list.p is not null

	; initialize list.p and list.n if list.n is 0
	invoke calloc, 1, TYPE ListFace ; return allocated memory pointer in eax
	mov (ListFace PTR [esi]).p, eax ; initialize list.p
	mov (ListFace PTR [esi]).n, 0 ; initialize list.n
	invoke calloc, 1, TYPE GeoFace ; alloc memory for (ListFace PTR [esi]).p to make it a valid pointer
	mov esi, list
	mov (ListFace PTR [esi]).p, eax

NOT_NULL:

	; prepare element info for both first time push and further push

	; get element ptsAddr
	mov esi, element
	mov ebx, (GeoFace PTR [esi]).ptsAddr
	mov ptsAddr, ebx

	; get element idxAddr
	mov esi, element
	mov ebx, (GeoFace PTR [esi]).idxAddr
	mov idxAddr, ebx

	; get element numberOfPoints
	mov esi, element
	mov ebx, (GeoFace PTR [esi]).n
	mov numberOfPoints, ebx

	; get ptsSize
	mov ebx, numberOfPoints
	imul ebx, TYPE GeoPoint
	mov ptsSize, ebx

	; get idxSize
	mov ebx, numberOfPoints
	imul ebx, TYPE DWORD
	mov idxSize, ebx

	; check if it is first time push

	mov esi, list
	mov ebx, (ListFace PTR [esi]).n
	cmp ebx, 0

	JNE NOT_BLANK ; Not first time push

	; First time push

	; alloc memory and copy ptsAddr	
	invoke calloc, numberOfPoints, TYPE GeoPoint
	mov esi, list
	mov esi, (ListFace PTR [esi]).p
	mov (GeoFace PTR [esi]).ptsAddr, eax
	invoke memmove, (GeoFace PTR [esi]).ptsAddr, ptsAddr, ptsSize

	; alloc memory and copy idxAddr	
	invoke calloc, numberOfPoints, TYPE DWORD
	mov esi, list
	mov esi, (ListFace PTR [esi]).p	
	mov (GeoFace PTR [esi]).idxAddr, eax
	invoke memmove, (GeoFace PTR [esi]).idxAddr, idxAddr, idxSize

	; set ListFace.n	
	mov esi, list
	mov (ListFace PTR [esi]).n, 1
	
	; set ListFace.GeoFace.n
	mov esi, list
	mov esi, (ListFace PTR [esi]).p	
	mov ebx, numberOfPoints
	mov (GeoFace PTR [esi]).n, ebx

	JMP DONE

NOT_BLANK: ; further push

	; increase count of GeoFace in ListFace firstly
	mov esi, list	
	inc (ListFace PTR [esi]).n

	; increase len(list->p) to (len(list->p) + TYPE GeoFace)
	mov esi, list	
	mov ebx, (ListFace PTR [esi]).p ; list->p
	mov edx, (ListFace PTR [esi]).n ; new count
	imul edx, TYPE GeoFace ; GeoFace each member length	
	invoke realloc, ebx, edx ; return new memory in eax
	mov esi, list		
	mov (ListFace PTR [esi]).p, eax ; set list->p to new address to hold one more GeoFace

	; get new GeoFace address in list
	mov esi, list	
	mov ebx, (ListFace PTR [esi]).n
	dec ebx ; original count
	imul ebx, TYPE GeoFace ; original length
	add ebx, (ListFace PTR [esi]).p ; add first GeoFace pointer address 
	mov newGeoFaceAddr, ebx ; PTR GeoFace, where to copy new element

	; allocate GeoFace.ptsAddr for newGeoFaceAddr
	invoke calloc, 1, TYPE DWORD
	mov esi, newGeoFaceAddr
	mov (GeoFace PTR [esi]).ptsAddr, eax ; where to copy element.ptsAddr

	; allocate GeoFace.idxAddr for newGeoFaceAddr
	invoke calloc, 1, TYPE DWORD
	mov esi, newGeoFaceAddr
	mov (GeoFace PTR [esi]).idxAddr, eax ; where to copy element.idxAddr

	; set new GeoFace.n firstly
	mov esi, newGeoFaceAddr
	mov ebx, numberOfPoints
	mov (GeoFace PTR [esi]).n, ebx

	; list memory is ready to copy over element.ptsAddr and element.idxAddr now

	mov esi, newGeoFaceAddr
	invoke malloc, ptsSize
	mov (GeoFace PTR [esi]).ptsAddr, eax
	invoke memmove, (GeoFace PTR [esi]).ptsAddr, ptsAddr, ptsSize

	mov esi, newGeoFaceAddr
	invoke malloc, idxSize
	mov (GeoFace PTR [esi]).idxAddr, eax
	invoke memmove, (GeoFace PTR [esi]).idxAddr, idxAddr, idxSize
			
DONE:

	ret

PushFace endp

InitListPoint proc uses esi eax,
list : PTR ListPoint

	mov esi, list

	; check if list.p is null via esi
	cmp (ListPoint PTR [esi]).p, 0

	JE SKIP_FREE 

	INVOKE free, (ListPoint PTR [esi]).p

SKIP_FREE:

	; initialize list.p and list.n 
	invoke calloc, 0, TYPE DWORD ; return allocated memory pointer in eax
	mov (ListPoint PTR [esi]).p, eax ; initialize list.p
	mov (ListPoint PTR [esi]).n, 0 ; initialize list.n

	ret
InitListPoint endp

; get sum(ListFace->p->ptsAddr->n) 
GetListFaceSize proc uses ebx esi,
list : PTR ListFace
local headAddr, count : DWORD	

	mov esi, list ; ListFace	
	mov ebx, (ListFace PTR [esi]).p ; head PGeoFace address of the list	
	mov headAddr, ebx
	
	mov count, 0
	mov ecx, (ListFace PTR [esi]).n ; loop each pGeoFace in the list, interval of each pGeoFace is (TYPE GeoFace)		
L1:	
	mov esi, headAddr
	mov ebx, (GeoFace PTR [esi]).n ; get current GeoFace.n	
	add count, ebx ; add n
	add headAddr, TYPE GeoFace ; move to next pGeoFace
	LOOP L1

	; return total count of GeoFace.n for current list in eax
	mov eax, count	

	ret
GetListFaceSize endp

end