#!/usr/bin/perl 

package Utility;

use strict;
use warnings;
use experimental 'smartmatch';

use constant false => 0;
use constant true  => 1;

# check if 2D array [[]] arr2d contains 1d array [] arr1d.
sub ContainsArray 
{
	my ($this, $arr2d, $arr1d) = @_;
				  	
	my @arr2d_ref = @$arr2d;
	my @arr1d_ref = @$arr1d;
	
	my $count = scalar @arr2d_ref;		
	
	my @sortedItem = sort { $a <=> $b } @arr1d_ref;
	
    for (my $i = 0; $i < $count; $i++)
    {	
		my $temp = $arr2d_ref[$i];		
		my @currItem = sort { $a <=> $b } @$temp;				
		if(@currItem ~~ \@sortedItem)
		{			
			return true;
		}		
    }
	
    return false;
}

1;