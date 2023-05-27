var MaxUnitMeasureError = 0.001;

// Constructor
function GeoPolygonProc(polygonInst) // GeoPolygon polygonInst
{

   // Set boundary
   Set3DPolygonBoundary.call(this, polygonInst);

   // Set maximum point to face plane distance error,
   Set3DPolygonUnitError.call(this);

   // Set faces and face planes
   SetConvex3DFaces.call(this, polygonInst);

}

// private Instance method
function Set3DPolygonBoundary(polygon) // GeoPolygon polygon
{
   // List<GeoPoint>
   var vertices = polygon.v;
   
   var n = polygon.n;

   var xmin, xmax, ymin, ymax, zmin, zmax;

   xmin = xmax = vertices[0].x;
   ymin = ymax = vertices[0].y;
   zmin = zmax = vertices[0].z;

   for (var i = 1; i < n; i ++ )
   {
      if (vertices[i].x < xmin) xmin = vertices[i].x;
      if (vertices[i].y < ymin) ymin = vertices[i].y;
      if (vertices[i].z < zmin) zmin = vertices[i].z;
      if (vertices[i].x > xmax) xmax = vertices[i].x;
      if (vertices[i].y > ymax) ymax = vertices[i].y;
      if (vertices[i].z > zmax) zmax = vertices[i].z;
   }
   
   // double
   this.x0 = xmin;  
   this.x1 = xmax;
   this.y0 = ymin;
   this.y1 = ymax;
   this.z0 = zmin;
   this.z1 = zmax;

}

// private Instance method
function Set3DPolygonUnitError()
{
   // double
   this.MaxDisError = ((Math.abs(this.x0) + Math.abs(this.x1) +
                        Math.abs(this.y0) + Math.abs(this.y1) +
                        Math.abs(this.z0) + Math.abs(this.z1)) / 6 * MaxUnitMeasureError);   
}

// private Instance method
function SetConvex3DFaces(polygon) // GeoPolygon polygon
{

   // new List<GeoFace>()
   var faces = [];   
   faces.length = 0;

   // new List<GeoFace>()
   var facePlanes = [];   
   facePlanes.length = 0;

   var numberOfFaces;

   var maxError = this.MaxDisError;

   // vertices of 3D polygon
   var vertices = polygon.v; // new List<GeoPoint>()   

   var n = polygon.n;

   // vertices indexes for all faces
   // vertices index is the original index value in the input polygon
   // new List<List<int>>()
   var faceVerticeIndex = [[]];   
   faceVerticeIndex.length = 0;

   // face planes for all faces
   // new List<GeoPlane> ()
   var fpOutward = [];   
   fpOutward.length = 0;

   for(var i = 0; i < n; i ++ )
   {

      // triangle point 1
      // GeoPoint
      var p0 = vertices[i]; 
      
      for(var j = i + 1; j < n; j ++ )
      {

         // triangle point 2
         // GeoPoint
         var p1 = vertices[j];
         
         for(var k = j + 1; k < n; k ++ )
         {

            // triangle point 3
            // GeoPoint
            var p2 = vertices[k];
            
            var trianglePlane = GeoPlane.Create(p0, p1, p2);

            var onLeftCount = 0;

            var onRightCount = 0;

            // indexes of points that lie in same plane with face triangle plane
            // new List<int>()
            var pointInSamePlaneIndex = [];            
            pointInSamePlaneIndex.length = 0;

            for(var l = 0; l < n ; l ++ )
            {

               // any point other than the 3 triangle points
               if(l != i && l != j && l != k)
               {
                  // GeoPoint
                  var p = vertices[l];
                  
                  // double
                  var dis = trianglePlane.Multiple(p);
                  
                  // next point is in the triangle plane
                  if(Math.abs(dis) < maxError)
                  {
                     pointInSamePlaneIndex.push(l);
                  }
                  else
                  {
                     if(dis < 0)
                     {
                        onLeftCount ++ ;
                     }
                     else
                     {
                        onRightCount ++ ;
                     }

                  }
               }
            }

            // This is a face for a CONVEX 3d polygon.
            // For a CONCAVE 3d polygon, this maybe not a face.
            if(onLeftCount == 0 || onRightCount == 0)
            {
               // new List<int>()
               var verticeIndexInOneFace = [];               
               verticeIndexInOneFace.length = 0;

               // triangle plane
               verticeIndexInOneFace.push(i);
               verticeIndexInOneFace.push(j);
               verticeIndexInOneFace.push(k);

               var m = pointInSamePlaneIndex.length;

               if(m > 0) // there are other vertices in this triangle plane
               {
                  for(var p = 0; p < m; p ++ )
                  {
                     verticeIndexInOneFace.push(pointInSamePlaneIndex[p]);
                  }
               }

               // if verticeIndexInOneFace is a new face               
               if ( ! Utility.ContainsList(faceVerticeIndex, verticeIndexInOneFace))
               {

                  // add it in the faceVerticeIndex list
                  faceVerticeIndex.push(verticeIndexInOneFace);

                  // add the trianglePlane in the face plane list fpOutward.
                  if (onRightCount == 0)
                  {
                     fpOutward.push(trianglePlane);
                  }
                  else if (onLeftCount == 0)
                  {
                     fpOutward.push(trianglePlane.Negative());
                  }
               }

            }
            else
            {
               // possible reasons :
               // 1. the plane is not a face of a convex 3d polygon,
               //    it is a plane crossing the convex 3d polygon.
               // 2. the plane is a face of a concave 3d polygon
            }

         } // k loop
         
      } // j loop
      
   } // i loop
   
   numberOfFaces = faceVerticeIndex.length;
   
   for (var i = 0; i < numberOfFaces; i ++ )
   {
      facePlanes.push(new GeoPlane(fpOutward[i].a, fpOutward[i].b,
      fpOutward[i].c, fpOutward[i].d));

      // new List<GeoPoint>()
      var gp = [];      
      gp.length = 0;

      // new List<int>()
      var vi = [];      
      vi.length = 0;

      var count = faceVerticeIndex[i].length;
    
      for (var j = 0; j < count; j ++ )
      {
         vi.push(faceVerticeIndex[i][j]);
         gp.push( new GeoPoint(vertices[ vi[j] ].x,
         vertices[ vi[j] ].y,
         vertices[ vi[j] ].z));
      }

      faces.push(new GeoFace(gp, vi));
   }

   // List<GeoFace>
   this.Faces = faces;
   
   // List<GeoPlane>
   this.FacePlanes = facePlanes;
      
   this.NumberOfFaces = numberOfFaces;
   
}

// public Instance method
GeoPolygonProc.prototype.PointInside3DPolygon = function(x, y, z) // GeoPoint x, y, z
{
   var P = new GeoPoint(x, y, z);

   for (var i = 0; i < this.NumberOfFaces; i ++ )
   {

      var dis = this.FacePlanes[i].Multiple(P);

      // If the point is in the same half space with normal vector for any face of the cube,
      // then it is outside of the 3D polygon
      if (dis > 0)
      {
         return false;
      }

   }

   // If the point is in the opposite half space with normal vector for all 6 faces,
   // then it is inside of the 3D polygon
   return true;

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
var gppInst = new GeoPolygonProc(gpInst);
var str = '';
str = str + gppInst.MaxDisError + '\r';
str = str + gppInst.x0 + ',' + gppInst.x1 + ',' + gppInst.y0 + ',' + gppInst.y1 + ',' + gppInst.y0 + ',' + gppInst.y1 + '\r';
str = str + gppInst.NumberOfFaces + '\r';
for (var i = 0; i < gppInst.NumberOfFaces; i ++ )
{
str += gppInst.FacePlanes[i].a + ',' + gppInst.FacePlanes[i].b + ',' +
gppInst.FacePlanes[i].c + ',' + gppInst.FacePlanes[i].d + '\r';
}
var insidePoint = new GeoPoint( - 28.411750,     25.794500,      - 37.969000);
var outsidePoint = new GeoPoint( - 28.411750,      25.794500,      - 50.969000);
str += gppInst.PointInside3DPolygon(insidePoint.x, insidePoint.y, insidePoint.z) + '\r';
str += gppInst.PointInside3DPolygon(outsidePoint.x, outsidePoint.y, outsidePoint.z) + '\r';
alert(str);
 */
