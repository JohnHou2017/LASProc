// Constructor
function GeoPolygon(p) // List<GeoPoint> p
{
   // new List<GeoPoint> ()
   this.v = [];
   this.v.length = 0;

   // new List<int> ()
   this.idx = [];   
   this.idx.length = 0;

   this.n = p.length;

   for(var i = 0; i < this.n; i ++ )
   {
      this.v.push(p[i]);
      this.idx.push(i);
   }
}

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
var gp = [p1, p2, p3, p4, p5, p6, p7, p8];
var gpInst = new GeoPolygon(gp);
var str = '';
for(var i = 0; i < gpInst.n; i ++ )
{
str = str + gpInst.v[i].x.toString() + ',';
}
alert(str);
 */
