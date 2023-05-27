<?php

// include files
require_once ('../GeoProc/GeoPoint.php');
require_once ('../GeoProc/GeoVector.php');
require_once ('../GeoProc/GeoPlane.php');
require_once ('../GeoProc/GeoPolygon.php');
require_once ('../GeoProc/GeoFace.php');
require_once ('../GeoProc/GeoPolygonProc.php');

// prepare GeoPolygonProc instance $procInst

$p1 = new GeoPoint( - 27.28046,  37.11775,  - 39.03485);
$p2 = new GeoPoint( - 44.40014,  38.50727,  - 28.78860);
$p3 = new GeoPoint( - 49.63065,  20.24757,  - 35.05160);
$p4 = new GeoPoint( - 32.51096,  18.85805,  - 45.29785);
$p5 = new GeoPoint( - 23.59142,  10.81737,  - 29.30445);
$p6 = new GeoPoint( - 18.36091,  29.07707,  - 23.04144);
$p7 = new GeoPoint( - 35.48060,  30.46659,  - 12.79519);
$p8 = new GeoPoint( - 40.71110,  12.20689,  - 19.05819);
$gp = [$p1, $p2, $p3, $p4, $p5, $p6, $p7, $p8];
$gpInst = new GeoPolygon($gp);
$procInst = new GeoPolygonProc($gpInst);

// process LAS file with $procInst

// open LAS file to read
$lasFile = "../LASInput/cube.las";
$rbFile = fopen($lasFile, "rb");

// open LAS file to write
$wbFile = fopen("../LASOutput/cube_inside.las", "wb");

// open Text file to write
$wtFile = fopen("../LASOutput/cube_inside.txt", "w");

// read LAS header parameters in Little-Endian
fseek($rbFile, 96);
$offset_to_point_data_value = unpack('V', fread($rbFile, 4))[1];
$variable_len_num = unpack('V', fread($rbFile, 4))[1];
$record_type = unpack('C', fread($rbFile, 1))[1];
$record_len = unpack('v', fread($rbFile, 2))[1];
$record_num = unpack('V', fread($rbFile, 4))[1];
fseek($rbFile, 131);
$x_scale = unpack('d', fread($rbFile, 8))[1];
$y_scale = unpack('d', fread($rbFile, 8))[1];
$z_scale = unpack('d', fread($rbFile, 8))[1];
$x_offset = unpack('d', fread($rbFile, 8))[1];
$y_offset = unpack('d', fread($rbFile, 8))[1];
$z_offset = unpack('d', fread($rbFile, 8))[1];

// read LAS header
fseek($rbFile, 0);
$headerBuffer = fread($rbFile, $offset_to_point_data_value);

// write LAS public header to LAS
fwrite($wbFile, $headerBuffer);

$insideCount = 0;

// write Point record
for($i = 0; $i < $record_num; $i++)
{
	$record_loc = $offset_to_point_data_value + $record_len * $i;
	
	fseek($rbFile, $record_loc);
    $xi = unpack('l', fread($rbFile, 4))[1];
	$yi = unpack('l', fread($rbFile, 4))[1];
	$zi = unpack('l', fread($rbFile, 4))[1];
    $x = $xi * $x_scale + $x_offset;     
	$y = $yi * $y_scale + $y_offset;
	$z = $zi * $z_scale + $z_offset;
       
	if($x > $procInst->getX0() && $x < $procInst->getX1() &&
	   $y > $procInst->getY0() && $x < $procInst->getY1() &&
	   $z > $procInst->getZ0() && $x < $procInst->getZ1() )
	{					
		// Main Process to check if the point is inside of the cube				
		if($procInst->PointInside3DPolygon($x, $y, $z))
		{										
			// Write the actual coordinates of inside point to text file
			fprintf($wtFile, "%15.6f %15.6f %15.6f \n", $x, $y, $z);					
			
			fseek($rbFile, $record_loc);
			
			// Read LAS point record
			$recordBuffer = fread($rbFile, $record_len);
			// Write LAS point record
			fwrite($wbFile, $recordBuffer);
	
			$insideCount++;
		}													
	}   
	
}
	
// Update total record numbers with actual writting record number in output LAS file header
fseek($wbFile, 107);				
fwrite($wbFile, pack('V', $insideCount), 4);
		
// close files
fclose($rbFile);
fclose($wbFile);
fclose($wtFile);

?>