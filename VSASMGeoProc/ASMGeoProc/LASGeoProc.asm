.686p

.model flat, c ; use c calling convention 

include Macro.inc
include GeoPoint.inc
include GeoVector.inc
include GeoPlane.inc
include GeoPolygon.inc
include GeoFace.inc
include GeoPolygonProc.inc

.stack 4096

.data

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

vtsCount DWORD 8

pPolygon PGeoPolygon ? ; GeoPolygon *pPolygon
pPolygonProc PGeoPolygonProc ? ; GeoPolygonProc *pPolygonProc
x0 REAL8 ?
x1 REAL8 ?
y0 REAL8 ?
y1 REAL8 ?
z0 REAL8 ?
z1 REAL8 ?

strFileInput BYTE "..\\LASInput\\cube.las", 0
strFileOutputB BYTE "..\\LASOutput\\cube_inside.las", 0
strFileOutputT BYTE "..\\LASOutput\\cube_inside.txt", 0

modeRB BYTE "rb", 0
modeWB BYTE "wb", 0
modeWT BYTE "w+", 0

rbFile PFILE ?
wbFile PFILE ?
wtFile PFILE ?

offset_to_point_data_value DWORD ?
record_len DWORD ?
record_num DWORD ?
x_scale REAL8 ?
y_scale REAL8 ?
z_scale REAL8 ?
x_offset REAL8 ?
y_offset REAL8 ?
z_offset REAL8 ?

bufHeader PBYTE ?
bufRecord PBYTE ?

xi DWORD ?
yi DWORD ?
zi DWORD ?

FmtOutputFile BYTE "%15.6f %15.6f %15.6f", 0Ah,0

FmtStr BYTE "%s", 0Ah,0
strBegin BYTE "Process Begin ...", 0
strEnd BYTE "Process End.", 0

.code

main PROC
	
	MyPrintf offset FmtStr, ADDR strBegin
	
	call SetUpGeoPolygonProc

	call LASProcess
	
	MyPrintf offset FmtStr, ADDR strEnd

	ret
		
main ENDP

SetUpGeoPolygonProc Proc,	

	; create pPolygon
	INVOKE NewGeoPolygon, ADDR vtsArr, vtsCount ; return in eax		
	mov pPolygon, eax ; new GeoPolygon address

	; create pPolygonProc
	INVOKE NewGeoPolygonProc, pPolygon	
	mov pPolygonProc, eax ; new GeoPolygonProc address

	; set boundary
	mov esi, pPolygonProc
	fld (GeoPolygonProc PTR [esi]).x0
	fstp x0
	fld (GeoPolygonProc PTR [esi]).x1
	fstp x1
	fld (GeoPolygonProc PTR [esi]).y0
	fstp y0
	fld (GeoPolygonProc PTR [esi]).y1
	fstp y1
	fld (GeoPolygonProc PTR [esi]).z0
	fstp z0
	fld (GeoPolygonProc PTR [esi]).z1
	fstp z1
	
	ret

SetUpGeoPolygonProc endp

LASProcess proc,

	local i, record_loc : DWORD
	local x : REAL8
	local y : REAL8
	local z : REAL8		
	local isInside : DWORD	
	local insideCount : DWORD

	; open LAS file to read
	INVOKE fopen, ADDR strFileInput, ADDR modeRB
	mov rbFile, eax

	; open LAS file to write
	INVOKE fopen, ADDR strFileOutputB, ADDR modeWB
	mov wbFile, eax	

	; open text file to write
	INVOKE fopen, ADDR strFileOutputT, ADDR modeWT
	mov wtFile, eax
	
	; read summary info
	INVOKE fseek, rbFile, 96, 0
	INVOKE fread, offset offset_to_point_data_value, TYPE DWORD, 1, rbFile

	INVOKE fseek, rbFile, 105, 0
	INVOKE fread, offset record_len, TYPE WORD, 1, rbFile
	INVOKE fread, offset record_num, TYPE DWORD, 1, rbFile

	INVOKE fseek, rbFile, 131, 0
	INVOKE fread, offset x_scale, TYPE REAL8, 1, rbFile
	INVOKE fread, offset y_scale, TYPE REAL8, 1, rbFile
	INVOKE fread, offset z_scale, TYPE REAL8, 1, rbFile
	INVOKE fread, offset x_offset, TYPE REAL8, 1, rbFile
	INVOKE fread, offset y_offset, TYPE REAL8, 1, rbFile
	INVOKE fread, offset z_offset, TYPE REAL8, 1, rbFile

	; allocate memory for LAS header
	invoke malloc, offset_to_point_data_value
	mov bufHeader, eax
	
	; read LAS header
	INVOKE fseek, rbFile, 0, 0	
	INVOKE fread, bufHeader, 1, offset_to_point_data_value, rbFile

	; write LAS header
	INVOKE fwrite, bufHeader, 1, offset_to_point_data_value, wbFile

	; allocate memory for LAS record	
	invoke malloc, record_len
	mov bufRecord, eax				

	mov i, 0	
	mov insideCount, 0
L1:
	mov edx, record_num
	cmp i, edx
	JAE DONE ; i < record_num

		; LAS record location
		; record_loc = offset_to_point_data_value + record_len * i;
		mov ebx, record_len
		imul ebx, i
		add ebx, offset_to_point_data_value
		mov record_loc, ebx
		
		; read LAS record coordinate
		INVOKE fseek, rbFile, record_loc, 0
		INVOKE fread, offset xi, TYPE DWORD, 1, rbFile
		INVOKE fread, offset yi, TYPE DWORD, 1, rbFile
		INVOKE fread, offset zi, TYPE DWORD, 1, rbFile

		; convert to actual coordinate

		; x = (xi * x_scale) + x_offset;
		fild xi
		fmul x_scale
		fadd x_offset
		fstp x

		; y = (yi * y_scale) + y_offset;
		fild yi
		fmul y_scale
		fadd y_offset
		fstp y

		; z = (zi * z_scale) + z_offset;
		fild zi
		fmul z_scale
		fadd z_offset
		fstp z
		
		; filter out points outside of boundary
		CmpReal x0, x
		JNB NEXT
		CmpReal x, x1
		JNB NEXT
		CmpReal y0, y
		JNB NEXT
		CmpReal y, y1
		JNB NEXT
		CmpReal z0, z
		JNB NEXT
		CmpReal z, z1
		JNB NEXT

		; inside boundary
		
		; check if point(x,y,z) is inside 3D polygon
		INVOKE PointInside3DPolygon, x, y, z
		mov isInside, eax
		
		; skip outside points
		cmp isInside, FALSE
		JE NEXT
	
		; inside points		

		; read LAS inside record
		INVOKE fseek, rbFile, record_loc, 0
		INVOKE fread, bufRecord, 1, record_len, rbFile
			
		; write LAS inside record
		INVOKE fwrite, bufRecord, 1, record_len, wbFile
		
		; write LAS text inside record
		INVOKE fprintf, wtFile, offset FmtOutputFile, x, y, z
				
		inc insideCount
NEXT:

	inc i ; i++
	JMP L1

DONE:

	; update actual writting count
	INVOKE fseek, wbFile, 107, 0	
	INVOKE fwrite, ADDR insideCount, TYPE DWORD, 1, wbFile

	; close files
	INVOKE fclose, rbFile
	INVOKE fclose, wbFile
	INVOKE fclose, wtFile

	; free memory
	invoke free, bufHeader
	invoke free, bufRecord

	ret
LASProcess endp

end