cls
gfortran -c .\src\Utility.f03
gfortran -c .\src\GeoPoint.f03
gfortran -c .\src\GeoVector.f03 -I.
gfortran -c .\src\GeoPlane.f03 -I.
gfortran -c .\src\GeoPolygon.f03 -I.
gfortran -c .\src\GeoFace.f03 -I.
gfortran -c .\src\GeoPolygonProc.f03 -I.
gfortran -shared -mrtd -o GeoProc.dll *.o
del *.o 
move *.mod .\module
copy GeoProc.dll ..\GeoProcTest\bin
copy GeoProc.dll ..\LASProc\bin
move GeoProc.dll .\lib