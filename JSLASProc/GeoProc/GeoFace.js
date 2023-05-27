// Constructor
function GeoFace(p, idx) // List<GeoPoint> p, List<int> idx
{
   // new List<GeoPoint>()
   this.v = [];   
   this.v.length = 0;

   // new List<GeoPoint>()
   this.idx = [];   
   this.idx.length = 0;
   
   this.n = p.length;
   
   for(var i = 0; i < this.n; i ++ )
   {
      this.v.push(p[i]);
      this.idx.push(idx[i]);
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
var gf = [p1, p3, p5, p7];
var idx = [1, 3, 5, 7];
var gfInst = new GeoFace(gf, idx);
var str = '';
for(var i = 0; i < gfInst.n; i ++ )
{
str = str + gfInst.v[i].x.toString() + ',';
}
alert(str);
 */
