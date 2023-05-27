#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Fcntl qw(:seek);    

use lib '../GeoProc';
use GeoPoint;
use GeoVector;
use GeoPlane;
use GeoPolygon;
use GeoFace;
use Utility;
use GeoPolygonProc;

# Create GeoPolygonProc object
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
my $procObj = new GeoPolygonProc($polygon);

# LAS File Process

my $rb;
my $wb;
my $wt;
my $value;

my $rbFileName = "../LASInput/cube.las";
my $wbFileName = "../LASOutput/cube_inside.las";
my $wtFileName = "../LASOutput/cube_inside.txt";

open($rb, "<", $rbFileName)
  || die "can't open $rbFileName: $!";
binmode($rb);

open($wb, ">", $wbFileName)
  || die "can't open $wbFileName: $!";
binmode($wb);

open($wt, ">", $wtFileName)
  || die "can't open $wtFileName: $!";

# read LAS header info

sysseek($rb, 96, 0);

sysread($rb, $value, 4);
my $offset_to_point_data_value = unpack('I', $value);
sysread($rb, $value, 4);
sysread($rb, $value, 1);
sysread($rb, $value, 2);
my $record_len = unpack('v', $value);
sysread($rb, $value, 4);
my $record_num = unpack('L', $value);

sysseek($rb, 131, 0);

sysread($rb, $value, 8);
my $x_scale = unpack('d', $value);
sysread($rb, $value, 8);
my $y_scale = unpack('d', $value);
sysread($rb, $value, 8);
my $z_scale = unpack('d', $value);
sysread($rb, $value, 8);
my $x_offset = unpack('d', $value);
sysread($rb, $value, 8);
my $y_offset = unpack('d', $value);
sysread($rb, $value, 8);
my $z_offset = unpack('d', $value);

# read LAS header
sysseek($rb, 0, 0);
sysread($rb, $value, $offset_to_point_data_value);

# write LAS header
syswrite($wb, $value);

my $insideCount = 0;

my ($i, $record_loc, $xi, $yi, $zi, $x, $y, $z);

for($i=0; $i<$record_num; $i++)
{                            
    $record_loc = $offset_to_point_data_value + $record_len * $i;
    sysseek($rb, $record_loc, 0);   
    sysread($rb, $value, 4);
	$xi = unpack('l', $value);
	sysread($rb, $value, 4);
	$yi = unpack('l', $value);
	sysread($rb, $value, 4);
	$zi = unpack('l', $value);
	$x = $xi * $x_scale + $x_offset;
	$y = $yi * $y_scale + $y_offset;
	$z = $zi * $z_scale + $z_offset;
	
	if ($x > $procObj->{x0} && $x < $procObj->{x1} &&
		$y > $procObj->{y0} && $x < $procObj->{y1} &&
		$z > $procObj->{z0} && $x < $procObj->{z1} )
    {
		if ($procObj->PointInside3DPolygon($x, $y, $z))
		{
			# read LAS Point record
			sysseek($rb, $record_loc, 0);   
			sysread($rb, $value, $record_len);
			
			# write LAS Point record
			syswrite($wb, $value);
			                
            # write text LAS Point record
            $wt->printf("%15.6f %15.6f %15.6f\n", $x, $y, $z);

            $insideCount++;
		}
	}
    
	
}	

# update record_num in LAS header with actual writting point records number	
sysseek($wb, 107, 0);  
syswrite($wb, pack('I', $insideCount));
	
$rb->close();
$wb->close();
$wt->close();