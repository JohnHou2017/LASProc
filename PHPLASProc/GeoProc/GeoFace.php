<?php

class GeoFace
{

	private $v;   // 3D polygon face vertices coordinates: GeoPoint Array
	private $idx; // 3D polygon face vertices indexes: Integer Array
	private $n;   // number of 3D polygon face vertices: Integer
	
	public function getV(){return $this->v;}
	public function getIdx(){return $this->idx;}
	public function getN(){return $this->n;}
	
	// $v: 3D polygon face vertices coordinates: GeoPoint Array 
	// $idx: 3D polygon face vertices index
	public function __construct(array $v, array $idx) 
    {		
	    // alloc instance array memory		
		$this->v = [];		
		$this->idx = [];
		
		$this->n = count($v);
		
		for($i=0; $i< $this->n; $i++)
		{
			array_push($this->v, $v[$i]);
			array_push($this->idx, $idx[$i]);
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
