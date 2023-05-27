include CFunction.inc
include Constant.inc

ListPoint STRUCT
	p PGeoPoint ? ; pointer to beginning address of the list
	n DWORD 0  ; count of elements, initialize with default 0
ListPoint ENDS

ListPlane STRUCT
	p PGeoPlane ? ; pointer to beginning address of the list
	n DWORD 0  ; count of elements, initialize with default 0
ListPlane ENDS

ListFace STRUCT
	p PGeoFace ? ; pointer to beginning address of the list
	n DWORD 0  ; count of elements, initialize with default 0
ListFace ENDS

PushPoint PROTO,
list : PTR ListPoint, 
element : GeoPoint

PushPlane PROTO,
list : PTR ListPlane, 
element : GeoPlane

PushFace PROTO,
list : PTR ListFace, 
element : PTR GeoFace

InitListPoint PROTO,
list : PTR ListPoint