.686p

.model flat, c ; use c calling convention 

include Macro.inc
include GeoPoint.inc
include GeoVector.inc
include GeoPlane.inc
include GeoPolygon.inc
include GeoFace.inc
include GeoPolygonProc.inc

ListTest PROTO

.stack 4096

.data

FmtStr BYTE "%s", 0Ah,0
FmtInt BYTE "%d", 0Ah,0
FmtF BYTE "%15.6f", 0AH, 0
FmtSI BYTE "%s%d", 0Ah,0
FmtSF BYTE "%s%15.6f", 0Ah,0
FmtII BYTE "%d, %d", 0AH, 0
FmtFF BYTE "%15.6f, %15.6f", 0AH, 0
FmtIII BYTE "%d, %d, %d", 0AH, 0
FmtFFF BYTE "%15.6f, %15.6f, %15.6f", 0AH, 0
FmtFFFF BYTE "%15.6f, %15.6f, %15.6f, %15.6f", 0AH, 0
FmtIFFF BYTE "%d : (%15.6f, %15.6f, %15.6f)", 0AH, 0
FmtIIII BYTE "%d, %d, %d, %d", 0AH, 0

strGeoPointTitle  BYTE "GeoPoint Test:", 0
strGeoVectorTitle  BYTE "GeoVector Test:", 0
strGeoPlaneTitle  BYTE "GeoPlane Test:", 0
strGeoPolygonTitle  BYTE "GeoPolygon Test:", 0
strGeoFaceTitle  BYTE "GeoFace Test:", 0
strGeoPolygonProcTitle  BYTE "GeoPolygonProc Test:", 0
strGeoPolygonProcFacePlanes  BYTE "Face Planes: ", 0
strGeoPolygonProcFaces  BYTE "Faces:", 0
strGeoPolygonProcFace  BYTE "Faces #", 0

; 8 polygon vertices
vtsArr GeoPoint \	
	<-27.28046,  37.11775,  -39.03485>, \
	<-44.40014,  38.50727,  -28.78860>, \
	<-49.63065,  20.24757,  -35.05160>, \
	<-32.51096,  18.85805,  -45.29785>, \
	<-23.59142,  10.81737,  -29.30445>, \
	<-18.36091,  29.07707,  -23.04144>, \
	<-35.48060,  30.46659,  -12.79519>, \
	<-40.71110,  12.20689,  -19.05819> 

p1 GeoPoint <-27.28046,  37.11775,  -39.03485>
p2 GeoPoint <-44.40014,  38.50727,  -28.78860>
p3 GeoPoint <-49.63065,  20.24757,  -35.05160>
p4 GeoPoint <-32.51096,  18.85805,  -45.29785>
p5 GeoPoint <-23.59142,  10.81737,  -29.30445>
p6 GeoPoint <-18.36091,  29.07707,  -23.04144>
p7 GeoPoint <-35.48060,  30.46659,  -12.79519>
p8 GeoPoint <-40.71110,  12.20689,  -19.05819>

ptInside  GeoPoint <-28.411750, 25.794500, -37.969000>
ptOutside GeoPoint <-28.411750, 25.794500, -50.969000>

pl GeoPlane <1.0, 2.0, 3.0, 4.0>
pt GeoPoint <1.0, 2.0, 3.0>

pPolygon PGeoPolygon ? ; GeoPolygon *pPolygon

pFace PGeoFace ? ; GeoFace *pFace

faceIdxArr DWORD 1, 2, 3, 5, 6, 7

pPolygonProc PGeoPolygonProc ? ; GeoPolygonProc *pPolygonProc

i DWORD 0

.code

main PROC
	
	call ListTest		
	call GeoPointTest
	call GeoVectorTest
call GeoPlaneTest
	call GeoPolygonTest
	call GeoFaceTest	
	call GeoPolygonProcTest
	
	ret
		
main ENDP

GeoPointTest proc
	
	local pt1 : GeoPoint
	local pt2 : GeoPoint
	local pt3 : GeoPoint

	invoke NewGeoPoint, p1.x, p1.y, p1.z

	GetGeoPoint pt1

	invoke NewGeoPoint, p2.x, p2.y, p2.z

	GetGeoPoint pt2
					
	invoke AddGeoPoint, pt1, pt2	

	GetGeoPoint pt3
	
	; print title
	
	MyPrintf offset FmtStr, ADDR strGeoPointTitle
	
	; print first point	
	MyPrintf offset FmtFFF, pt1.x, pt1.y, pt1.z
	; print second point
	MyPrintf offset FmtFFF, pt2.x, pt2.y, pt2.z
	; print third sum point 
	MyPrintf offset FmtFFF, pt3.x, pt3.y, pt3.z

	ret
GeoPointTest endp

GeoVectorTest proc,

	local pt0 : GeoPoint
	local pt1 : GeoPoint
	local pt2 : GeoPoint

	local u : GeoVector
	local v : GeoVector
	local n : GeoVector

	mov esi, offset vtsArr

	GetGeoPoint pt0
	GetGeoPoint pt1
	GetGeoPoint pt2
	
	invoke NewGeoVector, pt0, pt2

	GetGeoVector u

	invoke NewGeoVector, pt0, pt1
	
	GetGeoVector v
	
	invoke MulGeoVector, u, v

	GetGeoVector n
	
	; print title
	MyPrintf offset FmtStr, ADDR strGeoVectorTitle
	
	; print first vector u component
	MyPrintf offset FmtFFF, u.x, u.y, u.z
	; print second vector v component
	MyPrintf offset FmtFFF, v.x, v.y, v.z
	; print normal vector n component
	MyPrintf offset FmtFFF, n.x, n.y, n.z

	ret
GeoVectorTest endp

GeoPlaneTest proc,

	local plA : GeoPlane
	local plB : Geoplane
	local negpl : GeoPlane	
	local dis : REAL8
	
	invoke NewGeoPlaneB, p1, p2, p3

	GetGeoPlane plB

	invoke NewGeoPlaneA, pl.a, pl.b, pl.cc, pl.d

	GetGeoPlane plA

	invoke NegGeoPlane, plA
	
	GetGeoPlane negpl	
			
	invoke MulGeoPlane, pl, pt

	mov esi, eax
	fld REAL8 PTR[esi]
	fstp dis

	; print title
	MyPrintf offset FmtStr, ADDR strGeoPlaneTitle

	; print first plane
	MyPrintf offset FmtFFFF, plB.a, plB.b, plB.cc, plB.d
	; print second plane
	MyPrintf offset FmtFFFF, plA.a, plA.b, plA.cc, plA.d
	; print negative plane
	MyPrintf offset FmtFFFF, negpl.a, negpl.b, negpl.cc, negpl.d

	; print multiple result
	MyPrintf offset FmtF, dis

	ret
GeoPlaneTest endp

GeoPolygonTest proc uses edi ecx eax ebx,
	
	local count : DWORD
	
	mov eax, LENGTHOF vtsArr	
	mov count, eax
	
	; printf uses eax, must be called before NewGeoPolygon
	MyPrintf offset FmtStr, ADDR strGeoPolygonTitle

	invoke NewGeoPolygon, ADDR vtsArr, count ; return in eax
		
	mov pPolygon, eax ; save new polygon address

	mov esi, pPolygon	
	mov esi, (GeoPolygon PTR [esi]).ptsAddr	
	mov i, 1
	mov edi, 0
	mov ecx, count
	L3:		
	
		MyPrintf offset FmtIFFF, i, (GeoPoint PTR [esi]).x, (GeoPoint PTR [esi]).y, (GeoPoint PTR [esi]).z
				
		add esi, TYPE GeoPoint ; increase point offset edi with GeoPoint length		
	
		inc i
	loop L3

	mov esi, pPolygon		
	MyPrintf offset FmtInt, (GeoPolygon PTR [esi]).n

	ret
GeoPolygonTest endp

GeoFaceTest proc uses edi ecx eax edx ebx,
	
	local count, ptsAddr, idxAddr, idx : DWORD	
		
	mov eax, LENGTHOF faceIdxArr	
	mov count, eax

	; printf uses eax, must be called before NewGeoFace
	MyPrintf offset FmtStr, ADDR strGeoFaceTitle

	invoke NewGeoFace, ADDR vtsArr, ADDR faceIdxArr, count

	mov pFace, eax ; save new face address

	mov esi, pFace
	mov ebx, (GeoFace PTR [esi]).ptsAddr	
	mov ptsAddr, ebx
	mov ebx, (GeoFace PTR [esi]).idxAddr	
	mov idxAddr, ebx
		
	mov ecx, count
	L3:		
		
		mov esi, idxAddr
		mov ebx, [esi]
		mov idx, ebx

		mov esi, ptsAddr
		
		MyPrintf offset FmtIFFF, idx, (GeoPoint PTR [esi]).x, (GeoPoint PTR [esi]).y, (GeoPoint PTR [esi]).z
		
		add ptsAddr, TYPE GeoPoint ; move to next point
		add idxAddr, TYPE DWORD ; move to next point index
	
	loop L3

	mov esi, pFace
	MyPrintf offset FmtInt, (GeoFace PTR [esi]).n

	ret
GeoFaceTest endp

GeoPolygonProcTest proc uses edi ecx eax edx ebx,

	local isInside : DWORD
	local count, faceAddr, ptsAddr, idxAddr, idx : DWORD	

	invoke NewGeoPolygonProc, pPolygon
	
	mov pPolygonProc, eax
	mov esi, pPolygonProc

	MyPrintf offset FmtStr, ADDR strGeoPolygonProcTitle

	MyPrintf offset FmtFF, (GeoPolygonProc PTR [esi]).x0, (GeoPolygonProc PTR [esi]).x1
	MyPrintf offset FmtFF, (GeoPolygonProc PTR [esi]).y0, (GeoPolygonProc PTR [esi]).y1
	MyPrintf offset FmtFF, (GeoPolygonProc PTR [esi]).z0, (GeoPolygonProc PTR [esi]).z1	
	MyPrintf offset FmtF, (GeoPolygonProc PTR [esi]).minError	

	MyPrintf offset FmtSI, ADDR strGeoPolygonProcFacePlanes, (GeoPolygonProc PTR [esi]).numberOfFaces

	mov esi, pPolygonProc
	mov ecx, (GeoPolygonProc PTR [esi]).numberOfFaces
	mov esi, (GeoPolygonProc PTR [esi]).facePlanes
	mov esi, (ListPlane PTR [esi]).p
	
L1:
		
	MyPrintf offset FmtFFFF, (GeoPlane PTR [esi]).a, (GeoPlane PTR [esi]).b, (GeoPlane PTR [esi]).cc, (GeoPlane PTR [esi]).d
	
	add esi, TYPE GeoPlane
	LOOP L1

	mov esi, pPolygonProc		
	mov esi, (GeoPolygonProc PTR [esi]).faces
	mov ebx, (ListFace PTR [esi]).p
	mov faceAddr, ebx
	mov ebx, (ListFace PTR [esi]).n
	mov count, ebx
	mov i, 0
L2:
	mov edx, count
	cmp i, edx
	JAE L2_DONE ; i < count
			
	mov esi, faceAddr
	mov ebx, (GeoFace PTR [esi]).ptsAddr	
	mov ptsAddr, ebx
	mov ebx, (GeoFace PTR [esi]).idxAddr	
	mov idxAddr, ebx

	mov ecx, (GeoFace PTR [esi]).n

	MyPrintf offset FmtSI, ADDR strGeoPolygonProcFace, i
L3:		
		
		mov esi, idxAddr
		mov ebx, [esi]
		mov idx, ebx

		mov esi, ptsAddr
		
		MyPrintf offset FmtIFFF, idx, (GeoPoint PTR [esi]).x, (GeoPoint PTR [esi]).y, (GeoPoint PTR [esi]).z
		
		add ptsAddr, TYPE GeoPoint ; move to next point
		add idxAddr, TYPE DWORD ; move to next point index
	
	loop L3	

	add faceAddr, TYPE GeoFace

	inc i
	JMP L2
L2_DONE:
	
	INVOKE PointInside3DPolygon, ptInside.x, ptInside.y, ptInside.z

	mov isInside, eax
	MyPrintf offset FmtInt, isInside

	INVOKE PointInside3DPolygon, ptOutside.x, ptOutside.y, ptOutside.z

	mov isInside, eax
	MyPrintf offset FmtInt, isInside

	ret
GeoPolygonProcTest endp

end