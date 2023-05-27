module GeoFace_Module       
	use GeoPoint_Module
	use Utility_Module
	
    implicit none
	
	! data member
    type GeoFace
    	type(GeoPoint), dimension(:), allocatable :: pts
    	integer, dimension(:), allocatable :: idx
    	integer :: n											
    end type GeoFace 

	! constructor
    interface GeoFace
    	module procedure new_GeoFace
  	end interface GeoFace
  	
contains
		
	type(GeoFace) function new_GeoFace(ptsIn, idxIn) result(this)
		implicit none
		type(GeoPoint), dimension(:), intent(in) :: ptsIn
		integer, dimension(:), intent(in) :: idxIn
		integer :: i, isize		
		
		isize = size(ptsIn)
		
		this%n = isize
		
		allocate(this%idx(isize))
		allocate(this%pts(isize))
    	
		do i = 1, isize						
			this%pts(i) = ptsIn(i)
			this%idx(i) = idxIn(i)
		end do
		
  	end function new_GeoFace
	
	subroutine destructor(this)
		implicit none
        type(GeoFace) :: this        
        if (allocated(this % pts)) deallocate(this % pts)
		if (allocated(this % idx)) deallocate(this % idx)
    end subroutine    
  	
  
end module GeoFace_Module