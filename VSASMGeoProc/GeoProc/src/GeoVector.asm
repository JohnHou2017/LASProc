.686p
.model flat, c ; use c calling convention 

include GeoVector.inc
include Macro.inc

.data

; Return values of procedures
newVector GeoVector <>
mulVector GeoVector <>
	
.code

; New a vector
; Receives: p0, p1
; Returns: esi = address of newVector
NewGeoVector proc,
	p0: GeoPoint, 	
	p1: GeoPoint			
	
	MovGeoPointM p0, newVector.p0
	MovGeoPointM p1, newVector.p1
	SubReal p1.x, p0.x, newVector.x  
	SubReal p1.y, p0.y, newVector.y
	SubReal p1.z, p0.z, newVector.z
				
	; return newVector
	mov esi, offset newVector
	
	ret
NewGeoVector endp

;Multiple 2 vectors, cross product = u * v
;Receives: u, v
;Returns: esi = address of mulVector
MulGeoVector proc,
	u: GeoVector,
 	v: GeoVector

	local r1, r2 : real8
	local pt : GeoPoint
	
	; calculate mulVector.x = u.y * v.z - u.z * v.y	
	MulReal u.y, v.z, r1
	MulReal u.z, v.y, r2
	SubReal r1, r2, mulVector.x
	
	; calculate mulVector.y = u.z * v.x - u.x * v.z	
	MulReal u.z, v.x, r1
	MulReal u.x, v.z, r2
	SubReal r1, r2, mulVector.y

	; calculate mulVector.z = u.x * v.y - u.y * v.x	
	MulReal u.x, v.y, r1
	MulReal u.y, v.x, r2
	SubReal r1, r2, mulVector.z
	
	; calculate mulVector.p0 = u.p0
	MovGeoPointM u.p0, mulVector.p0
		
	; calculate mulVector.p1 = u.p0 + GeoPoint(mulVector.x, mulVector.y, mulVector.z)
	MovGeoPointM mulVector, pt
	
	invoke AddGeoPoint, u.p0, pt	

	GetGeoPoint mulVector.p1
			
	; return mulVector
	mov esi, offset mulVector
	
	ret
MulGeoVector endp

end