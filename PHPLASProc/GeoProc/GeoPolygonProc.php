<?php

require_once ('GeoPoint.php');
require_once ('GeoVector.php');
require_once ('GeoPlane.php');
require_once ('GeoPolygon.php');
require_once ('GeoFace.php');
require_once ('Utility.php');

class GeoPolygonProc
{
	
	private $MaxUnitMeasureError = 0.001;	
	
	private $Faces;         // GeoFace Array	   	   
	private $FacePlanes;    // GeoPlane Array		  
	private $NumberOfFaces; // Integer	
	private $x0, $y0, $x1, $y1, $z0, $z1; // 3D polygon boundary: Double
	
	public $MaxDisError; // Allow to set and get
	
	public function getFaces(){return $this->Faces;}
	public function getFacePlanes(){return $this->FacePlanes;}
	public function getNumberOfFaces(){return $this->NumberOfFaces;}
	public function getX0(){return $this->x0;}
	public function getX1(){return $this->x1;}
	public function getY0(){return $this->y0;}
	public function getY1(){return $this->y1;}
	public function getZ0(){return $this->z0;}
	public function getZ1(){return $this->z1;}
	
	// Constructor
	public function __construct($polygonInst) // $polygonInst: GeoPolygon
	{

	   // Set boundary
	   $this->Set3DPolygonBoundary($polygonInst);

	   // Set maximum point to face plane distance error,
	   $this->Set3DPolygonUnitError();

	   // Set faces and face planes
	   $this->SetConvex3DFaces($polygonInst);

	}
	
	public function __destruct()
	{
		// free instance array memory
		unset($this->Faces);
		unset($this->FaceFacePlaness);
	}

	// private Instance method
	private function Set3DPolygonBoundary($polygon) // $polygon: GeoPolygon polygon
	{	   
	   $vertices = $polygon->getV(); // GeoPoint Array
	   
	   $n = $polygon->getN();

	   $xmin = $vertices[0]->x;
	   $xmax = $vertices[0]->x;
	   $ymin = $vertices[0]->y;
	   $ymax = $vertices[0]->y;
	   $zmin = $vertices[0]->z;	  
	   $zmax = $vertices[0]->z;

	   for ($i = 1; $i < $n; $i ++ )
	   {
		  if ($vertices[$i]->x < $xmin) $xmin = $vertices[$i]->x;
		  if ($vertices[$i]->y < $ymin) $ymin = $vertices[$i]->y;
		  if ($vertices[$i]->z < $zmin) $zmin = $vertices[$i]->z;
		  if ($vertices[$i]->x > $xmax) $xmax = $vertices[$i]->x;
		  if ($vertices[$i]->y > $ymax) $ymax = $vertices[$i]->y;
		  if ($vertices[$i]->z > $zmax) $zmax = $vertices[$i]->z;
	   }
	   
	   // double
	   $this->x0 = $xmin;  
	   $this->x1 = $xmax;
	   $this->y0 = $ymin;
	   $this->y1 = $ymax;
	   $this->z0 = $zmin;
	   $this->z1 = $zmax;

	}

	// private Instance method
	private function Set3DPolygonUnitError()
	{			   
	   $avarageError = (abs($this->x0) + abs($this->x1) +
						abs($this->y0) + abs($this->y1) +
						abs($this->z0) + abs($this->z1)) / 6; 											
	   $this->MaxDisError = $avarageError * $this->MaxUnitMeasureError;	   
	}

	// private Instance method
	private function SetConvex3DFaces($polygon) // $polygon: GeoPolygon 
	{
	   // alloc instance array memory
	   $this->Faces = [];       // GeoFace Array	   	   
	   $this->FacePlanes = [];  // GeoPlane Array 
	   
	   // local 2d integer array memory, only declare as 1d array with face index as major array index
	   // push minor face indexes 1d array as its element later
	   // vertices indexes for all faces
	   // vertices index is the original index value in the input polygon	   
	   $faceVerticeIndex = [];   
	   
	   // local GeoPlane array memory
	   // face planes for all faces	   
	   $fpOutward = [];   
	   	  
	   // vertices of polygon
	   $vertices = $polygon->getV(); // GeoPoint Array 
	   	 
	   // number of polygon vertices 
	   $n = $polygon->getN();
	  	   	  
	   for($i = 0; $i < $n; $i ++ )
	   {

		  // triangle point 1		  		  
		  $p0 = $vertices[$i]; 
		  
		  for($j = $i + 1; $j < $n; $j ++ )
		  {

			 // triangle point 2			 
			 $p1 = $vertices[$j];
			 
			 for($k = $j + 1; $k < $n; $k ++ )
			 {

				// triangle point 3				
				$p2 = $vertices[$k];
				
				$trianglePlane = GeoPlane::Create($p0, $p1, $p2);

				$onLeftCount = 0;

				$onRightCount = 0;

				// alloc local Integer array memory
				// indexes of points that lie in same plane with face triangle plane
				// new List<int>()
				$pointInSamePlaneIndex = [];            				

				for($l = 0; $l < $n ; $l ++ )
				{

				   // any point other than the 3 triangle points
				   if($l != $i && $l != $j && $l != $k)
				   {
					  // GeoPoint
					  $pt = new GeoPoint($vertices[$l]->x, $vertices[$l]->y, $vertices[$l]->z);
					   					  
					  // double
					  $dis = GeoPlane::Multiple($trianglePlane, $pt);
					 
					  // next point is in the triangle plane
					  if(abs($dis) < $this->MaxDisError)
					  {
						 array_push($pointInSamePlaneIndex, $l);
					  }
					  else
					  {
						 if($dis < 0)
						 {
							$onLeftCount ++ ;
						 }
						 else
						 {
							$onRightCount ++ ;
						 }

					  }
				   }
				}

				// This is a face for a CONVEX 3d polygon.
				// For a CONCAVE 3d polygon, this maybe not a face.
				if($onLeftCount == 0 || $onRightCount == 0)
				{
				   // alloc local Integer array memory				   
				   $verticeIndexInOneFace = [];               				   

				   // triangle plane
				   array_push($verticeIndexInOneFace, $i);
				   array_push($verticeIndexInOneFace, $j);
				   array_push($verticeIndexInOneFace, $k);

				   $m = count($pointInSamePlaneIndex);
				   				  
				   if($m > 0) // there are other vertices in this triangle plane
				   {
					  for($p = 0; $p < $m; $p ++ )
					  {
						array_push($verticeIndexInOneFace, $pointInSamePlaneIndex[$p]);
					  }
				   }

				   // if verticeIndexInOneFace is a new face               
				   if ( ! Utility::ContainsList($faceVerticeIndex, $verticeIndexInOneFace))
				   {
					  // add it in the faceVerticeIndex list
					  array_push($faceVerticeIndex, $verticeIndexInOneFace);

					  // add the trianglePlane in the face plane list fpOutward.
					  if ($onRightCount == 0)
					  {
						array_push($fpOutward, $trianglePlane);
					  }
					  else if ($onLeftCount == 0)
					  {
						array_push($fpOutward, GeoPlane::Negative($trianglePlane));
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
	   
	   $this->NumberOfFaces = count($faceVerticeIndex);
	   
	   for ($i = 0; $i < $this->NumberOfFaces; $i ++ )
	   {
		  		  				  
		  array_push($this->FacePlanes, new GeoPlane(
											$fpOutward[$i]->getA(), $fpOutward[$i]->getB(),
											$fpOutward[$i]->getC(), $fpOutward[$i]->getD() ));
		  
		  // alloc local GeoPoint array memory
		  $gp = [];      		  
		  
		  // alloc local Integer array memory
		  $vi = [];      		  

		  $count = count($faceVerticeIndex[$i]);
		
		  for ($j = 0; $j < $count; $j ++ )
		  {
			 array_push($vi, $faceVerticeIndex[$i][$j]);
			 array_push($gp, new GeoPoint($vertices[ $vi[$j] ]->x,
										  $vertices[ $vi[$j] ]->y,
										  $vertices[ $vi[$j] ]->z));
		  }

		  array_push($this->Faces, new GeoFace($gp, $vi));
	   }	  
	   
	   // free local array memory
	   unset($faceVerticeIndex);
	   unset($fpOutward);
	   unset($pointInSamePlaneIndex);
	   unset($verticeIndexInOneFace);
	   unset($gp);
	   unset($vi);
	   
	   
	}

	// public Instance method
	public function PointInside3DPolygon($x, $y, $z) // $x, $y, $z: GeoPoint 
	{
	   $pt = new GeoPoint($x, $y, $z);

	   for ($i = 0; $i < $this->NumberOfFaces; $i ++ )
	   {

		  $dis = GeoPlane::Multiple($this->FacePlanes[$i], $pt);

		  // If the point is in the same half space with normal vector for any face of the cube,
		  // then it is outside of the 3D polygon
		  if ($dis > 0)
		  {			 
			 return false;
		  }

	   }

	   // If the point is in the opposite half space with normal vector for all 6 faces,
	   // then it is inside of the 3D polygon
	   return true;

	}

}

?>