; use stdcall calling convention if using Win32 API, i.e. WriteConsole
; link.exe /libpath:"C:\Program Files\Microsoft SDKs\Windows\v7.0A\Lib" kernel32.lib user32.lib
;
; use c calling convention if using C functions in C Runtime Library msvcrt.lib, i.e. printf
; link.exe /libpath:"C:\Program Files\Microsoft Visual Studio 10.0\VC\lib" msvcrt.lib
;
.686p
.model flat, c ; use c calling convention 

include GeoPoint.inc
include Macro.inc

.data

; Return values of procedures
newPoint GeoPoint <?>
addPoint GeoPoint <?>

.code

; New a point
; Receives: x, y, z
; Returns: esi = address of newPoint
NewGeoPoint proc,
	x: REAL8,
 	y: REAL8,
	z: REAL8
   	
	fld x	
	fstp newPoint.x 
	fld y
	fstp newPoint.y
	fld z
	fstp newPoint.z
	
	; return newPoint
	mov esi, offset newPoint
	
	ret
NewGeoPoint endp

;Add 2 points, addPoint = pt1 + pt2
;Receives: pt1, pt2
;Returns: esi = address of addPoint
AddGeoPoint proc,
	pt1: GeoPoint,
 	pt2: GeoPoint	
			
	AddReal pt1.x, pt2.x, addPoint.x
	AddReal pt1.y, pt2.y, addPoint.y
	AddReal pt1.z, pt2.z, addPoint.z	
	
	; return addPoint
	mov esi, offset addPoint
	
	ret
AddGeoPoint endp

end