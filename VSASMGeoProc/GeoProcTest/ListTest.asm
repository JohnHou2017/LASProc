.model flat, c ; use c calling convention 

include List.inc
include Macro.inc

.data

strListTestTitle  BYTE "Assembly 2D List Test:", 0

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

i1 DWORD 1
i2 DWORD 2
i3 DWORD 3

r1 REAL8 11.1
r2 REAL8 22.2
r3 REAL8 33.3

lipDataay ListI 10 dup (<?>)

litemp ListI <?>
litempr ListR <?>

; global variable has initialized with a hard-coded memory address in non-stack memory
ltempListI ListI <?> 
tempListR ListR <?>

li1 ListI <?> ; initialize value n with default value 0 in ListI struct defination
; li1 ListI <> ; not initialize value n, n is a wild value

li2 ListI <?>
li3 ListI <?>

lr1 ListR <?>
lr2 ListR <?>
lr3 ListR <?>

li2di List2DI <?>

li2dr List2DR <?>

.code

ListTest proc,

	local i, n : DWORD
	local tempi : DWORD
	local tempr : REAL8
	local tempPTR : DWORD
	;local ltempListI : ListI ; local variable initialized in stack memory

	INVOKE printf, ADDR FmtStr, ADDR strListTestTitle

	invoke pushi, ADDR li1, i3	
	invoke pushi, ADDR li1, i2
	invoke pushi, ADDR li1, i1		
	mov ecx, 1
	L1:
		invoke pushi, ADDR li1, i3		
	Loop L1
	
	mov i, 0
	GetListIVal li1, i, tempi
	INVOKE printf, ADDR FmtInt, tempi
	inc i
	GetListIVal li1, i, tempi
	INVOKE printf, ADDR FmtInt, tempi
	inc i
	GetListIVal li1, i, tempi
	INVOKE printf, ADDR FmtInt, tempi
	inc i
	GetListIVal li1, i, tempi
	INVOKE printf, ADDR FmtInt, tempi	

	mov esi, offset li1
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtIIII, DWORD PTR[esi], DWORD PTR[esi + 4], DWORD PTR[esi + 8], DWORD PTR[esi + 12]
	
	invoke pushi, ADDR li2, i1
	invoke pushi, ADDR li2, i2
	invoke pushi, ADDR li2, i3	

	mov esi, offset li2
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtIII, DWORD PTR[esi], DWORD PTR[esi + 4], DWORD PTR[esi + 8]
	
	invoke pushi, ADDR li3, i1
	invoke pushi, ADDR li3, i3	

	mov esi, offset li3
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtII, DWORD PTR[esi], DWORD PTR[esi + 4]

	invoke push2di, ADDR li2di, ADDR li1
	invoke push2di, ADDR li2di, ADDR li2
	invoke push2di, ADDR li2di, ADDR li3			
	mov ecx, 1
	L2:
		invoke push2di, ADDR li2di, ADDR li1
	Loop L2

	mov tempPTR, offset li2di
	GetSizeList2DI tempPTR, n	
	INVOKE printf, ADDR FmtInt, n

	invoke GetListIElement, ADDR li2di, 0, ADDR litemp
	mov esi, offset litemp
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtIIII, DWORD PTR[esi], DWORD PTR[esi + 4], DWORD PTR[esi + 8], DWORD PTR[esi + 12]

	invoke GetListIElement, ADDR li2di, 1, ADDR litemp
	mov esi, offset litemp
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtIII, DWORD PTR[esi], DWORD PTR[esi + 4], DWORD PTR[esi + 8]

	invoke GetListIElement, ADDR li2di, 2, ADDR litemp
	mov esi, offset litemp
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtII, DWORD PTR[esi], DWORD PTR[esi + 4]

	invoke GetListIElement, ADDR li2di, 3, ADDR litemp
	mov esi, offset litemp
	mov esi, (ListI PTR [esi]).p
	INVOKE printf, ADDR FmtIIII, DWORD PTR[esi], DWORD PTR[esi + 4], DWORD PTR[esi + 8], DWORD PTR[esi + 12]
	
	invoke pushr, ADDR lr1, r3
	invoke pushr, ADDR lr1, r2
	invoke pushr, ADDR lr1, r1	
	mov ecx, 1
	L3:
		invoke pushr, ADDR lr1, r3		
	Loop L3

	mov i, 0
	GetListRVal lr1, i, tempr
	INVOKE printf, ADDR FmtF, tempr
	inc i
	GetListRVal lr1, i, tempr
	INVOKE printf, ADDR FmtF, tempr
	inc i
	GetListRVal lr1, i, tempr
	INVOKE printf, ADDR FmtF, tempr
	inc i
	GetListRVal lr1, i, tempr
	INVOKE printf, ADDR FmtF, tempr

	mov esi, offset lr1
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFFFF, REAL8 PTR[esi], REAL8 PTR[esi + 8], REAL8 PTR[esi + 16], REAL8 PTR[esi + 24]	

	invoke pushr, ADDR lr2, r1
	invoke pushr, ADDR lr2, r2
	invoke pushr, ADDR lr2, r3	
	mov esi, offset lr2
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFFF, REAL8 PTR[esi], REAL8 PTR[esi + 8], REAL8 PTR[esi + 16]

	invoke pushr, ADDR lr3, r2
	invoke pushr, ADDR lr3, r3	
	mov esi, offset lr3
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFF, REAL8 PTR[esi], REAL8 PTR[esi + 8]

	invoke push2dr, ADDR li2dr, ADDR lr1
	invoke push2dr, ADDR li2dr, ADDR lr2
	invoke push2dr, ADDR li2dr, ADDR lr3	
	mov ecx, 1
	L4:
		invoke push2dr, ADDR li2dr, ADDR lr1
	Loop L4
	
	mov tempPTR, offset li2dr
	GetSizeList2DR tempPTR, n	
	INVOKE printf, ADDR FmtInt, n

	invoke GetListRElement, ADDR li2dr, 0, ADDR litempr
	mov esi, offset litempr
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFFFF, REAL8 PTR[esi], REAL8 PTR[esi + 8], REAL8 PTR[esi + 16], REAL8 PTR[esi + 24]

	invoke GetListRElement, ADDR li2dr, 1, ADDR litempr
	mov esi, offset litempr
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFFF, REAL8 PTR[esi], REAL8 PTR[esi + 8], REAL8 PTR[esi + 16]

	invoke GetListRElement, ADDR li2dr, 2, ADDR litempr
	mov esi, offset litempr
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFF, REAL8 PTR[esi], REAL8 PTR[esi + 8]

	invoke GetListRElement, ADDR li2dr, 3, ADDR litempr
	mov esi, offset litempr
	mov esi, (ListR PTR [esi]).p
	INVOKE printf, ADDR FmtFFFF, REAL8 PTR[esi], REAL8 PTR[esi + 8], REAL8 PTR[esi + 16], REAL8 PTR[esi + 24]

	invoke ContainsListI, ADDR li2di, ADDR li3	
	INVOKE printf, ADDR FmtInt, eax

	invoke pushi, ADDR li3, i2
	
	;invoke CompareListI, ADDR li2, ADDR li3

	;invoke BubbleSortListI, ADDR li3

	;invoke CompareListI, ADDR li2, ADDR li3

	invoke ContainsListI, ADDR li2di, ADDR li3

	invoke pushi, ADDR li3, i2

	invoke ContainsListI, ADDR li2di, ADDR li3
	INVOKE printf, ADDR FmtInt, eax

	;invoke CopyListI, ADDR li3, ADDR ltempListI
	
	;invoke CopyListI, ADDR li1, ADDR ltempListI

	;invoke BubbleSortListR, ADDR lr1

	;invoke pushr, ADDR lr2, r3	
	;invoke CompareListR, ADDR lr1, ADDR lr2

	;invoke CopyListR, ADDR lr1, ADDR tempListR

	;invoke BubbleSortListR, ADDR tempListR

	;invoke CompareListR, ADDR tempListR, ADDR lr2

	;invoke CopyListR, ADDR lr1, ADDR tempListR
	;invoke CopyListR, ADDR lr1, ADDR tempListR
	;invoke CopyListR, ADDR lr1, ADDR tempListR

	invoke ContainsListR, ADDR li2dr, ADDR lr1	
	INVOKE printf, ADDR FmtInt, eax

	invoke ContainsListR, ADDR li2dr, ADDR lr2
	INVOKE printf, ADDR FmtInt, eax

	invoke ContainsListR, ADDR li2dr, ADDR lr3
	INVOKE printf, ADDR FmtInt, eax

	invoke pushr, ADDR lr2, r1
	invoke ContainsListR, ADDR li2dr, ADDR lr2
	INVOKE printf, ADDR FmtInt, eax

	ret

ListTest endp

end