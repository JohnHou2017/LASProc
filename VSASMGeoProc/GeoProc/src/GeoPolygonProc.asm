.686p
.model flat, c ; use c calling convention 

include GeoPolygonProc.inc

.data

newPolygonProc GeoPolygonProc <?>

pPolygon PGeoPolygon ?

tempListR1 ListR <?>
tempListR2 ListR <?>
tempListR3 ListR <?>

MaxUnitMeasureError REAL8 0.001;

tempCR1 REAL8 6.0

tempR1 REAL8 0.0

faceVerticeIndex List2DI <?>

pointInSamePlaneIndex ListI <?>

faceVerticeIndexInOneFace ListI <?>

faceIdxListI ListI <?>
facePtsListPoint ListPoint <?>

.code

InitGeoPolygonProc proc uses esi,

	invoke calloc, 1, TYPE DWORD
	mov esi, offset newPolygonProc
	mov (GeoPolygonProc PTR [esi]).facePlanes, eax

	invoke calloc, 1, TYPE DWORD
	mov esi, offset newPolygonProc
	mov esi, (GeoPolygonProc PTR [esi]).facePlanes
	mov (ListPlane PTR [esi]).p, eax
	mov (ListPlane PTR [esi]).n, 0
	
	invoke calloc, 1, TYPE DWORD
	mov esi, offset newPolygonProc
	mov (GeoPolygonProc PTR [esi]).faces, eax

	invoke calloc, 1, TYPE DWORD
	mov esi, offset newPolygonProc
	mov esi, (GeoPolygonProc PTR [esi]).faces
	mov (ListFace PTR [esi]).p, eax
	mov (ListFace PTR [esi]).n, 0

	ret
InitGeoPolygonProc endp

; return a new polygon proc address in eax
NewGeoPolygonProc proc uses esi ebx,
pPolygonIn: PGeoPolygon ; GeoPolygon pointer

	call InitGeoPolygonProc

	; save polygon in global varaible pPolygon
	mov ebx, pPolygonIn
	mov pPolygon, ebx
		  
	; set newPolygonProc with pPolygon
	call SetBoundary		  
	call SetMinError		  
	call SetFacePlanes

	; return newPolygonProc address in eax
	mov eax, offset newPolygonProc

	ret
NewGeoPolygonProc endp	 

SetBoundary proc uses ebx esi,

	local n : DWORD

	; get n
	mov esi, pPolygon
	mov ebx, (GeoPolygon PTR [esi]).n
	mov n, ebx

	; move esi to ptsAddr beginning address
	mov esi, (GeoPolygon PTR [esi]).ptsAddr 

	mov ecx, n ; set loop counter
L1:
	INVOKE PushR, ADDR tempListR1, (GeoPoint PTR [esi]).x
	INVOKE PushR, ADDR tempListR2, (GeoPoint PTR [esi]).y
	INVOKE PushR, ADDR tempListR3, (GeoPoint PTR [esi]).z
	add esi, TYPE GeoPoint ; move to next point
LOOP L1
	
	INVOKE BubbleSortListR, ADDR tempListR1
	INVOKE BubbleSortListR, ADDR tempListR2
	INVOKE BubbleSortListR, ADDR tempListR3
	
	mov esi, offset newPolygonProc ; reset esi

	; x0 = tempListR1[0], x1=tempListR[n-1]
	LoadListRFirstLast tempListR1, n ; use esi
	fstp (GeoPolygonProc PTR [esi]).x1
	fstp (GeoPolygonProc PTR [esi]).x0

	; y0 = tempListR2[0], y1=tempListR2[n-1]
	LoadListRFirstLast tempListR2, n
	fstp (GeoPolygonProc PTR [esi]).y1
	fstp (GeoPolygonProc PTR [esi]).y0

	; z0 = tempListR1[0], z1=tempListR[n-1]
	LoadListRFirstLast tempListR3, n
	fstp (GeoPolygonProc PTR [esi]).z1
	fstp (GeoPolygonProc PTR [esi]).z0
	
	ret		
SetBoundary endp

SetMinError proc,

	mov esi, offset newPolygonProc	

	fld (GeoPolygonProc PTR [esi]).x0
	fabs
	fstp tempR1

	AddAbsR (GeoPolygonProc PTR [esi]).x1, tempR1
	AddAbsR (GeoPolygonProc PTR [esi]).y0, tempR1
	AddAbsR (GeoPolygonProc PTR [esi]).y1, tempR1
	AddAbsR (GeoPolygonProc PTR [esi]).z0, tempR1
	AddAbsR (GeoPolygonProc PTR [esi]).z1, tempR1
	
	fld tempR1
	fmul MaxUnitMeasureError
	fdiv tempCR1 ; sum(abs(6 boundary))/6.0 * fmul MaxUnitMeasureError
	
	; set minError
	mov esi, offset newPolygonProc	
	fstp (GeoPolygonProc PTR [esi]).minError

	ret
SetMinError endp

SetFacePlanes proc uses ebx edx eax esi,

	local numberOfVertices : DWORD ; number of vertices in the polygon
	local verticesAddr : DWORD ; polygon vertices	
	local i, j, k, l, p, m, inLeftCount, inRightCount : DWORD
	local numberOfFaces : DWORD 
	local p0 : GeoPoint
	local p1 : GeoPoint
	local p2 : GeoPoint
	local pt : GeoPoint
	local trianglePlane : GeoPlane
	local negTrianglePlane : GeoPlane
	local dis : REAL8
	local absDis : REAL8	
	local minError : REAL8	
	local tempi, count, idx : DWORD
	local pFace : PGeoFace
	
	; initialize numberOfFaces
	mov numberOfFaces, 0

	; get minError
	mov esi, offset newPolygonProc
	fld (GeoPolygonProc PTR [esi]).minError 
	fstp minError

	; get numberOfVertices
	mov esi, pPolygon
	mov ebx, (GeoPolygon PTR [esi]).n
	mov numberOfVertices, ebx
	
	; move esi to ptsAddr beginning address
	mov ebx, (GeoPolygon PTR [esi]).ptsAddr 
	mov verticesAddr, ebx

	mov i, 0
	mov edx, numberOfVertices ; save n to edx for compairing with loop counter 
L1:	
	mov edx, numberOfVertices
	cmp i, edx 
	JAE L1_DONE ; i < numberOfVertices
	
	; get p0
	GetGeoPointAtIndex verticesAddr, i, p0
	
	mov ebx, i
	inc ebx
	mov j, ebx ; j = i + 1
L2:
	mov edx, numberOfVertices
	cmp j, edx
	JAE L2_DONE ; j < numberOfVertices

	; get p1
	GetGeoPointAtIndex verticesAddr, j, p1

	mov ebx, j
	inc ebx
	mov k, ebx ; k = j + 1
L3:
	mov edx, numberOfVertices
	cmp k, edx
	JAE L3_DONE ; k < numberOfVertices

	; get p2
	GetGeoPointAtIndex verticesAddr, k, p2

	; get trianglePlane
	INVOKE NewGeoPlaneB, p0, p1, p2	
	GetGeoPlane trianglePlane
	
	; clear pointInSamePlaneIndex
	INVOKE InitListI, ADDR pointInSamePlaneIndex

	mov inLeftCount, 0
	mov inRightCount, 0
	mov m, 0								

	mov l, 0
L4:	; calculate inLeftCount, inRightCount, pointInSamePlaneIndex, 
	mov edx, numberOfVertices
	cmp l, edx
	JAE L4_DONE ; l < numberOfVertices

	; if(l == i || l == j || l == k) then go to next L4 loop
	mov ebx, i
	cmp l, ebx
	JE NEXT_L4
	mov ebx, j
	cmp l, ebx
	JE NEXT_L4
	mov ebx, k
	cmp l, ebx
	JE NEXT_L4

	; if(l != i && l != j && l != k)
	
	; get pt	
	GetGeoPointAtIndex verticesAddr, l, pt
	
	; get dis	
	INVOKE MulGeoPlane, trianglePlane, pt ; return value dis address in eax		
	mov esi, eax 
	fld REAL8 PTR[esi] ; load return value dis in st(0)
	fstp dis 
	
	fld dis
	fabs
	fstp absDis
	
	fld absDis  
	fcomp minError 
	fnstsw ax ; move status word into AX
	sahf ; copy AH into EFLAGS
	jnb SET_LEFT_RIGHT_COUNT ; minError >= absDis then skip
	
	; if fabs(dis) < minError, it means fabs(dis) ~= 0, then add this index l to pointInSamePlaneIndex	
	INVOKE PUSHI, ADDR pointInSamePlaneIndex, l
	JMP NEXT_L4

SET_LEFT_RIGHT_COUNT:
	
	fldz ; load 0
	fcomp dis 
	fnstsw ax ; move status word into AX
	sahf ; copy AH into EFLAGS
	jb ADD_RIGHT_COUNT ; dis > 0 then add inRigthCount

	inc inLeftCount ; if dis < 0 then add inLeftCount
	JMP NEXT_L4

ADD_RIGHT_COUNT:
	inc inRightCount ; if dis > 0 then add inRightCount

NEXT_L4:

	inc l ; next L4
	JMP L4

L4_DONE:

	; if(inLeftCount == 0 || inRightCount == 0) then a face is found
	mov ebx, inLeftCount
	cmp ebx, 0
	JE FACE_FOUND
	mov ebx, inRightCount
	cmp ebx, 0
	JNE NEXT_L3

FACE_FOUND:

	; clear faceVerticeIndexInOneFace
	INVOKE InitListI, ADDR faceVerticeIndexInOneFace

	; add i, j, k to this face vertice index list
	INVOKE PUSHI, ADDR faceVerticeIndexInOneFace, i
	INVOKE PUSHI, ADDR faceVerticeIndexInOneFace, j
	INVOKE PUSHI, ADDR faceVerticeIndexInOneFace, k
		
	mov ebx, pointInSamePlaneIndex.n
	mov m, ebx
	mov p, 0
L5: ; add other vetirces in the same triangle plane
	mov ebx, m
	cmp p, ebx
	JAE L5_DONE ; p < n

	GetListIVal pointInSamePlaneIndex, p, tempi
	INVOKE PUSHI, ADDR faceVerticeIndexInOneFace, tempi

	inc p
	JMP L5

L5_DONE:

	; check if trianglePlane is a new face
	INVOKE ContainsListI, ADDR faceVerticeIndex, ADDR faceVerticeIndexInOneFace

	cmp eax, TRUE
	JE NEXT_L3 ; if faceVerticeIndex already contains faceVerticeIndexInOneFace, it is not a new face

;NEW_FACE:

	; it is a new face, increase numberOfFaces
	inc numberOfFaces 

	; add new face vertice index
	INVOKE Push2DI, ADDR faceVerticeIndex, ADDR faceVerticeIndexInOneFace

	; check if inRightCount is 0
	mov ebx, inRightCount
	cmp ebx, 0
	JNE CHECK_LEFT

	; if(onRightCount == 0) then add new face plane trianglePlane
	
	;-------------------------------------------------------
	; set up GeoPolygonProc.facePlanes
	mov esi, offset newPolygonProc
	INVOKE PushPlane, (GeoPolygonProc PTR [esi]).facePlanes, trianglePlane
	;-------------------------------------------------------

	JMP NEXT_L3
	
CHECK_LEFT: ; if(inLeftCount == 0) then add new face plane (-trianglePlane)

	INVOKE NegGeoPlane, trianglePlane	
	GetGeoPlane negTrianglePlane
	
	;-------------------------------------------------------
	; set up GeoPolygonProc.facePlanes	
	mov esi, offset newPolygonProc
	INVOKE PushPlane, (GeoPolygonProc PTR [esi]).facePlanes, negTrianglePlane
	;-------------------------------------------------------
	
NEXT_L3:

	inc k ; next L3
	JMP L3


L3_DONE:

	inc j ; next L2
	JMP L2

L2_DONE:

	inc i ; next L1
	JMP L1

L1_DONE:

	; set numberOfFaces	
	mov ebx, numberOfFaces
	
	;----------------------------------------------------------
	; set up GeoPolygonProc.numberOfFaces
	mov esi, offset newPolygonProc
	mov (GeoPolygonProc PTR [esi]).numberOfFaces, ebx
	;----------------------------------------------------------

	mov i, 0	
LFACE:
	mov edx, numberOfFaces
	cmp i, edx 
	JAE LFACE_DONE ; i < numberOfFaces
	
	; get faceIdxListI, vertices indexes in the face
	INVOKE GetListIElement, ADDR faceVerticeIndex, i, ADDR faceIdxListI

	; get count of vertices in the face
	mov esi, offset faceIdxListI
	mov ebx, (ListI PTR [esi]).n
	mov count, ebx

	invoke InitListPoint, Addr facePtsListPoint

	mov j, 0 ; face vertice index
L6: ; get facePtsListPoint, vertices points in the face
	mov edx, count
	cmp j, edx 
	JAE L6_DONE ; j < count

	; get idx
	GetListIVal faceIdxListI, j, idx

	; get pt
	GetGeoPointAtIndex verticesAddr, idx, pt

	INVOKE PushPoint, ADDR facePtsListPoint, pt
	
	inc j ; j++
	JMP L6

L6_DONE:
	 
	; create new face
	INVOKE NewGeoFace, (ListPoint PTR [facePtsListPoint]).p, (ListI PTR [faceIdxListI]).p, count

	mov pFace, eax ; new face address

	; TO DO
	;-------------------------------------------
	; set up (GeoPolygonProc PTR [esi]).faces
	mov esi, offset newPolygonProc
	INVOKE PushFace, (GeoPolygonProc PTR [esi]).faces, pFace
	;-------------------------------------------

	inc i ; i++
	JMP LFACE

LFACE_DONE:

	ret
SetFacePlanes endp

PointInside3DPolygon proc uses ebx edx esi,
x: REAL8,
y: REAL8,
z: REAL8

	local i, isInside : DWORD
	local pt : GeoPoint ; input point
	local facePlaneAddr : DWORD ; head address of face planes
	local dis : REAL8 ; value to determine if point is in left or right half space of the face plane.
	
	; set isInside to true
	mov ebx, TRUE
	mov isInside, ebx
	
	; get input point
	INVOKE NewGeoPoint, x, y, z
	GetGeoPoint pt
		
	; set facePlaneAddr to face planes address
	mov esi, offset newPolygonProc
	mov esi, (GeoPolygonProc PTR [esi]).facePlanes
	mov ebx, (ListPlane PTR [esi]).p
	mov facePlaneAddr, ebx
	
	mov i, 0 ; loop counter
	mov esi, offset newPolygonProc
	mov edx, (GeoPolygonProc PTR [esi]).numberOfFaces	
L1:	
	cmp i, edx
	JAE L1_DONE 
	
	mov esi, facePlaneAddr
	INVOKE MulGeoPlane, (GeoPlane PTR [esi]), pt ; return value dis address in eax
	mov esi, eax 
	fld REAL8 PTR[esi] ; load return value dis in st(0)
	fstp dis 

	; If the point is in the same half space with normal vector 
	; for any face of the 3D convex polygon, then it is outside of the 3D polygon	
	fldz ; load 0
	fcomp dis
	fnstsw ax ; move status word into AX
	sahf ; copy AH into EFLAGS
	jb RETURN_FALSE ; if dis > 0 then return false, point is NOT inside polygon
	
	add facePlaneAddr, TYPE GeoPlane ; go to next face plane

	inc i 
	JMP L1

L1_DONE:		

	; All dis values are positive
	; For all faces, the point is in the opposite half space with normal vector of the corresponding face planes.
	; The point is inside the 3D polygon
	JMP RETURN_TRUE			

RETURN_FALSE:

	; If any dis is negative, then the point is NOT inside the 3D polygon
	mov isInside, FALSE

RETURN_TRUE:

	; return isInside in eax
	mov eax, isInside

	ret
PointInside3DPolygon endp

end
