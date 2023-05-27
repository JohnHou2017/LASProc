program LASProc
	
	use GeoPoint_Module
	use GeoVector_Module
	use GeoPlane_Module
	use GeoPolygon_Module
	use GeoFace_Module
	use Utility_Module
    use GeoPolygonProc_Module
	
	implicit none
	
	! variables of GeoPolygonProc
	type(GeoPoint) :: p1, p2, p3, p4, p5, p6, p7, p8	
	type(GeoPoint), dimension(8) :: verticesArray	
	type(GeoPolygon) :: polygon 		
	type(GeoPolygonProc) :: procObj
		
	! variables of FILE IO
	integer (kind=4) :: xi, yi, zi
	integer (kind=4) :: offset_to_point_data_value, record_num	
	integer (kind=2) :: record_len	
	double precision :: x_scale, y_scale, z_scale, x_offset, y_offset, z_offset
	character, dimension(:), allocatable :: buf_header, buf_record
	
	! local variables
	integer :: i, j, insideCount, record_loc
	real :: x, y, z
		
	! get GeoPolygonProc object
	p1 = GeoPoint( - 27.28046,  37.11775,  - 39.03485)
	p2 = GeoPoint( - 44.40014,  38.50727,  - 28.78860)
	p3 = GeoPoint( - 49.63065,  20.24757,  - 35.05160)
	p4 = GeoPoint( - 32.51096,  18.85805,  - 45.29785)
	p5 = GeoPoint( - 23.59142,  10.81737,  - 29.30445)
	p6 = GeoPoint( - 18.36091,  29.07707,  - 23.04144)
	p7 = GeoPoint( - 35.48060,  30.46659,  - 12.79519)
	p8 = GeoPoint( - 40.71110,  12.20689,  - 19.05819)		
	verticesArray(1) = p1	
	verticesArray(2) = p2
	verticesArray(3) = p3
	verticesArray(4) = p4
	verticesArray(5) = p5
	verticesArray(6) = p6
	verticesArray(7) = p7
	verticesArray(8) = p8	
	polygon = GeoPolygon(verticesArray)
	call procObj%InitGeoPolygonProc(polygon);
	
	! process LAS file
	
	open(unit=1, file="..\..\LASInput\cube.las", status="OLD", access="STREAM")
	open(unit=2, file="..\..\LASOutput\cube_inside.las", status="REPLACE", access="STREAM")
	open(unit=3, file="..\..\LASOutput\cube_inside.txt", status="REPLACE", action = "write")	
	
	! Fortran Start Index is 1 while many of other languages Start Index is 0
	! The code for Array, File IO, Loop, etc, need to change when porting code from other language to Fortran.
	! Here is the example, in C/C++, the SEEK position is 96, but in Fortran, the read postion is 97
	read(1, pos = 97) offset_to_point_data_value
	
	read(1, pos = 106) record_len
	read(1, pos = 108) record_num			
	read(1, pos = 132) x_scale, y_scale, z_scale, x_offset, y_offset, z_offset
		
	allocate(buf_header(offset_to_point_data_value))
	allocate(buf_record(record_len))
	
	! read LAS header
	read(1, pos = 1) buf_header
	
	! write LAS header
	write(2) buf_header
	
	insideCount = 0

	do i = 0, record_num - 1
		
		! seek position
		record_loc = offset_to_point_data_value + record_len * i;
		
		! Fortran Start Index is 1
		! read position = seek position + 1
		read(1, pos = record_loc + 1) xi, yi, zi
		
		x = xi * x_scale + x_offset;
		y = yi * y_scale + y_offset;
		z = zi * z_scale + z_offset;
		
		if (x > procObj%x0 .and. x < procObj%x1 .and. &
			y > procObj%y0 .and. y < procObj%y1 .and. &
			z > procObj%z0 .and. z < procObj%z1 ) then
		
			if (procObj%PointInside3DPolygon(x, y, z)) then
			
				! read LAS Point record
				read(1, pos = record_loc + 1) buf_record
								
				! write LAS Point record
				write(2) buf_record
								
				! write text LAS Point record
				write(3, fmt='(F15.6, F15.6, F15.6)') x, y, z

				insideCount = insideCount + 1
				
			end if
			
		end if
		
	end do
	
	! update record_len in LAS header with actual writting record count	
	write(2, pos = 108) insideCount
		
	close(unit=1)
	close(unit=2)
	close(unit=3)
	
	deallocate(buf_header)
	deallocate(buf_record)

end program LASProc
	
	