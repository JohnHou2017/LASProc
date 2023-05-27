cls
gfortran -o LASProc.exe LASProc.f03 -I..\GeoProc\module -L..\GeoProc\lib -lGeoProc
move LASProc.exe .\bin