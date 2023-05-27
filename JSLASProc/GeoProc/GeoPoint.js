// Constructor
function GeoPoint(x, y, z)	// double x, y, z
{
   this.x = x;
   
   this.y = y;
   
   this.z = z;
   
}

// public Instance method to simulate overloading binary operator add (GeoPoint + GeoPoint)
GeoPoint.prototype.Add = function(p) // GeoPoint p
{
   return new GeoPoint(this.x + p.x, this.y + p.y, this.z + p.z);
}
;

///////////////////
// Test & Usage
//
/*
var p0 = new GeoPoint(1, 2, 3);
var p1 = new GeoPoint(2, 3, 4);
var p2 = p0.Add(p1);
alert(p2.z);
 */
