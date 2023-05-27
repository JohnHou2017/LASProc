.686p
.model flat, c ; use c calling convention 

include GeoPolygon.inc

.data

newPolygon GeoPolygon <?,?>

.code

; return a new polygon address in eax
NewGeoPolygon proc uses esi ebx,
ptsAddr: PTR GeoPoint, ; offset address of vertices array
ptsCount: DWORD, ; number of vertices
				 
	local oriAddr, destAddr, byteCount : DWORD

	; get original address to free
	mov esi, offset newPolygon
	mov ebx, [esi]
	mov oriAddr, ebx

	invoke calloc, ptsCount, TYPE GeoPoint ; return new memory address in eax

	mov destAddr, eax

	mov esi, offset newPolygon
	mov [esi], eax	; bind newPolygon.ptsAddr to new address

	; get byte count to copy
	mov ebx, ptsCount
	imul ebx, TYPE GeoPoint
	mov byteCount, ebx

	; copy to new address
	invoke memmove, destAddr, ptsAddr, byteCount

	mov ebx, ptsCount				
	mov (GeoPolygon PTR newPolygon).n, ebx

	; try to free original memory
	mov ebx, oriAddr
	cmp ebx, destAddr
	JE SKIP_FREE ; if destAddr == oriAddr

	mov ebx, oriAddr
	cmp ebx, 0
	JE SKIP_FREE ; if oriAddr == 0

	invoke free, oriAddr

SKIP_FREE:

	; return newPolygon address
	mov eax, offset newPolygon

	ret
NewGeoPolygon endp	

end