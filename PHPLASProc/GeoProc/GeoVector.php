<?php

require_once ('GeoPoint.php');

class GeoVector
{
    private $p0; // vector begin point
	private $p1; // vector end point
    private $x; // vector x axis projection value
    private $y; // vector y axis projection value
    private $z; // vector z axis projection value
    
    public function getP0() {return $this->p0;}
    public function getP1() {return $this->p1;}    
	public function getX() {return $this->x;} 
	public function getY() {return $this->y;} 
	public function getZ() {return $this->z;}  
		
	public function __construct(GeoPoint $p0, GeoPoint $p1)
	{
		$this->p0 = $p0;
		$this->p1 = $p1;			
		$this->x = $p1->x - $p0->x;
		$this->y = $p1->y - $p0->y;
		$this->z = $p1->z - $p0->z;
	}		

	// public Instance method to simulate binary operator multiple overloading: (GeoVector * GeoVector)
	public static function Multiple(GeoVector $u, GeoVector $v) 
	{
	   $x = $u->y * $v->z - $u->z * $v->y;
	   
	   $y = $u->z * $v->getX() - $u->x * $v->getZ();
	   
	   $z = $u->x * $v->getY() - $u->y * $v->getX();
	   
	   $p0 = $v->getP0(); // GeoPoint
	   
	   $p1 = GeoPoint::Add($p0, new GeoPoint($x, $y, $z)); // GeoPoint
	  
	   return new GeoVector($p0, $p1);
	}	
	
}	

?>