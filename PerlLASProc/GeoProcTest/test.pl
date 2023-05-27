#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

use lib '../GeoProc';
use GeoPoint;
use GeoVector;
use GeoPlane;
use GeoPolygon;
use GeoFace;
use Utility;
use GeoPolygonProc;

my $p1 = new GeoPoint( - 27.28046,  37.11775,  - 39.03485);
my $p2 = new GeoPoint( - 44.40014,  38.50727,  - 28.78860);
my $p3 = new GeoPoint( - 49.63065,  20.24757,  - 35.05160);
my $p4 = new GeoPoint( - 32.51096,  18.85805,  - 45.29785);
my $p5 = new GeoPoint( - 23.59142,  10.81737,  - 29.30445);
my $p6 = new GeoPoint( - 18.36091,  29.07707,  - 23.04144);
my $p7 = new GeoPoint( - 35.48060,  30.46659,  - 12.79519);
my $p8 = new GeoPoint( - 40.71110,  12.20689,  - 19.05819);
my $ptsArray = [$p1, $p2, $p3, $p4, $p5, $p6, $p7, $p8];
my $polygon = new GeoPolygon($ptsArray);

print "GeoPoint Test:\n";
my $pt = $p1 + $p2;
print(Dumper($pt));
print $pt->{x} .",". $pt->{y} .",". $pt->{z} ."\n";

print "GeoVector Test:\n";
my $v1 = new GeoVector($p1, $p2);
my $v2 = new GeoVector($p1, $p3);
my $v3 = $v2 * $v1;
printf("%.3f, %.3f, %.3f\n", $v3->getX(), $v3->getY(), $v3->getZ());

print "GeoPlane Test:\n";
my $pl = GeoPlane->Create($p1, $p2, $p3);
printf("%.3f, %.3f, %.3f, %.3f\n", $pl->{a}, $pl->{b}, $pl->{c}, $pl->{d});
$pl = new GeoPlane(1.0, 2.0, 3.0, 4.0);
printf("%.3f, %.3f, %.3f, %.3f\n", $pl->{a}, $pl->{b}, $pl->{c}, $pl->{d});
$pl = -$pl;
printf("%.3f, %.3f, %.3f, %.3f\n", $pl->{a}, $pl->{b}, $pl->{c}, $pl->{d});
my $dis = $pl->Multiple(new GeoPoint(1.0, 2.0, 3.0));
printf("%.3f\n", $dis);

print "GeoPolygon Test:\n";
for(my $i=0; $i<$polygon->{n}; $i++)
{
	print $polygon->{idx}[$i] .": (". $polygon->{v}[$i]->{x} .", ". 
		  $polygon->{v}[$i]->{y} .", ". $polygon->{v}[$i]->{z} .")\n"; 
}

print "GeoFace Test:\n";
my $faceVerticesArray = [$p1, $p2, $p3, $p4];
my $faceVerticeIndexArray = [1, 2, 3, 4];
my $face = new GeoFace($faceVerticesArray, $faceVerticeIndexArray);
for(my $i=0; $i<$face->{n}; $i++)
{
	print $face->{idx}[$i] .": (". $face->{v}[$i]->{x} .", ". 
		  $face->{v}[$i]->{y} .", ". $face->{v}[$i]->{z} .")\n"; 
}

print "Utility Test:\n";
my $arr1 = [1, 2, 3, 4];	
my $arr2 = [4, 5, 6, 7];	
my $arr2d = [];
push(@$arr2d, $arr1);
push(@$arr2d, $arr2);
my $arr3 = [2, 3, 1, 4];
my $arr4 = [2, 3, 1, 5];
my $b1 = Utility->ContainsArray($arr2d, $arr3);
my $b2 = Utility->ContainsArray($arr2d, $arr4);
print $b1 .", ". $b2 ."\n";
	
print "GeoPolygonProc Test:\n";
my $procObj = new GeoPolygonProc($polygon);
print $procObj->{x0} .", ". $procObj->{x1} .", ". $procObj->{y0} .", ".
	  $procObj->{y1} .", ". $procObj->{z0} .", ". $procObj->{z1} ."\n";
printf("%.6f\n", $procObj->{maxDisError});
$procObj->UpdateMaxError(0.0125);
printf("%.6f\n", $procObj->{maxDisError});
print $procObj->{NumberOfFaces}."\n";
print "Face Planes:\n";
for(my $i=0; $i<$procObj->{NumberOfFaces}; $i++)
{
	my $facePlane = $procObj->{FacePlanes}[$i];
	printf("%d%s\n", $i+1, ": ".$facePlane->{a}.", ".$facePlane->{b}.", ".
	                            $facePlane->{c}.", ".$facePlane->{d});
}
print "Faces:\n";
for(my $j=0; $j<$procObj->{NumberOfFaces}; $j++)
{
	printf("%s%d:\n", "Face ", $j + 1);
	my $face = $procObj->{Faces}[$j];			
	for(my $i=0; $i<$face->{n}; $i++)
	{
		printf("%d%s\n", $face->{idx}[$i], ": (". $face->{v}[$i]->{x} .", ".
			             $face->{v}[$i]->{y} .", ". $face->{v}[$i]->{z} .")");	
	}
}
my $insidePoint = new GeoPoint(-28.411750, 25.794500, -37.969000);
my $outsidePoint = new GeoPoint(-28.411750, 25.794500, -50.969000);
$b1 = $procObj->PointInside3DPolygon($insidePoint->{x}, $insidePoint->{y}, $insidePoint->{z});
$b2 = $procObj->PointInside3DPolygon($outsidePoint->{x}, $outsidePoint->{y}, $outsidePoint->{z});
print $b1.", ".$b2;