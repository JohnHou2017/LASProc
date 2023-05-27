<?php

require_once ('GeoPoint.php');
require_once ('GeoVector.php');

class GeoPlane
{
	
	// Plane Equation: a * x + b * y + c * z + d = 0

	private $a;
	private $b;
	private $c;
	private	$d;	
	
	// public instance function to simulate class property getter
	public function getA() {return $this->a;}
	public function getB() {return $this->b;}
	public function getC() {return $this->c;}
	public function getD() {return $this->d;}
	
	// Constructor
	public function __construct($a, $b, $c, $d) // double a, b, c, d
	{
	   $this->a = $a;
	   
	   $this->b = $b;
	   
	   $this->c = $c;
	   
	   $this->d = $d;   
	}

	// public static function to simulate constructor overloading
	public static function Create(GeoPoint $p0, GeoPoint $p1, GeoPoint $p2) // GeoPoint p0, p1, p2
	{
	   $v = new GeoVector($p0, $p1);

	   $u = new GeoVector($p0, $p2);

	   // normal vector. 
	   $n = GeoVector::Multiple($u, $v); // GeoVector

	   $a = $n->getX(); // double

	   $b = $n->getY(); // double

	   $c = $n->getZ(); // double

	   $d = - ($a * $p0->x + $b * $p0->y + $c * $p0->z); // double
	   
	   return new GeoPlane($a, $b, $c, $d);
	}

    // Simulate uary operator negative overloading: -GeoPlane
	public static function Negative(GeoPlane $pl)
	{
	   return new GeoPlane( - $pl->getA(), - $pl->getB(), - $pl->getC(), - $pl->getD());
	}

	// Simulate binary operator multiple overloading binary operator multiple: GeoPlane * GeoPoint
	public static function Multiple(GeoPlane $pl, GeoPoint $pt) 
	{			
	   return ($pl->getA() * $pt->x + $pl->getB() * $pt->y + $pl->getC() * $pt->z + $pl->getD()); // double   
	}
	
}

?>