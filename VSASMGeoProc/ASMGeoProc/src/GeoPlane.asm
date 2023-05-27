.686p
.model flat, c ; use c calling convention 

include GeoPlane.inc
include Macro.inc
include GeoPoint.inc
include GeoVector.inc

.data

; Return values of procedures
newPlaneA GeoPlane <?>
newPlaneB GeoPlane <?>
negPlane GeoPlane <?>
mulPlaneVal REAL8 ?

; global variables
minusOne REAL8 -1.0

.code

; New a plane
; Receives: a, b, cc, d
; Returns: esi = address of newPlaneA
NewGeoPlaneA proc,
	a: REAL8,
 	b: REAL8,
	cc: REAL8,
	d: REAL8
	
	fld d
	fld cc
	fld b
	fld a
	fstp newPlaneA.a
	fstp newPlaneA.b
	fstp newPlaneA.cc
	fstp newPlaneA.d
	
	; return newPlaneA
	mov esi, offset newPlaneA
	
	ret
NewGeoPlaneA endp

; New a newPlaneB
; Receives: a, b, cc, d
; Returns: esi = address of newPlaneB
NewGeoPlaneB proc,
	p0: GeoPoint,
 	p1: GeoPoint,
	p2: GeoPoint
	
	local r1, r2, r3 : REAL8	
	local u : GeoVector
	local v : GeoVector
	local n : GeoVector	
		
	; u = GeoVector(p0, p1)			
	invoke NewGeoVector, p0, p1	
	GetGeoVector u
		
	; v = GeoVector(p0, p2)		
	invoke NewGeoVector, p0, p2
	GetGeoVector v
		
	; normal vector n = u * v	
	invoke MulGeoVector, u, v
	GetGeoVector n
		
	; get newPlaneB.a, newPlaneB.b, newPlaneB.cc
	fld n.z
	fld n.y
	fld n.x
	fstp newPlaneB.a
	fstp newPlaneB.b
	fstp newPlaneB.cc
	
	; calculate newPlaneB.d = - (newPlaneB.a * p0.x + newPlaneB.b * p0.y + newPlaneB.cc * p0.z)
	
	MulReal newPlaneB.a, p0.x, r1
	MulReal newPlaneB.b, p0.y, r2
	MulReal newPlaneB.cc, p0.z, r3

	fld r1
	fadd r2
	fadd r3
	fmul minusOne
	fstp newPlaneB.d
						
	; return newPlaneB
	mov esi, offset newPlaneB
	
	ret
NewGeoPlaneB endp

; Negtive a newPlaneB
; Receives: pl
; Returns: esi = address of negPlane
NegGeoPlane proc,
 	pl: GeoPlane
					
	MulReal pl.a, minusOne, negPlane.a
	MulReal pl.b, minusOne, negPlane.b
	MulReal pl.cc, minusOne, negPlane.cc
	MulReal pl.d, minusOne, negPlane.d
	
	; return negPlane
	mov esi, offset negPlane
	
	ret
NegGeoPlane endp
	
; Negtive a newPlaneB
; Receives: pl
; Returns: eax = address of mulPlane
MulGeoPlane proc,
 	pl: GeoPlane,
 	pt: GeoPoint
	
	local r1, r2, r3 : REAL8	
	
	; calculate return value = pt.x * pl.a + pt.y * pl.b + pt.z * pl.cc + pl.d	
	MulReal pt.x, pl.a, r1
	MulReal pt.y, pl.b, r2
	MulReal pt.z, pl.cc, r3

	fld r1
	fadd r2
	fadd r3
	fadd pl.d
	fstp mulPlaneVal		
	
	; return mulPlane
	mov eax, offset mulPlaneVal
	
	ret
MulGeoPlane endp

end