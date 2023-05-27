<?php

require_once ('./GeoPoint.php');
require_once ('./GeoVector.php');
require_once ('./GeoPlane.php');
require_once ('./GeoPolygon.php');
require_once ('./GeoFace.php');
require_once ('./GeoPolygonProc.php');

echo PHP_EOL . "GeoPoint.php Test" . PHP_EOL;

$p0 = new GeoPoint(1, 2, 3);
$p1 = new GeoPoint(2, 3, 4);
$p2 = GeoPoint::Add($p0,$p1);
echo $p2->x. ', ' . $p2->y . ', ' . $p2->z . PHP_EOL;
 

echo PHP_EOL . "GeoVector.php Test" . PHP_EOL;

$v1 = new GeoVector(new GeoPoint(1, 2, 3), new GeoPoint(4, 6, 8));
$v2 = new GeoVector(new GeoPoint(1, 2, 3), new GeoPoint(15, 17, 29));
$v3 = GeoVector::Multiple($v2, $v1);
$str = $v3->getX().PHP_EOL;
$str = $str.$v3->getY().PHP_EOL;
$str = $str.$v3->getZ();
echo $str . PHP_EOL;


echo PHP_EOL . "GeoPlane.php Test" . PHP_EOL;

$p1 = new GeoPoint( - 27.28046,  37.11775,  - 39.03485);
$p2 = new GeoPoint( - 44.40014,  38.50727,  - 28.78860);
$p3 = new GeoPoint( - 49.63065,  20.24757,  - 35.05160);
$p4 = new GeoPoint( - 32.51096,  18.85805,  - 45.29785);
$p5 = new GeoPoint( - 23.59142,  10.81737,  - 29.30445);
$p6 = new GeoPoint( - 18.36091,  29.07707,  - 23.04144);
$p7 = new GeoPoint( - 35.48060,  30.46659,  - 12.79519);
$p8 = new GeoPoint( - 40.71110,  12.20689,  - 19.05819);
$plInst = GeoPlane::Create($p1, $p2, $p3); 
echo $plInst->getA().','.$plInst->getB().','.$plInst->getC().','.$plInst->getD() . PHP_EOL;
$plInst = new GeoPlane($plInst->getA(), $plInst->getB(), $plInst->getC(), $plInst->getD());
echo $plInst->getA() . ',' . $plInst->getB() . ',' . $plInst->getC() . ',' . $plInst->getD() . PHP_EOL;
$plInst = GeoPlane::Negative($plInst);
echo $plInst->getA().','.$plInst->getB().','.$plInst->getC().','.$plInst->getD() . PHP_EOL;
$result = GeoPlane::Multiple($plInst, $p4);
echo $result . PHP_EOL;
$result = GeoPlane::Multiple($plInst, $p3);
echo $result . PHP_EOL;


echo PHP_EOL . "GeoPolygon.php Test" . PHP_EOL;

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
echo $gpInst->getN() . PHP_EOL;
$str = "";
$v = $gpInst->getV();
for($i = 0; $i < $gpInst->getN(); $i ++ )
{
  $str = $str . $v[$i]->x . ',';
}
echo $str . PHP_EOL;


echo PHP_EOL . "GeoFace.php Test" . PHP_EOL;

$p1 = new GeoPoint( - 27.28046,  37.11775,  - 39.03485);
$p2 = new GeoPoint( - 44.40014,  38.50727,  - 28.78860);
$p3 = new GeoPoint( - 49.63065,  20.24757,  - 35.05160);
$p4 = new GeoPoint( - 32.51096,  18.85805,  - 45.29785);
$p5 = new GeoPoint( - 23.59142,  10.81737,  - 29.30445);
$p6 = new GeoPoint( - 18.36091,  29.07707,  - 23.04144);
$p7 = new GeoPoint( - 35.48060,  30.46659,  - 12.79519);
$p8 = new GeoPoint( - 40.71110,  12.20689,  - 19.05819);
$gp = [$p1, $p3, $p5, $p7];
$idx = [1, 3, 5, 7];
$gfInst = new GeoFace($gp, $idx);
$str = "";
for($i = 0; $i < $gfInst->getN(); $i ++ )
{
  $str = $str + $gfInst->getV()[$i]->x + ',';
}
echo $str . PHP_EOL;
 

echo PHP_EOL . "Utility.php Test" . PHP_EOL;

//$listList = [array(1, 2, 3), array(4, 5, 6)];
$listList = [];
$a1 = [];
array_push($a1, 1);
array_push($a1, 2);
array_push($a1, 3);
$a2 = [];
array_push($a2, 4);
array_push($a2, 5);
array_push($a2, 6);
array_push($listList, $a1);
array_push($listList, $a2);
$listItem1 = [2, 3, 1];
$listItem2 = [2, 3, 6];
$contain1 = Utility::ContainsList($listList, $listItem1) ? 'true' : 'false';
$contain2 = Utility::ContainsList($listList, $listItem2) ? 'true' : 'false';
echo $contain1 . ', ' . $contain2 . PHP_EOL;
 
 
echo PHP_EOL . "GeoPolygonProc.php Test" . PHP_EOL;

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
$gppInst = new GeoPolygonProc($gpInst);
$str = "";
$str = $str . number_format($gppInst->MaxDisError, 6, '.', '') . PHP_EOL;
$str = $str . $gppInst->getX0() . ',' . $gppInst->getX1() . ',' . $gppInst->getY0() . ',' . $gppInst->getY1() . ',' . $gppInst->getZ0() . ',' . $gppInst->getZ1() . PHP_EOL;
$str = $str . $gppInst->getNumberOfFaces() . PHP_EOL;
for ($i = 0; $i < $gppInst->getNumberOfFaces(); $i ++ )
{
  $str = $str . $gppInst->getFacePlanes()[$i]->getA() . ',' . $gppInst->getFacePlanes()[$i]->getB() . ',' .                 
                $gppInst->getFacePlanes()[$i]->getC() . ',' . $gppInst->getFacePlanes()[$i]->getD() . PHP_EOL;
}
$insidePoint = new GeoPoint( - 28.411750,     25.794500,      - 37.969000);
$outsidePoint = new GeoPoint( - 28.411750,    25.794500,      - 50.969000);
$inside = $gppInst->PointInside3DPolygon($insidePoint->x, $insidePoint->y, $insidePoint->z);
if($inside) echo 'point is inside' . PHP_EOL; else echo 'point is outside' . PHP_EOL;
$insideStr = $inside ?  'inside' :  'outside';
$str = $str . $insideStr . PHP_EOL;
$inside = $gppInst->PointInside3DPolygon($outsidePoint->x, $outsidePoint->y, $outsidePoint->z);
if($inside) echo 'point is inside' . PHP_EOL; else echo 'point is outside' . PHP_EOL;
$insideStr = $inside ?  'inside' :  'outside';
$str = $str . $insideStr . PHP_EOL;
echo $str;
 
?>