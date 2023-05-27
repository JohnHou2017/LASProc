#!/usr/bin/perl 

package GeoPolygon;

use strict;
use warnings;

sub new 
{
	my ($class, $pts) = @_;
				
    my $this = {};    
    
	my @pts_ref = @$pts;
	
	$this->{n} = scalar @pts_ref;
	
	$this->{v} = [];
	
	$this->{idx} = [];
			
	for(my $i=0; $i<$this->{n}; $i++)
	{		
		$this->{v}[$i] = $pts_ref[$i];		
		$this->{idx}[$i] = $i;		
	}
	
	bless $this, $class;		
    return $this;
}

1;
