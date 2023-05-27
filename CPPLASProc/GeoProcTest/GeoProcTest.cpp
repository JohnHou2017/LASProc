#include <tchar.h>

#include <iostream>

#include "GeoPolygonProc.h"
using namespace GeoProc;

GeoPoint p1 = GeoPoint( - 27.28046,  37.11775,  - 39.03485);
GeoPoint p2 = GeoPoint( - 44.40014,  38.50727,  - 28.78860);
GeoPoint p3 = GeoPoint( - 49.63065,  20.24757,  - 35.05160);
GeoPoint p4 = GeoPoint( - 32.51096,  18.85805,  - 45.29785);
GeoPoint p5 = GeoPoint( - 23.59142,  10.81737,  - 29.30445);
GeoPoint p6 = GeoPoint( - 18.36091,  29.07707,  - 23.04144);
GeoPoint p7 = GeoPoint( - 35.48060,  30.46659,  - 12.79519);
GeoPoint p8 = GeoPoint( - 40.71110,  12.20689,  - 19.05819);
GeoPoint verticesArray[8] = { p1, p2, p3, p4, p5, p6, p7, p8 };
std::vector<GeoPoint> verticesVector( verticesArray, verticesArray + sizeof(verticesArray) / sizeof(GeoPoint) );
GeoPolygon polygon = GeoPolygon(verticesVector);

void GeoPoint_Test()
{
	std::cout << "GeoPoint Test:" << std::endl;	
	GeoPoint pt = p1 + p2;	
	std::cout << pt.x << ", " << pt.y << ", " << pt.z << std::endl;
}

void GeoVector_Test()
{
	std::cout << "GeoVector Test:" << std::endl;
	GeoVector v1 = GeoVector(p1, p2);
	GeoVector v2 = GeoVector(p1, p3);
	GeoVector v3 = v2 * v1;
	std::cout << v3.GetX() << ", " << v3.GetY() << ", " << v3.GetZ() << std::endl;		
}

void GeoPlane_Test()
{
	std::cout << "GeoPlane Test:" << std::endl;
	GeoPlane pl  = GeoPlane(p1, p2, p3);
	std::cout << pl.a << ", " << pl.b << ", " << pl.c << ", " << pl.d << std::endl;	
	pl = GeoPlane(1.0, 2.0, 3.0, 4.0);
	std::cout << pl.a << ", " << pl.b << ", " << pl.c << ", " << pl.d << std::endl;	
	pl = -pl;
	std::cout << pl.a << ", " << pl.b << ", " << pl.c << ", " << pl.d << std::endl;	
	double dis = pl * GeoPoint(1.0, 2.0, 3.0);
	std::cout << dis << std::endl;	
}

void GeoPolygon_Test()
{
	std::cout << "GeoPolygon Test:" << std::endl;
	std::vector<int> idx = polygon.GetI();
	std::vector<GeoPoint> v = polygon.GetV();
	for(int i=0; i<polygon.GetN(); i++)
	{
		std::cout << idx[i] << ": (" << v[i].x << ", " << v[i].y << ", " << v[i].z << ")" << std::endl;
	}	
}

void GeoFace_Test()
{
	std::cout << "GeoFace Test:" << std::endl;
	GeoPoint faceVerticesArray[4] = { p1, p2, p3, p4 };
	std::vector<GeoPoint> faceVerticesVector( faceVerticesArray, faceVerticesArray + sizeof(faceVerticesArray) / sizeof(GeoPoint) );
	int faceVerticeIndexArray[4] = { 1, 2, 3, 4 };
	std::vector<int> faceVerticeIndexVector( faceVerticeIndexArray, faceVerticeIndexArray + sizeof(faceVerticeIndexArray) / sizeof(int) );
	GeoFace face = GeoFace(faceVerticesVector, faceVerticeIndexVector);
	std::vector<int> idx = face.GetI();
	std::vector<GeoPoint> v = face.GetV();
	for(int i=0; i<face.GetN(); i++)
	{
		std::cout << idx[i] << ": (" << v[i].x << ", " << v[i].y << ", " << v[i].z << ")" << std::endl;
	}	
}

void Utility_Test()
{
	std::cout << "Utility Test:" << std::endl;
	int arr1[4] = { 1, 2, 3, 4 };
	std::vector<int> arr1Vector( arr1, arr1 + sizeof(arr1) / sizeof(int) );
	int arr2[4] = { 4, 5, 6, 7 };
	std::vector<int> arr2Vector( arr2, arr2 + sizeof(arr2) / sizeof(int) );
	std::vector<std::vector<int>> vector_2d;
	vector_2d.push_back(arr1Vector);
	vector_2d.push_back(arr2Vector);
	int arr3[4] = { 2, 3, 1, 4 };
	std::vector<int> arr3Vector( arr3, arr3 + sizeof(arr3) / sizeof(int) );
	int arr4[4] = { 2, 3, 1, 5 };
	std::vector<int> arr4Vector( arr4, arr4 + sizeof(arr4) / sizeof(int) );
	bool b1 = Utility::ContainsVector(vector_2d, arr3Vector);
	bool b2 = Utility::ContainsVector(vector_2d, arr4Vector);
	std::cout << b1 << ", " << b2 << std::endl;
	std::cout << arr1Vector.size() << std::endl;
	Utility::FreeVectorMemory<int>(arr1Vector);	
	std::cout << arr1Vector.size() << std::endl;
	std::cout << vector_2d.size() << std::endl;
	Utility::FreeVectorListMemory<int>(vector_2d);	
	std::cout << vector_2d.size() << std::endl;
}

void GeoPolygonProc_Test()
{
	std::cout << "GeoPolygonProc Test:" << std::endl;
	GeoPolygonProc procObj = GeoPolygonProc(polygon);
	std::cout << procObj.GetX0() << ", " << procObj.GetX1() << ", " << 
		         procObj.GetY0() << ", " << procObj.GetY1() << ", " << 
				 procObj.GetZ0() << ", " << procObj.GetZ1() << ", " << std::endl;
	std::cout << procObj.GetMaxDisError() << std::endl;
	procObj.SetMaxDisError(0.0125);
	std::cout << procObj.GetMaxDisError() << std::endl;
	int count = procObj.GetNumberOfFaces();
	std::vector<GeoPlane> facePlanes = procObj.GetFacePlanes();
	std::vector<GeoFace> faces = procObj.GetFaces();
	std::cout << count << std::endl;
	std::cout << "Face Planes:" << std::endl;
	for(int i=0; i<count; i++)
	{
		std::cout << facePlanes[i].a << ", " << facePlanes[i].b << ", " <<
			         facePlanes[i].a << ", " << facePlanes[i].d << std::endl;
	}
	std::cout << "Faces:" << std::endl;
	for(int i=0; i<count; i++)
	{
		std::cout << "Face #" << i + 1 << " :" <<std::endl;
		GeoFace face = faces[i];
		std::vector<int> idx = face.GetI();
		std::vector<GeoPoint> v = face.GetV();
		for(int i=0; i<face.GetN(); i++)
		{
			std::cout << idx[i] << ": (" << v[i].x << ", " << v[i].y << ", " << v[i].z << ")" << std::endl;
		}			
	}
	GeoPoint insidePoint = GeoPoint( - 28.411750,     25.794500,      - 37.969000);
	GeoPoint outsidePoint = GeoPoint( - 28.411750,    25.794500,      - 50.969000);
	bool b1 = procObj.PointInside3DPolygon(insidePoint.x, insidePoint.y, insidePoint.z);
	bool b2 = procObj.PointInside3DPolygon(outsidePoint.x, outsidePoint.y, outsidePoint.z);
	std::cout << b1 << ", " << b2 << std::endl;
}

int _tmain(int argc, _TCHAR* argv[])
{
	GeoPoint_Test();
	GeoVector_Test();
	GeoPlane_Test();
	GeoPolygon_Test();
	GeoFace_Test();
	Utility_Test();
	GeoPolygonProc_Test();
}