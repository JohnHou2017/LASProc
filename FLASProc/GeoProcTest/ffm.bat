cls
gfortran -o test.exe test.f03 -I..\GeoProc\module -L..\GeoProc\lib -lGeoProc
move test.exe .\bin