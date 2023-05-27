#!/usr/bin/perl 

package GeoPlane;

use strict;
use warnings;

use GeoVector;

sub new 
{
    my $class = shift;
    my $self = {
        a => shift,
        b => shift,
        c => shift,
		d => shift,
    };   
    bless $self, $class;
    return $self;
}
	

# Create a GeoPlane from 3 GeoPoint.
# Static method to simulate costructor overloading. 
# Usage: GeoPlane->Create($p0, $p1, $p2);
sub Create
{
	my $self = shift; # current object, GeoPlane

	my $p0 = shift; # parameter 1, GeoPoint
	my $p1 = shift; # parameter 2, GeoPoint
	my $p2 = shift; # parameter 3, GeoPoint		
	
	my $v = new GeoVector($p0, $p1);
	my $u = new GeoVector($p0, $p2);
	my $n = $u * $v;
	
	my $a = $n->getX();
	my $b = $n->getY();
	my $c = $n->getZ();					
	my $d = -($a * $p0->{x} + $b * $p0->{y} + $c * $p0->{z});

	return new GeoPlane($a, $b, $c, $d);
} 
	
use overload "neg" => \&Negative;

# Unary operator '-' overloading
sub Negative 
{
	my $self = shift; # current object, GeoPlane
	return new GeoPlane(-$self->{a}, -$self->{b}, -$self->{c}, -$self->{d});	
}

# Instance method to simulate (GeoPlane * GeoPoint)
# Usage: $dis = $pl->Multiple(new GeoPoint($p0, $p1, $p2));
sub Multiple 
{
	my $pl = shift; # current object, GeoPlane
	my $pt = shift; # parameter 1, GeoPoint
	return $pt->{x} * $pl->{a} + $pt->{y} * $pl->{b} + $pt->{z} * $pl->{c} + $pl->{d};	
}

1;