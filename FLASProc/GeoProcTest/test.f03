program Test
	use GeoPoint_Module
	use GeoVector_Module
	use GeoPlane_Module
	use GeoPolygon_Module
	use GeoFace_Module
	use Utility_Module
    use GeoPolygonProc_Module
	
	implicit none
	    	
    type(GeoPoint) :: p1, p2, p3, p4, p5, p6, p7, p8, pt, insidePoint, outsidePoint		
	type(GeoVector) :: vt, v1, v2
	type(GeoPlane) :: pl
	real :: dis
	type(GeoPoint), dimension(8) :: verticesArray 
	type(GeoPolygon) :: polygon 	
	integer :: i, j, n
	type(GeoPoint), dimension(4) :: faceVerticesArray	
	integer, dimension(4) :: faceVerticeIndexArray
	type(GeoFace) :: face
	integer, dimension(:), allocatable :: arr1, arr2, arr3, arr4
	integer, dimension(:,:), allocatable :: arr2d
	logical :: b1, b2
	type(GeoPolygonProc) :: procObj
	
	
	p1 = GeoPoint( - 27.28046,  37.11775,  - 39.03485)
	p2 = GeoPoint( - 44.40014,  38.50727,  - 28.78860)
	p3 = GeoPoint( - 49.63065,  20.24757,  - 35.05160)
	p4 = GeoPoint( - 32.51096,  18.85805,  - 45.29785)
	p5 = GeoPoint( - 23.59142,  10.81737,  - 29.30445)
	p6 = GeoPoint( - 18.36091,  29.07707,  - 23.04144)
	p7 = GeoPoint( - 35.48060,  30.46659,  - 12.79519)
	p8 = GeoPoint( - 40.71110,  12.20689,  - 19.05819)
   	
	print *, "GeoPoint Test:"	
	pt = p1 + p2	
    print *, pt%x, pt%y, pt%z
	
	print *, "GeoVector Test:"
	v1 = GeoVector(p1, p2)
	v2 = GeoVector(p1, p3)
	vt = v2 * v1		    
	print *, get_x(vt), get_y(vt), get_z(vt)
	
	print *, "GeoPlane Test:"
	call pl%initGeoPlane(p1, p2, p3);
	print *, pl%a, pl%b, pl%c, pl%d	
	pl = GeoPlane(1.0, 2.0, 3.0, 4.0);
	print *, pl%a, pl%b, pl%c, pl%d	
	pl = -pl;
	print *, pl%a, pl%b, pl%c, pl%d	
	dis = pl * GeoPoint(1.0, 2.0, 3.0);
	print *, dis
	
	print *, "GeoPolygon Test:"	
	verticesArray(1) = p1	
	verticesArray(2) = p2
	verticesArray(3) = p3
	verticesArray(4) = p4
	verticesArray(5) = p5
	verticesArray(6) = p6
	verticesArray(7) = p7
	verticesArray(8) = p8	
	polygon = GeoPolygon(verticesArray)
	n = polygon%n	
	do i = 1, n
		print *, polygon%idx(i), ": (", polygon%pts(i)%x, ", ", polygon%pts(i)%y, ", ", polygon%pts(i)%z, ")"
	end do		
	
	print *, "GeoFace Test:"
	faceVerticesArray(1) = p1
	faceVerticesArray(2) = p2
	faceVerticesArray(3) = p3
	faceVerticesArray(4) = p4
	faceVerticeIndexArray = (/ 1, 2, 3, 4 /);	
	face = GeoFace(faceVerticesArray, faceVerticeIndexArray);
	n = face%n
	do i = 1, n
	print *, face%idx(i), ": (", face%pts(i)%x, ", ", face%pts(i)%y, ", ", face%pts(i)%z, ")"
	end do
	
	print *, "Utility Test:" 	
	call push(arr1, 1)
	call push(arr1, 2)
	call push(arr1, 3)
	call push(arr1, 4)
	arr2 = (/ 4, 5, 6, 7 /)
	arr3 = (/ 2, 3, 1, 4, 6 /)
	arr4 = (/ 2, 3, 1, 5, 7 /)	
	call push2d(arr2d, arr1)
	call push2d(arr2d, arr2)			
	b1 = list2dContains(arr2d, arr3, 4) 
	b2 = list2dContains(arr2d, arr4, 4) 
	print *, b1, b2
	
	print *, "GeoPolygonProc Test:"	
	call procObj%InitGeoPolygonProc(polygon);
	print *, procObj%x0, procObj%x1
	print *, procObj%y0, procObj%y1
	print *, procObj%z0, procObj%z1
	print *, procObj%maxError
	print *, procObj%NumberOfFaces	
	print *, "Face Planes:";
	do i = 1, procObj%NumberOfFaces
		print *, i, ": ", procObj%FacePlanes(i)%a, procObj%FacePlanes(i)%b, &
						  procObj%FacePlanes(i)%c, procObj%FacePlanes(i)%d
	end do
	print *, "Faces:"
	do i = 1, procObj%NumberOfFaces	
		print *, "Face #", i, ":"
		do j = 1, procObj%Faces(i)%n
			print *, procObj%Faces(i)%idx(j), ": (", procObj%Faces(i)%pts(j)%x, &
					 procObj%Faces(i)%pts(j)%y, procObj%Faces(i)%pts(j)%z
		end do	
	end do
	insidePoint = GeoPoint(-28.411750, 25.794500, -37.969000)
	outsidePoint = GeoPoint(-28.411750, 25.794500, -50.969000)
	b1 = procObj%PointInside3DPolygon(insidePoint%x, insidePoint%y, insidePoint%z)
	b2 = procObj%PointInside3DPolygon(outsidePoint%x, outsidePoint%y, outsidePoint%z)	
	print *, b1, ", ", b2
	
end program Test