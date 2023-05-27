module GeoPlane_Module       
	use GeoPoint_Module
	use GeoVector_Module
	
    implicit none
	
	! Plane Equation: a * x + b * y + c * z + d = 0
	
	! data member
    type GeoPlane
    	real :: a
    	real :: b
    	real :: c
		real :: d
		contains
			procedure :: initGeoPlane									
    end type GeoPlane 

	! constructor
    interface GeoPlane
    	module procedure new_GeoPlane
  	end interface
  
	! operator overloading
    interface operator (*)
    	procedure multiplePoint
    end interface operator (*)    
	
	interface operator (-)
		module procedure negative
	end interface operator (-)

contains
	
	subroutine initGeoPlane(this, p0, p1, p2)
		implicit none
		class(GeoPlane) :: this
		type(GeoPoint) :: p0, p1, p2
		
		type(GeoVector) :: u, v, n

		v = GeoVector(p0, p1);

		u = GeoVector(p0, p2);

		n = u * v;

		! normal vector		
		this%a = get_x(n);
		this%b = get_y(n);
		this%c = get_z(n);		

		this%d = -(this%a * p0%x + this%b * p0%y + this%c * p0%z);
	end subroutine initGeoPlane

	type(GeoPlane) function new_GeoPlane(a, b, c, d) result(pl)
		implicit none
    	real, intent(in) :: a
    	real, intent(in) :: b
    	real, intent(in) :: c   	
		real, intent(in) :: d
    
    	pl%a = a
    	pl%b = b
    	pl%c = c
		pl%d = d		
  	end function
  	
    real function multiplePoint(pl, pt) result(ret)
		implicit none
        type(GeoPlane), intent(in) :: pl
        type(GeoPoint), intent(in) :: pt        
        
		ret = pt%x * pl%a + pt%y * pl%b + pt%z * pl%c + pl%d      	
    end function multiplePoint   

	type(GeoPlane) function negative(this) result(pl)
		implicit none
		type(GeoPlane), intent(in) :: this
    	    
    	pl%a = -this%a
    	pl%b = -this%b
    	pl%c = -this%c
		pl%d = -this%d		
  	end function	
       
end module GeoPlane_Module