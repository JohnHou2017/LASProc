<?php

class GeoPolygon 
{

	private $v;   // 3D polygon vertices coordinates: GeoPoint Array
	private $idx; // 3D polygon vertices indexes: Integer Array
	private $n;   // number of 3D polygon vertices: Integer
	
	public function getV(){return $this->v;}
	public function getIdx(){return $this->idx;}
	public function getN(){return $this->n;}
	
	public function __construct($v) // $v: polygon vertices coordinates: GeoPoint Array 
    {		
	    // alloc instance array memory		
		$this->v = [];				
		
		$this->idx = [];		
		
		$this->n = count($v);
		
		for($i=0; $i< $this->n; $i++)
		{
			array_push($this->v, $v[$i]);
			array_push($this->idx, $i);
		}			
	}
	
	public function __destruct()
	{
		// free instance array memory		
		unset($this->v);				
		unset($this->idx);
		
	}
		   
}

?>

