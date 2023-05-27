#!/usr/bin/perl 

package GeoPoint;

use strict;
use warnings;

sub new 
{
    my $class = shift;
    my $self = {
        x => shift,
        y => shift,
        z => shift,
    };   
    bless $self, $class;
    return $self;
}
	
use overload "+" => \&Add, "-" => \&Substract;

sub Add 
{
	my $p0 = shift;
	my $p1 = shift;
	return new GeoPoint($p0->{x} + $p1->{x}, $p0->{y} + $p1->{y}, $p0->{z} + $p1->{z});
}

sub Substract 
{
	my $p0 = shift;
	my $p1 = shift;
	return new GeoPoint($p0->{x} - $p1->{x}, $p0->{y} - $p1->{y}, $p0->{z} - $p1->{z});
}

1;
