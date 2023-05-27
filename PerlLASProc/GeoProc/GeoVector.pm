#!/usr/bin/perl 

package GeoVector;

use strict;
use warnings;

sub new 
{
    my $class = shift;
    my $self = {
		p0 => shift,
		p1 => shift,		
    };   
    bless $self, $class;
    return $self;
}

sub getX 
{
	my $self = shift;	
	return $self->{p1}->{x} - $self->{p0}->{x};
} 

sub getY 
{
	my $self = shift;		
	return $self->{p1}->{y} - $self->{p0}->{y};
} 

sub getZ 
{
	my $self = shift;	
	return $self->{p1}->{z} - $self->{p0}->{z};
} 
	
use overload "*" => \&Multiple;

sub Multiple 
{
	my $u = shift;
	my $v = shift;		
		
	my $x = $u->getY() * $v->getZ() - $u->getZ() * $v->getY();
	my $y = $u->getZ() * $v->getX() - $u->getX() * $v->getZ();
	my $z = $u->getX() * $v->getY() - $u->getY() * $v->getX();				
		
	my $p0 = $v->{p0};
	my $p1 = $p0 + new GeoPoint($x, $y, $z);
	
	return new GeoVector($p0, $p1);	
}

1;
