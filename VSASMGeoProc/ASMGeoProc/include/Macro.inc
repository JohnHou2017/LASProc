
;-------------------------
; C function macros
;-------------------------

MyPrintf MACRO formatString:REQ, printList:VARARG
	push eax
	push ecx
	INVOKE printf, formatString, printList
	pop ecx
	pop eax	
EndM

;-------------------------
; Float macros
;-------------------------

CmpReal MACRO r1:REQ, r2:REQ
	fld r1
	fcomp r2
	fnstsw ax 
	sahf 		
endm

; calculate r2 = r1
MovReal MACRO r1:REQ, r2:REQ   	
	fld r1	
	fstp r2
endm

; calculate retr = r1 + r2
AddReal MACRO r1:REQ, r2:REQ, retr:REQ    	
	fld r1
	fadd r2
	fstp retr	
endm

; calculate retr = r1 - r2
SubReal MACRO r1:REQ, r2:REQ, retr:REQ    	
	fld r1
	fsub r2
	fstp retr	
endm

; calculate retr = r1 * r2
MulReal MACRO r1:REQ, r2:REQ, retr:REQ    	
	fld r1
	fmul r2
	fstp retr	
endm

; calculate retr = r1 / r2
DivReal MACRO r1:REQ, r2:REQ, retr:REQ    	
	fld r1
	fdiv r2
	fstp retr	
endm

; calculate retr = [esi] and move esi pointer to next real8 value
GetNextEsiReal MACRO retr
	fld real8 PTR[esi]
	fstp retr
	add esi, TYPE REAL8
endm	

;----------------------------
; Integer macro
;----------------------------

; calculate r2 = i1 
MovInt MACRO i1:REQ, i2:REQ
	push ebx
	
	mov ebx i1	
	mov r2, ebx
		
	pop ebx
endm

; calculate reti = i1 + i2
AddInt MACRO i1:REQ, i2:REQ, reti:REQ    
	push ebx
	
	mov ebx, i1 + i2	
	mov reti, ebx
		
	pop ebx
endm

; calculate reti = i1 - i2
SubInt MACRO i1:REQ, i2:REQ, reti:REQ    
	push ebx
	
	mov ebx, i1	- i2	
	mov reti, ebx
		
	pop ebx
endm

; calculate reti = i1 * i2
MulInt MACRO i1:REQ, i2:REQ, reti:REQ    
	push ebx
	
	mov ebx, i1	* i2	
	mov reti, ebx
		
	pop ebx
endm

; calculate reti = i1 / i2
DivInt MACRO i1:REQ, i2:REQ, reti:REQ    
	push ebx
	
	mov ebx, i1	/ i2	
	mov reti, ebx
		
	pop ebx
endm

;----------------------
; GeoProc struct macro
;----------------------

; calculate p2 = p1
MovGeoPointM MACRO p1:REQ, p2:REQ		
	fld p1.x
	fstp p2.x
	fld p1.y
	fstp p2.y
	fld p1.z
	fstp p2.z
endm

; calculate retp = p1 - p2
SubGeoPoint MACRO p1:REQ, p2:REQ, retp:REQ	
	SubReal p1.x, p2.x, retp.x
	SubReal p1.y, p2.y, retp.y
	SubReal p1.z, p2.z, retp.z	
endm


; return GeoPoint retPoint if esi is the offset retPoint
; return GeoPoint retPoint after "invoke NewGeoPoint x, y, z"
; return GeoPoint retPoint after "mov esi, offset point"
GetGeoPoint MACRO retPoint:REQ	
	GetNextEsiReal retPoint.x
	GetNextEsiReal retPoint.y
	GetNextEsiReal retPoint.z
endm

; return GeoPoint retVector if esi is the offset retVector
; return GeoPoint retVector after "invoke NewGeoVector p0, p1"
; return GeoPoint retVector after "mov esi, offset vector"
GetGeoVector MACRO retVector:REQ
	GetGeoPoint retVector.p0
	GetGeoPoint retVector.p1
	GetNextEsiReal retVector.x
	GetNextEsiReal retVector.y
	GetNextEsiReal retVector.z
endm

; return GeoPlane retPlane if esi is the offset retPlane
; return GeoPlane retPlane after "invoke NewGeoPlaneA a, b, cc, d"
; return GeoPlane retPlane after "invoke NewGeoPlaneB p0, p1, p2"
; return GeoPlane retPlane after "invoke NegGeoPlane, pl"
; return GeoPlane retPlane after "mov esi, offset plane"
GetGeoPlane MACRO retPlane:REQ
	GetNextEsiReal retPlane.a
	GetNextEsiReal retPlane.b
	GetNextEsiReal retPlane.cc
	GetNextEsiReal retPlane.d
endm

; load minimum and maximum value to FPU ST from tempListR after tempListR is sorted
; tempListR is a ListR varaible
; n is length of tempListR
; this macro loads 2 real8 to st, general registers keep unchanged
LoadListRFirstLast MACRO tempListR:REQ, n:REQ
	push esi
	push ebx

	mov esi, offset tempListR
	mov esi, (ListR PTR [esi]).p
	fld (REAL8 PTR[esi]) ; load first value in tempListR
	mov ebx, n
	dec ebx
	imul ebx, TYPE REAL8
	add esi, ebx ; esi = esi + 8 * (n-1)
	fld (REAL8 PTR[esi]) ; load last value in tempListR

	pop ebx
	pop esi
endm
	
; retv += abs(val)
AddAbsR MACRO val:REQ, retv:REQ
	fld val
	fabs
	fadd retv	
	fstp retv
endm

; get GeoPoint from GeoPoint array address and index
GetGeoPointAtIndex MACRO firstAddr:REQ, idx:REQ, retv:REQ
	push esi
	push ebx
		
	mov ebx, idx
	imul ebx, TYPE GeoPoint	

	mov esi, firstAddr
	add esi, ebx
	
	INVOKE NewGeoPoint, (GeoPoint PTR [esi]).x, (GeoPoint PTR [esi]).y, (GeoPoint PTR [esi]).z

	GetGeoPoint retv

	pop ebx
	pop esi
endm