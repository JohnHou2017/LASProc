<?php
class GeoPoint
{
	
    public $x;
	public $y;
	public $z;
		
	public function __construct($x, $y, $z)	// double x, y, z
	{
	   $this->x = $x;
	   
	   $this->y = $y;
	   
	   $this->z = $z;
	   
	}

	// public static function to simulate binary operator add overloading: (GeoPoint + GeoPoint)
	public static function Add(GeoPoint $p0, GeoPoint $p1) 
	{
	   return new GeoPoint($p0->x + $p1->x, $p0->y + $p1->y, $p0->z + $p1->z);
	}
}


?>
