#!/usr/bin/perl 

package GeoPolygonProc;

use strict;
use warnings;
use Data::Dumper;

use constant false => 0;
use constant true  => 1;

my $MaxUnitMeasureError = 0.001;

sub new 
{
	my ($class, $polygon) = @_;
				
    my $this = {};    
    					
	bless $this, $class;	

	$this->{polygon} = $polygon;
	$this->SetBoundary();	
	$this->SetMaxError();
	$this->SetFacePlanes();
	
    return $this;
}

sub SetBoundary
{
	my ($this) = @_;
	
	my $n = $this->{polygon}->{n};

	my $v = $this->{polygon}->{v};
	
	$this->{x0} = @$v[0]->{x};
	$this->{y0} = @$v[0]->{y};
	$this->{z0} = @$v[0]->{z};
	$this->{x1} = @$v[0]->{x};
	$this->{y1} = @$v[0]->{y};
	$this->{z1} = @$v[0]->{z};	
	
	for (my $i = 1; $i < $n; $i++)
	{
		if (@$v[$i]->{x} < $this->{x0}) {$this->{x0} = @$v[$i]->{x};}
		if (@$v[$i]->{y} < $this->{y0}) {$this->{y0} = @$v[$i]->{y};}
		if (@$v[$i]->{z} < $this->{z0}) {$this->{z0} = @$v[$i]->{z};}
		if (@$v[$i]->{x} > $this->{x1}) {$this->{x1} = @$v[$i]->{x};}
		if (@$v[$i]->{y} > $this->{y1}) {$this->{y1} = @$v[$i]->{y};}
		if (@$v[$i]->{z} > $this->{z1}) {$this->{z1} = @$v[$i]->{z};}		
	}		
	
}

sub SetMaxError
{	
	my ($this) = @_;
	$this->{maxDisError} = (abs($this->{x0}) + abs($this->{x1}) + 
    			            abs($this->{y0}) + abs($this->{y1}) + 
    			            abs($this->{z0}) + abs($this->{z1})) / 6 * $MaxUnitMeasureError; 
		
}

sub SetFacePlanes
{
	my ($this) = @_;
	
	# GeoFace array
	$this->{Faces} = [];

	# GeoPlane array
	$this->{FacePlanes} = [];
		
    $this->{NumberOfFaces} = 0;    	    
    	    
	# Polygon vertices array
    my $vertices = $this->{polygon}->{v};

	# number of vertices of polygon	
	my $n = $this->{polygon}->{n};	

    # vertices indexes 2d array for all faces, 
	# face index is major dimension, face vertice index is minor dimension
    # vertices index is the original index value in the input polygon
	my @faceVerticeIndex = ();
		
    # face planes for all faces
	my $fpOutward = [];
	
	for(my $i=0; $i< $n; $i++)
	{ 	
		# triangle point #1
		my $p0 = @$vertices[$i];

		for(my $j= $i+1; $j< $n; $j++)
		{
			# triangle point #2
			my $p1 = @$vertices[$j];

			for(my $k = $j + 1; $k<$n; $k++)
			{
			
				# triangle point #3
				my $p2 = @$vertices[$k];

				my $trianglePlane = GeoPlane->Create($p0, $p1, $p2);
			
				my $onLeftCount = 0;
				my $onRightCount = 0;

				# Indexes of points that are in same plane with the face triangle plane
				# Integer array
				my $pointInSamePlaneIndex = [];
	
				for(my $l = 0; $l < $n ; $l++)
				{				
					# any points other than the 3 triangle points
					if($l != $i && $l != $j && $l != $k) 
					{
						my $pt = @$vertices[$l];

						my $dis = $trianglePlane->Multiple($pt);
												
						# next point is in the triangle plane
						if(abs($dis) < $this->{maxDisError}) 
						{							
							push(@$pointInSamePlaneIndex, $l);								    
						}
						else
						{
							if($dis < 0)
							{
								$onLeftCount++;								
							}
							else
							{
								$onRightCount++;
							}

						}
					}
				}
		
				# This is a face for a CONVEX 3d polygon. 
				# For a CONCAVE 3d polygon, this maybe not a face.
				if($onLeftCount == 0 || $onRightCount == 0) 
				{
					# Integer array
					my $verticeIndexInOneFace = [];
				   
					# triangle plane
					push(@$verticeIndexInOneFace, $i);
					push(@$verticeIndexInOneFace, $j);
					push(@$verticeIndexInOneFace, $k);			
					
					my $m = scalar @$pointInSamePlaneIndex;

					# there are other vertices in this triangle plane
					if($m > 0) 
					{
						for(my $p = 0; $p < $m; $p++)
						{
							push(@$verticeIndexInOneFace, @$pointInSamePlaneIndex[$p]);
						}						
					}
					
					# if verticeIndexInOneFace is a new face, 
					# add it in the faceVerticeIndex list, 
					# add the trianglePlane in the face plane list fpOutward
					if (!Utility->ContainsArray(\@faceVerticeIndex, $verticeIndexInOneFace))
					{
					
						push(@faceVerticeIndex, $verticeIndexInOneFace);

						if ($onRightCount == 0)
						{
							push(@$fpOutward, $trianglePlane);
						}
						elsif ($onLeftCount == 0)
						{
							push(@$fpOutward, -$trianglePlane);
						}
					}

				}
				else
				{					
					# possible reasons:
					# 1. the plane is not a face of a convex 3d polygon, 
					#    it is a plane crossing the convex 3d polygon.
					# 2. the plane is a face of a concave 3d polygon
				}

			} # k loop
		} # j loop		
	} # i loop                        

	$this->{NumberOfFaces} = scalar @faceVerticeIndex;	
	
    for (my $i = 0; $i < $this->{NumberOfFaces}; $i++)
	{                
		#return face planes
		my $facePlane = new GeoPlane(@$fpOutward[$i]->{a}, @$fpOutward[$i]->{b}, 
									 @$fpOutward[$i]->{c}, @$fpOutward[$i]->{d});
									 
		#set FacePlanes
		push(@{$this->{FacePlanes}}, $facePlane);
		
		#GeoPoint array
		my $v = [];

		#Integer array
		my $idx = [];
		
		my $faceIdx = $faceVerticeIndex[$i];
		my $count = scalar @$faceIdx;
				
		for (my $j = 0; $j < $count; $j++)
		{						
			push(@$idx, @$faceIdx[$j]);
			my $k = @$idx[$j];
			my $pt = new GeoPoint(@$vertices[$k]->{x}, @$vertices[$k]->{y}, @$vertices[$k]->{z});
			push(@$v, $pt);											
		}

		#set Faces
		my $face = new GeoFace($v, $idx);
		push(@{$this->{Faces}}, $face);
	}		
}

# public method to update max error
sub UpdateMaxError
{	
	my ($this, $maxError) = @_;
	$this->{maxDisError} = $maxError;
		
}

# public method to check if point is inside 3d polygon
sub PointInside3DPolygon 
{
	my ($this, $x, $y, $z) = @_;
	
	my $pt = new GeoPoint($x, $y, $z);
	     
    for (my $i = 0; $i < $this->{NumberOfFaces}; $i++)
	{		
		my $pl = $this->{FacePlanes}[$i];
	
		my $dis = $pl->Multiple($pt);

		# If the point is in the same half space with normal vector for any face of the cube, 
		# then it is outside of the 3D polygon		
		if ($dis > 0)
		{
			return false;
		}
	}

	# If the point is in the opposite half space with normal vector for all 6 faces, 
	# then it is inside of the 3D polygon
	return true;
        	
}
	
1;