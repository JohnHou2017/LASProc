#include <tchar.h>

#include <iostream>
#include <fstream>

#include "GeoPolygonProc.h"
using namespace GeoProc;

GeoPolygonProc GetProcObj()
{
	// Initialize cube 
	GeoPoint CubeVerticesArray[8] =
	{  
		GeoPoint(-27.28046,         37.11775,        -39.03485),
		GeoPoint(-44.40014,         38.50727,        -28.78860),
		GeoPoint(-49.63065,         20.24757,        -35.05160),
		GeoPoint(-32.51096,         18.85805,        -45.29785),
		GeoPoint(-23.59142,         10.81737,        -29.30445),
		GeoPoint(-18.36091,         29.07707,        -23.04144),
		GeoPoint(-35.48060,         30.46659,        -12.79519),
		GeoPoint(-40.71110,         12.20689,        -19.05819)
	};

	// Create polygon object		
	std::vector<GeoPoint> verticesVector( CubeVerticesArray, 
		                  CubeVerticesArray + sizeof(CubeVerticesArray) / sizeof(GeoPoint) );
	GeoPolygon polygonObj = GeoPolygon(verticesVector);

	// Create main process object 
	GeoPolygonProc procObj = GeoPolygonProc(polygonObj);

	return procObj;
}

void ProcLAS(GeoPolygonProc procObj)
{	
	std::ifstream rbFile;
    rbFile.open("..\\LASInput\\cube.las",std::ios::binary|std::ios::in);
	
	std::fstream wbFile;
    wbFile.open("..\\LASOutput\\cube_inside.las",std::ios::binary|std::ios::out);
	
	std::ofstream wtFile;
    wtFile.open("..\\LASOutput\\cube_inside.txt",std::ios::out);
	wtFile.precision(4);
	
	// LAS public header variables
	unsigned long offset_to_point_data_value;
	unsigned long variable_len_num;
	unsigned char record_type_c;
	unsigned short record_len;
	unsigned long record_num;
	double x_scale, y_scale, z_scale;
	double x_offset, y_offset, z_offset;	
	
	// Offset bytes and data types are based on LAS 1.2 Format 
    
	// Read LAS public header
	rbFile.seekg(96);	     
    rbFile.read ((char *)&offset_to_point_data_value, 4);
	rbFile.read ((char *)&variable_len_num, 4);
	rbFile.read ((char *)&record_type_c, 1);
	rbFile.read ((char *)&record_len, 2);
	rbFile.read ((char *)&record_num, 4);
		
	rbFile.seekg(131);
	rbFile.read ((char *)&x_scale, 8);
	rbFile.read ((char *)&y_scale, 8);
	rbFile.read ((char *)&z_scale, 8);
	rbFile.read ((char *)&x_offset, 8);
	rbFile.read ((char *)&y_offset, 8);
	rbFile.read ((char *)&z_offset, 8);
	
	// LAS header buffer
	char *bufHeader = (char *)malloc(offset_to_point_data_value);
		
	// Get LAS header
	rbFile.seekg(0);
	rbFile.read(bufHeader, offset_to_point_data_value);
		
	// Write LAS header 
	wbFile.write(bufHeader, offset_to_point_data_value);
	
	// LAS point coordinates
	double x, y, z;        // LAS point actual coordinates			
	long xi, yi, zi;   // LAS point record coordinates

	// Number of inside points
	int insideCount = 0; 

	// Point record buffer
	char *bufRecord = (char *)malloc(record_len);					

	// Process point records
	for(unsigned int i=0;i<record_num;i++)
	{	

		int record_loc = offset_to_point_data_value + record_len * i;

		rbFile.seekg(record_loc);

		// Record coordinates
		rbFile.read ((char *)&xi, 4);
		rbFile.read ((char *)&yi, 4);
		rbFile.read ((char *)&zi, 4);		

		// Actual coordinates
		x = (xi * x_scale) + x_offset;
		y = (yi * y_scale) + y_offset;
		z = (zi * z_scale) + z_offset;	
															
		// Filter out the points outside of boundary to reduce computing
		if( x>procObj.GetX0() && x<procObj.GetX1() && 
			y>procObj.GetY0() && y<procObj.GetY1() && 
			z>procObj.GetZ0() && z<procObj.GetZ1())
		{					
			// Main Process to check if the point is inside of the cube				
			if(procObj.PointInside3DPolygon(x, y, z))
			{										
				// Write the actual coordinates of inside point to text file
				wtFile << std::fixed << x << " " << std::fixed << y	<< " " << std::fixed << z << std::endl;			

				// Get point record
				rbFile.seekg(record_loc);	
				rbFile.read(bufRecord, record_len);

				// Write point record to binary LAS file
				wbFile.write(bufRecord,  record_len);		
				insideCount++;
			}													
		}
					
	}
							
	// Update total record numbers in output binary LAS file
	wbFile.seekp(107);		
	wbFile.write((char *)&insideCount, 4);
								
	rbFile.close();		
	wbFile.close();
	wtFile.close();	

	free(bufHeader);
	free(bufRecord);		
	
}

int _tmain(int argc, _TCHAR* argv[])
{
	// Create procInst	
	GeoPolygonProc procObj = GetProcObj();
	
	// Process LAS
	ProcLAS(procObj);
	  
	return 0;
}







