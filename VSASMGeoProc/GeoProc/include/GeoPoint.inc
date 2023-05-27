GeoPoint STRUCT
	x REAL8 0.0
	y REAL8 0.0
	z REAL8 0.0
GeoPoint ENDS

NewGeoPoint PROTO,
	x: REAL8,
 	y: REAL8,
	z: REAL8
	
AddGeoPoint PROTO,
 	pt1: GeoPoint,
 	pt2: GeoPoint
	
