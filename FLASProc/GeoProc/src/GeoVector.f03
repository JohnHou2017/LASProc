module GeoVector_Module       
    use GeoPoint_Module
	
    implicit none
	
	! data member
    type GeoVector
		private
			type(GeoPoint) :: p0
			type(GeoPoint) :: p1
			real :: x
			real :: y
			real :: z		
    end type GeoVector 			

	! constructor
    interface GeoVector
    	module procedure new_GeoVector
  	end interface
  
	! operator overloading
    interface operator (*)
    	procedure multiple
    end interface operator (*)    
		
contains

	type(GeoVector) function new_GeoVector(p0, p1) result(vt)
		implicit none
    	type(GeoPoint), intent(in) :: p0
		type(GeoPoint), intent(in) :: p1    		
    
    	vt%p0 = p0
		vt%p1 = p1
		vt%x = p1%x - p0%x
		vt%y = p1%y - p0%y
		vt%z = p1%z - p0%z 		
  	end function
  	
    type(GeoVector) function multiple(v1, v2) result(vt)
		implicit none
        type(GeoVector), intent(in) :: v1
        type(GeoVector), intent(in) :: v2      
		
		vt%x = v1%y * v2%z - v1%z * v2%y
		vt%y = v1%z * v2%x - v1%x * v2%z
		vt%z = v1%x * v2%y - v1%y * v2%x
							
		vt%p0 = v1%p0
		vt%p1 = vt%p0 + GeoPoint(vt%x, vt%y, vt%z);
						
    end function multiple          

	real function get_x(vt) result(ret)
		implicit none
		type(GeoVector) :: vt		
		ret = vt%x
	end function get_x
	
	real function get_y(vt) result(ret)
		implicit none
		type(GeoVector) :: vt		
		ret = vt%y
	end function get_y
	
	real function get_z(vt) result(ret)
		implicit none
		type(GeoVector) :: vt		
		ret = vt%z
	end function get_z
       
end module GeoVector_Module