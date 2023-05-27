ifndef GeoPoint
include GeoPoint.inc
endif

include CFunction.inc
include Constant.inc

GeoFace STRUCT	
	ptsAddr PGeoPoint ?	
	idxAddr PDWORD ?
	n DWORD 0 ; actual number of face vertices
GeoFace ENDS

NewGeoFace PROTO,
	ptsAddr: PGeoPoint, ; GeoFace vertices array address
	idxAddr: PDWORD,
	ptsCount: DWORD ; GeoFace array size

	
