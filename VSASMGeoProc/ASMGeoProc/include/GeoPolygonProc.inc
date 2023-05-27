ifndef GeoPoint
include GeoPoint.inc
endif

ifndef GeoVector
include GeoVector.inc
endif

include Macro.inc
include GeoPlane.inc
include GeoPolygon.inc
include GeoFace.inc
include List.inc
include ListGeoProc.inc

include CFunction.inc
include Constant.inc

GeoPolygonProc STRUCT	

	facePlanes PListPlane ?
	faces PListFace ?
	numberOfFaces DWORD 0
	x0 REAL8 0.0
	x1 REAL8 0.0
	y0 REAL8 0.0
	y1 REAL8 0.0
	z0 REAL8 0.0
	z1 REAL8 0.0
	minError REAL8 0.0

GeoPolygonProc ENDS

NewGeoPolygonProc PROTO,
ptsAddr: PGeoPolygon ; GeoPolygon pointer	

PointInside3DPolygon PROTO,
x: REAL8,
y: REAL8,
z: REAL8