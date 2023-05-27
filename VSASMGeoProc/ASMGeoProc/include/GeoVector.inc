ifndef GeoPoint
include GeoPoint.inc
endif

GeoVector STRUCT
	p0 GeoPoint <?>
	p1 GeoPoint <?>	
	x real8 0.0
	y real8 0.0
	z real8 0.0
GeoVector ENDS

NewGeoVector PROTO,
	p0: GeoPoint, 	
	p1: GeoPoint	
	
MulGeoVector PROTO,
 	u: GeoVector,
 	v: GeoVector
	
