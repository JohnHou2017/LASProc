module GeoPolygon_Module       
	use GeoPoint_Module
	use Utility_Module
	
    implicit none
	
	! data member
    type GeoPolygon
    	type(GeoPoint), dimension(:), allocatable :: pts
    	integer, dimension(:), allocatable :: idx
    	integer :: n											
    end type GeoPolygon 

	! constructor
    interface GeoPolygon
    	module procedure new_GeoPolygon
  	end interface
  	
contains
		
	type(GeoPolygon) function new_GeoPolygon(ptsIn) result(this)
		implicit none
		type(GeoPoint), dimension(:), intent(in) :: ptsIn
		integer :: i, isize		
		
		isize = size(ptsIn)
		
		this%n = isize
		
		allocate(this%idx(isize))
		allocate(this%pts(isize))
    	
		do i = 1, isize						
			this%pts(i) = ptsIn(i)
			this%idx(i) = i
		end do
		
  	end function new_GeoPolygon
	
	subroutine destructor(this)
		implicit none
        type(GeoPolygon) :: this        
        if (allocated(this % pts)) deallocate(this % pts)
		if (allocated(this % idx)) deallocate(this % idx)
    end subroutine    
  	
  
end module GeoPolygon_Module