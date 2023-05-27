.686p	

.model flat, c  ; c calling convention

PDWORD TYPEDEF PTR DWORD
PREAL8 TYPEDEF PTR REAL8
PLISTI TYPEDEF PTR ListI
PLISTR TYPEDEF PTR ListR

;------------------------------
; public function prototypes
;------------------------------

; C function prototypes from C Runtime Library "C:\Program Files\Microsoft Visual Studio 10.0\VC\lib\msvcrt.lib"
; From MSDN defination

printf PROTO,
   formatString: PTR BYTE, 
   printList: VARARG

ListI STRUCT
	p PDWORD ? ; pointer to beginning address of the list
	n DWORD 0  ; count of elements, initialize with default 0
ListI ENDS

ListR STRUCT
	p PREAL8 ? ; pointer to beginning address of the list
	n DWORD 0  ; count of elements, initialize with default 0
ListR ENDS

List2DI STRUCT
	dp PDWORD ?  ; pointer to beginning address of row data
	np PDWORD ?  ; pointer to beginning address of number of elements in row
	n DWORD 0    ; number of rows
List2DI ENDS

List2DR STRUCT
	dp PREAL8 ?  ; pointer to beginning address of row data
	np PDWORD ?  ; pointer to beginning address of number of elements in row
	n DWORD 0    ; number of rows
List2DR ENDS

PushI PROTO,
	list : PTR ListI, ; pointer of 1D ListI
	element : DWORD   ; new element

PushR PROTO,
	list : PTR ListR, ; pointer of 1D ListR
	element : REAL8   ; new element

Push2DI PROTO,
	list2d: PTR List2DI,  ; pointer of 2D List2DI
	element1d : PTR ListI ; the new 1D ListI element

GetListIElement PROTO,
	list2d: PTR List2DI, ; pointer of 2D list
	rowIndex : DWORD,
	element : PTR ListI

Push2DR PROTO,
	list2d: PTR List2DR,  ; pointer of 2D List2DI
	element1d : PTR ListR ; the new 1D ListI element

GetListRElement PROTO,
	list2d: PTR List2DR, ; pointer of 2D list
	rowIndex : DWORD,
	element : PTR ListR

CopyListI PROTO,
	srclist : PTR ListI,
	destList : PTR ListI

CopyListR PROTO, 
	srcList : PTR ListR,
	destList : PTR ListR

BubbleSortListI PROTO,
	list : PTR ListI

CompareListI PROTO, 
	list1 : PTR ListI,
	list2 : PTR ListI

ContainsListI PROTO,
	list2d : PTR List2DI,
	list : PTR ListI

BubbleSortListR PROTO,
	list : PTR ListR

CompareListR PROTO, 
	list1 : PTR ListR,
	list2 : PTR ListR

ContainsListR PROTO,
	list2d : PTR List2DR,
	list : PTR ListR

;------------------------
; Macro
;------------------------

; return number of rows in eax
GetSizeList2DI MACRO list2d:REQ, retv:REQ
	push ebx
	push esi

	mov esi, list2d
	mov ebx, (List2DI PTR [esi]).n
	mov retv, ebx

	pop esi
	pop ebx
endm

; return number of rows in eax
GetSizeList2DR MACRO list2d:REQ, retv:REQ 		
	push ebx
	push esi

	mov esi, list2d
	mov ebx, (List2DR PTR [esi]).n
	mov retv, ebx

	pop esi
	pop ebx
endm

; listiObj : ListI, idx : DWORD, retv : DWORD
; uses esi, ebx
GetListIVal MACRO listiObj:REQ, idx:REQ, retv:REQ 	
	push ebx
	push esi
	
	mov esi, offset listiObj
	mov esi, (ListI PTR [esi]).p	
	mov ebx, idx
	imul ebx, TYPE DWORD
	add esi, ebx
	mov ebx, (DWORD PTR[esi])
	mov retv, ebx

	pop esi
	pop ebx
endm

; listrObj : ListR, idx : DWORD, retv : REAL8
; uses esi, ebx
GetListRVal MACRO listrObj:REQ, idx:REQ, retv:REQ 	
	push ebx
	push esi
	
	mov esi, offset listrObj
	mov esi, (ListR PTR [esi]).p	
	mov ebx, idx
	imul ebx, TYPE REAL8
	add esi, ebx
	fld (REAL8 PTR[esi])
	fstp retv

	pop esi
	pop ebx
endm
