// Constructor
function GeoVector(p0, p1) // GeoPoint p0, p1
{
   // vector begin point
   this.p0 = p0;
   
   // vector end point
   this.p1 = p1;
   
   // vector x axis projection value
   this.x = p1.x - p0.x;
   
   // vector y axis projection value
   this.y = p1.y - p0.y;
   
   // vector z axis projection value
   this.z = p1.z - p0.z;
}

// public Instance method to simulate overloading binary operator multiple (GeoVector * GeoVector)
GeoVector.prototype.Multiple = function(v) // GeoVector v
{
   var x = this.y * v.z - this.z * v.y;
   
   var y = this.z * v.x - this.x * v.z;
   
   var z = this.x * v.y - this.y * v.x;
  
   var p0 = v.p0; // GeoPoint
   
   var p1 = p0.Add(new GeoPoint(x, y, z)); // GeoPoint

   return new GeoVector(p0, p1);
};

///////////////////
// Test & Usage
//
/*
var v1 = new GeoVector(new GeoPoint(1, 2, 3), new GeoPoint(4, 6, 8));
var v2 = new GeoVector(new GeoPoint(1, 2, 3), new GeoPoint(5, 7, 9));
var v3 = v2.Multiple(v1);
alert(v3.x);
 */
