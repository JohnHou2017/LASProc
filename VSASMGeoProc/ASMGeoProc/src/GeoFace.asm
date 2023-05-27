.686p
.model flat, c ; use c calling convention 

include GeoFace.inc

.data

newFace GeoFace <?,?,?>

.code

; return a face address in eax
NewGeoFace proc uses edi esi ebx,
ptsAddr: PGeoPoint, ; GeoFace vertices array address
idxAddr: PDWORD,
ptsCount: DWORD ; GeoFace array size

	local oriAddr, destPtsAddr, destIdxAddr, ptsByteCount, idxByteCount : DWORD

	; get original address to free
	mov esi, offset newFace
	mov ebx, [esi]
	mov oriAddr, ebx

	; allocate memory for newFace.ptsAddr
	invoke calloc, ptsCount, TYPE GeoPoint ; return new memory address in eax
	mov destPtsAddr, eax ; save new memory address

	mov esi, offset newFace
	mov [esi], eax ; bind newFace.ptsAddr to new address
	
	; allocate memory for newFace.idxAddr
	invoke calloc, ptsCount, TYPE DWORD ; return new memory address in eax
	test eax, eax
	jz CALLOC_FAIL_IDX
	mov destIdxAddr, eax ; save new memory address

	mov esi, offset newFace
	add esi, TYPE DWORD ; move to idxAddr struct member address
	mov [esi], eax	; bind newFace.idxAddr to new address

	; get ptsAddr bytes count to copy
	mov ebx, ptsCount
	imul ebx, TYPE GeoPoint
	mov ptsByteCount, ebx

	; get idxAddr bytes count to copy
	mov ebx, ptsCount
	imul ebx, TYPE DWORD
	mov idxByteCount, ebx

	; copy to new address
	invoke memmove, destPtsAddr, ptsAddr, ptsByteCount
	invoke memmove, destIdxAddr, idxAddr, idxByteCount

	; set newFace.n
	mov ebx, ptsCount				
	mov (GeoFace PTR newFace).n, ebx

	; try to free original memory
	mov ebx, oriAddr
	cmp ebx, destPtsAddr
	JE SKIP_FREE ; if destAddr == oriAddr

	mov ebx, oriAddr
	cmp ebx, 0
	JE SKIP_FREE ; if oriAddr == 0

	invoke free, oriAddr

	JMP SKIP_FREE



SKIP_FREE:

	; return newFace address
	mov eax, offset newFace

	JMP DONE

CALLOC_FAIL_IDX:
	mov eax, 0

DONE:
	ret

NewGeoFace endp	

end