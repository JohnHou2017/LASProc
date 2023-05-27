include GeoPoint.inc

GeoPlane STRUCT
	a REAL8 0.0
	b REAL8 0.0
	cc REAL8 0.0 ; c is reserved word, rename it to "cc" which means "coefficient c"
	d REAL8 0.0
GeoPlane ENDS

NewGeoPlaneA PROTO,
	a: REAL8,
 	b: REAL8,
	cc: REAL8, ; c is reserved word
	d: REAL8

NewGeoPlaneB PROTO,
	p0: GeoPoint,
 	p1: GeoPoint,
	p2: GeoPoint	

NegGeoPlane PROTO,
 	pl: GeoPlane	
	
MulGeoPlane PROTO,
 	pl: GeoPlane,
 	pt: GeoPoint
	
