module GeoPoint_Module             
    implicit none
	
	! data member
    type GeoPoint
    	real :: x
    	real :: y
    	real :: z 
    end type GeoPoint 

	! constructor
    interface GeoPoint
    	module procedure new_GeoPoint
  	end interface
  
	! operator overloading
    interface operator (+)
    	procedure add
    end interface operator (+)    

contains

	type(GeoPoint) function new_GeoPoint(x, y, z) result(pt)
		implicit none
    	real, intent(in) :: x
    	real, intent(in) :: y
    	real, intent(in) :: z    	
    
    	pt%x = x
    	pt%y = y
    	pt%z = z		
  	end function
  	
    type(GeoPoint) function add(p1, p2) result(pt)
		implicit none
        type(GeoPoint), intent(in) :: p1
        type(GeoPoint), intent(in) :: p2          
          
        pt%x = p1%x + p2%x
        pt%y = p1%y + p2%y
        pt%z = p1%z + p2%z		
    end function add             
       
end module GeoPoint_Module