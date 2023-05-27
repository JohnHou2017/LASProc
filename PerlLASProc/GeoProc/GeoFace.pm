#!/usr/bin/perl 

package GeoFace;

use strict;
use warnings;

sub new 
{
	my ($class, $pts, $ptsIdx) = @_;
				
    my $this = {};    
    
	my @pts_ref = @$pts;
	my @ptsIdx_ref = @$ptsIdx;
	
	$this->{n} = scalar @pts_ref;
	
	$this->{v} = [];
	
	$this->{idx} = [];
			
	for(my $i=0; $i<$this->{n}; $i++)
	{				
		push(@{$this->{v}}, $pts_ref[$i]);
		push(@{$this->{idx}}, $ptsIdx_ref[$i]);	
	}
	
	bless $this, $class;		
    return $this;
}

1;