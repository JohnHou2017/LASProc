module Utility_Module
	
contains
	
	! list: 1d array
	! element: real number 
    subroutine push(list, element)

        implicit none

        integer :: i, isize
        integer, intent(in) :: element
        integer, dimension(:), allocatable, intent(inout) :: list
        integer, dimension(:), allocatable :: clist

        if(allocated(list)) then
            isize = size(list)
            allocate(clist(isize+1))
            do i=1,isize          
				clist(i) = list(i)
            end do
            clist(isize+1) = element
            deallocate(list)
            call move_alloc(clist, list)
        else
            allocate(list(1))
            list(1) = element
        end if

    end subroutine push
		
	! list: a 2d array
	! element: a 1d array
	! all element must have same size
	subroutine push2d(list, element)

        implicit none

        integer :: i, j, isize, esize
        integer, dimension(:), intent(in) :: element
        integer, dimension(:,:), allocatable, intent(inout) :: list
        integer, dimension(:,:), allocatable :: clist

        if(allocated(list)) then
			esize = size(element)
            isize = size(list)/esize;		

            allocate(clist(isize+1, esize))			

            do i=1,isize
				do j=1, esize
					clist(i,j) = list(i,j)					
				end do
            end do        
			
			do i=1, esize
				clist(isize+1, i) = element(i)				
			end do
            			
			deallocate(list)
			
            call move_alloc(clist, list)
        else
			esize = size(element)
            allocate(list(1, esize))
			do i=1,esize          
				list(1, i) = element(i)
            end do            
        end if

    end subroutine push2d
	
	subroutine sortArray(array)
		implicit none
		
		integer, dimension(:), intent(inout) :: array
		integer :: i, j, isize
		integer :: temp
				
		isize = size(array)
		
		if (isize .gt. 1) then
			do i = 1, isize - 1
				do j = i + 1, isize				
					if(array(i) > array(j)) then
						temp = array(j)
						array(j) = array(i)
						array(i) = temp		
					end if
				end do
			end do
		end if		
	end subroutine sortArray
	
	! check if 2d array list contains first esize elements in 1d array element
	! esize <= size(element)
	logical function list2dContains(list, element, esize) result(isContains)

        implicit none

        integer :: i, j, isize				
		integer :: temp
		integer, dimension(:), allocatable :: tempListPart, tempElement	
		
		integer :: esize
        integer, dimension(:), intent(in) :: element
        integer, dimension(:,:), allocatable, intent(in) :: list       
		        		
        isize = size(list)/esize			
        
		isContains = .false.				
		
		if ( (size(list) .ge. esize) .and. &
		     (esize .gt. 1) .and. &
			 (mod(size(list), esize) .eq. 0) ) then
			
			allocate(tempListPart(esize))
			allocate(tempElement(esize))
			
			do i=1, esize
				tempElement(i) = element(i)
			end do
									
			call sortArray(tempElement)
						
			do i=1,isize
												
				do j=1, esize					
					tempListPart(j) = list(i, j)
				end do
				
				call sortArray(tempListPart)
				
				isContains = .true.
				
				do j=1, esize
					if (tempListPart(j) .ne. tempElement(j)) then
						isContains = .false.
						exit
					end if
				end do
				
				if(isContains) exit
				
			end do  
			
			deallocate(tempListPart)
			deallocate(tempElement)
			
		end if
								
    end function list2dContains

end module Utility_Module