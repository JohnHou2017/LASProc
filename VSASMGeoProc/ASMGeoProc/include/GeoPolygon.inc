ifndef GeoPoint
include GeoPoint.inc
endif

include CFunction.inc
include Constant.inc

GeoPolygon STRUCT	
	ptsAddr PGeoPoint ?	
	n DWORD 0 ; actual number of polygon vertices
GeoPolygon ENDS

NewGeoPolygon PROTO,
	ptsAddr: PGeoPoint, ; GeoPolygon vertices array address
	ptsCount: DWORD ; GeoPolygon array size
	

	
