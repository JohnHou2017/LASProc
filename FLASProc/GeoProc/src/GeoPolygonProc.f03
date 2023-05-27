module GeoPolygonProc_Module                 	
	use GeoPoint_Module
	use GeoVector_Module
	use GeoPlane_Module
	use GeoPolygon_Module
	use GeoFace_Module
	use Utility_Module
	
	implicit none
	
	real, parameter :: MaxUnitMeasureError = 0.001
	
	! data member
    type GeoPolygonProc
    	type(GeoPolygon) :: polygon
    	real :: x0
    	real :: x1
		real :: y0
    	real :: y1
		real :: z0
    	real :: z1
		real :: maxError
		type(GeoFace), dimension(:), allocatable :: Faces
		type(GeoPlane), dimension(:), allocatable :: FacePlanes
		integer :: NumberOfFaces
		contains
			procedure :: InitGeoPolygonProc
			procedure :: SetBoundary
			procedure :: SetMaxError
			procedure :: SetFacePlanes
			procedure :: PointInside3DPolygon
			procedure :: UpdateMaxError
    end type GeoPolygonProc 
	
contains

	subroutine InitGeoPolygonProc(this, polygon)
		implicit none
		class(GeoPolygonProc) :: this
		
    	type(GeoPolygon), intent(in) :: polygon    	
    
    	this%polygon = polygon
		
    	call SetBoundary(this)
		call SetMaxError(this)
		call SetFacePlanes(this)
		
  	end subroutine InitGeoPolygonProc
  	
    subroutine SetBoundary(this)
		implicit none
		class(GeoPolygonProc) :: this
		integer :: i, n		
	
		n = this%polygon%n;

		this%x0 = this%polygon%pts(1)%x
		this%y0 = this%polygon%pts(1)%y
		this%z0 = this%polygon%pts(1)%z
		this%x1 = this%polygon%pts(1)%x
		this%y1 = this%polygon%pts(1)%y
		this%z1 = this%polygon%pts(1)%z		
		
		do i = 1, n
			if (this%polygon%pts(i)%x < this%x0) then
				this%x0 = this%polygon%pts(i)%x
			end if
			if (this%polygon%pts(i)%y < this%y0) then
				this%y0 = this%polygon%pts(i)%y
			end if
			if (this%polygon%pts(i)%z < this%z0) then
				this%z0 = this%polygon%pts(i)%z
			end if
			if (this%polygon%pts(i)%x > this%x1) then			
				this%x1 = this%polygon%pts(i)%x
			end if
			if (this%polygon%pts(i)%y > this%y1) then
				this%y1 = this%polygon%pts(i)%y
			end if
			if (this%polygon%pts(i)%z > this%z1) then
				this%z1 = this%polygon%pts(i)%z
			end if			
		end do
		
	end subroutine SetBoundary
	
	subroutine SetMaxError(this)
		implicit none
		class(GeoPolygonProc) :: this
		
		this%maxError = (abs(this%x0) + abs(this%x1) + &
    			         abs(this%y0) + abs(this%y1) + &
    			         abs(this%z0) + abs(this%z1)) / 6 * MaxUnitMeasureError; 
				 
	end subroutine SetMaxError
	
	subroutine SetFacePlanes(this)
		implicit none
		class(GeoPolygonProc) :: this
		
		logical :: isNewFace
		integer :: i, j, k, m, n, p, l, onLeftCount, onRightCount, numberOfFaces, maxFaceIndexCount
		real :: dis
		type(GeoPoint) :: p0, p1, p2, pt
		type(GeoPlane) :: trianglePlane, facePlane
		type(GeoFace) :: face
		type(GeoPoint), dimension(:), allocatable :: pts
		type(GeoPlane), dimension(:), allocatable :: fpOutward
		integer, dimension(:), allocatable :: &
			pointInSamePlaneIndex, verticeIndexInOneFace, faceVerticeIndexCount, idx
				
		! vertices indexes 2d array for all faces, 
		! varable face index is major dimension, fixed total number of vertices as minor dimension
		! vertices index is the original index value in the input polygon		
		integer, dimension(:,:), allocatable :: faceVerticeIndex 	
		
		! face planes for all faces defined with outward normal vector
		allocate(fpOutward(this%polygon%n))
				
		! indexes of other points that are in same plane 
		! with the 3 face triangle plane point
		allocate(pointInSamePlaneIndex(this%polygon%n - 3))
		
		! vertice indexes in one face
		maxFaceIndexCount = this%polygon%n -1
		allocate(verticeIndexInOneFace(maxFaceIndexCount))
		
		numberOfFaces = 0

		do i = 1, this%polygon%n
		 	
			! triangle point #1
			p0 = this%polygon%pts(i)

			do j = i + 1, this%polygon%n
			
				! triangle point #2
				p1 = this%polygon%pts(j)

				do k = j + 1, this%polygon%n
								
					! triangle point #3
					p2 = this%polygon%pts(k)

					call trianglePlane%initGeoPlane(p0, p1, p2)				
				
					onLeftCount = 0
					onRightCount = 0
					
					m = 0
					do l = 1, this%polygon%n
					 		
						! any point except the 3 triangle points
						if (l .ne. i .and. l .ne. j .and. l .ne. k) then
						
							pt = this%polygon%pts(l)

							dis = trianglePlane * pt
													
							! if point is in the triangle plane
							! add it to pointInSamePlaneIndex
							if (abs(dis) .lt. this%maxError ) then	
								m = m + 1							
								pointInSamePlaneIndex(m) = l								
							else							
								if (dis .lt. 0) then
									onLeftCount = onLeftCount + 1															
								else								
									onRightCount = onRightCount + 1
								end if
							end if
							
						end if
						
					end do
								
					n = 0
					do p = 1, maxFaceIndexCount
						verticeIndexInOneFace(p) = -1
					end do
					
					! This is a face for a CONVEX 3d polygon. 
					! For a CONCAVE 3d polygon, this maybe not a face.					
					if ((onLeftCount .eq. 0) .or. (onRightCount .eq. 0)) then
											
						! add 3 triangle plane point index
						n = n + 1
						verticeIndexInOneFace(n) = i
						n = n + 1
						verticeIndexInOneFace(n) = j
						n = n + 1
						verticeIndexInOneFace(n) = k
																				
						! if there are other vertices in this triangle plane
						! add them to the face plane
						if (m .gt. 0) then						
							do p = 1, m				
								n = n + 1
								verticeIndexInOneFace(n) = pointInSamePlaneIndex(p)
							end do
						end if
				
						! if verticeIndexInOneFace is a new face, 
						! add it in the faceVerticeIndex list, 
						! add the trianglePlane in the face plane list fpOutward
						!print *, n, size(verticeIndexInOneFace), size(faceVerticeIndex)
						isNewFace = .not. list2dContains(faceVerticeIndex, verticeIndexInOneFace, maxFaceIndexCount)
						
						if ( isNewFace ) then
												
							numberOfFaces = numberOfFaces + 1	
																				
							call push2d(faceVerticeIndex, verticeIndexInOneFace)
																											
							if (onRightCount .eq. 0) then			
								fpOutward(numberOfFaces) = trianglePlane													
							else if (onLeftCount .eq. 0) then							
								fpOutward(numberOfFaces) = -trianglePlane
							end if
							
							call push(faceVerticeIndexCount, n)
																					
						end if
					
					else
										
						! possible reasons:
						! 1. the plane is not a face of a convex 3d polygon, 
						!    it is a plane crossing the convex 3d polygon.
						! 2. the plane is a face of a concave 3d polygon
					end if

				end do ! k loop
			end do ! j loop		
		end do ! i loop                        

		! Number of Faces
		this%NumberOfFaces = numberOfFaces			
							
		allocate(this%FacePlanes(this%NumberOfFaces))
		allocate(this%Faces(this%NumberOfFaces))
		
		! loop faces
		do i = 1, this%NumberOfFaces 
		    
			! set FacePlanes	
			this%FacePlanes(i) = GeoPlane(fpOutward(i)%a, fpOutward(i)%b, &
									      fpOutward(i)%c, fpOutward(i)%d)
										 			
			! actual vertices count in the face
			n = faceVerticeIndexCount(i)
			
			allocate(pts(n))						
			allocate(idx(n))
								
			! loop face vertices
			do j = 1, n 
													
				k = faceVerticeIndex(i, j)												
				pt = GeoPoint(this%polygon%pts(k)%x, this%polygon%pts(k)%y, this%polygon%pts(k)%z)
								
				pts(j) = pt									
				idx(j) = k
				
			end do

			!set Faces			
			this%Faces(i) = GeoFace(pts, idx)			
			
			deallocate(pts)
			deallocate(idx)
			
		end do	
		
		deallocate(pointInSamePlaneIndex)
		deallocate(verticeIndexInOneFace)
		deallocate(faceVerticeIndex)
		deallocate(faceVerticeIndexCount)
		deallocate(fpOutward)
				
	end subroutine SetFacePlanes
	
	! main function to be called. check if a point is inside 3d polygon
	logical function PointInside3DPolygon(this, x, y, z) result(ret)

		implicit none
		class(GeoPolygonProc) :: this
		
    	real, intent(in) :: x, y, z    			
		integer i
		real :: dis

		! If the point is in the opposite half space with normal vector for all 6 faces, 
		! then it is inside of the 3D polygon
		ret = .true.
		
		do i = 1, this%NumberOfFaces										
			dis = this%FacePlanes(i) * GeoPoint(x, y, z) 
			! If the point is in the same half space with normal vector for any face of the 3D polygon, 
			! then it is outside of the 3D polygon		
			if (dis .gt. 0) then			
				ret = .false.
				exit
			end if
		end do
		        	
	end function PointInside3DPolygon
	
	! update maxError attribute valu of GeoPolygonProc object
	! maxError is used in SetFacePlanes to threshold a maximum distance to 
	! check the points nearby the triangle plane if being considered to be inside the triangle plane
	! maxError default value is calculated from polygon boundary in SetMaxError
	subroutine UpdateMaxError(this, maxError)
		implicit none
		class(GeoPolygonProc) :: this
		real, intent(in) :: maxError
		this%maxError = maxError
	end subroutine UpdateMaxError
	       
end module GeoPolygonProc_Module