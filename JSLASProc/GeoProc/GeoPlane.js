// Constructor
function GeoPlane(a, b, c, d) // double a, b, c, d
{
   this.a = a;
   
   this.b = b;
   
   this.c = c;
   
   this.d = d;   
};

// public Static method to simulate the second constructor
GeoPlane.Create = function(p0, p1, p2) // GeoPoint p0, p1, p2
{
   var v = new GeoVector(p0, p1);

   var u = new GeoVector(p0, p2);

   // normal vector. 
   var n = u.Multiple(v); // GeoVector

   var a = n.x; // double

   var b = n.y; // double

   var c = n.z; // double

   var d = - (a * p0.x + b * p0.y + c * p0.z); // double
   
   return new GeoPlane(a, b, c, d);
}

// public Instance method to simulate overloading uary operator negative - GeoPlane
GeoPlane.prototype.Negative = function()
{
   return new GeoPlane( - this.a, - this.b, - this.c, - this.d);
};

// public Instance method to simulate overloading binary operator multiple (GeoPlane * GeoPoint)
GeoPlane.prototype.Multiple = function(p) // GeoPoint p
{
   return (this.a * p.x + this.b * p.y + this.c * p.z + this.d); // double   
};

///////////////////
// Test & Usage
//
/*
var p1 = new GeoPoint( - 27.28046,  37.11775,  - 39.03485);
var p2 = new GeoPoint( - 44.40014,  38.50727,  - 28.78860);
var p3 = new GeoPoint( - 49.63065,  20.24757,  - 35.05160);
var p4 = new GeoPoint( - 32.51096,  18.85805,  - 45.29785);
var p5 = new GeoPoint( - 23.59142,  10.81737,  - 29.30445);
var p6 = new GeoPoint( - 18.36091,  29.07707,  - 23.04144);
var p7 = new GeoPoint( - 35.48060,  30.46659,  - 12.79519);
var p8 = new GeoPoint( - 40.71110,  12.20689,  - 19.05819);
var plInst = new GeoPlane(p1, p2, p3);
alert(plInst.a + ',' + plInst.b + ',' + plInst.c + ',' + plInst.d);
var plInst1 = plInst.Create(plInst.a, plInst.b, plInst.c, plInst.d);
alert(plInst.a + ',' + plInst.b + ',' + plInst.c + ',' + plInst.d);
 */
