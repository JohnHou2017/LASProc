cls

echo off

rem compile library 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\GeoPoint.asm /Fo GeoPoint.obj 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\GeoVector.asm /Fo GeoVector.obj 	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\GeoPlane.asm /Fo GeoPlane.obj 	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\GeoPolygon.asm /Fo GeoPolygon.obj 	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\GeoFace.asm /Fo GeoFace.obj 	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\GeoPolygonProc.asm /Fo GeoPolygonProc.obj 	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\ListGeoProc.asm /Fo ListGeoProc.obj 	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\List.asm /Fo List.obj 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\ListUtility.asm /Fo ListUtility.obj 													

rem build library
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\lib.exe" /subsystem:console /out:.\lib\GeoProc.lib ^
						GeoPoint.obj GeoVector.obj GeoPlane.obj GeoPolygon.obj GeoFace.obj GeoPolygonProc.obj ^
						ListGeoProc.obj List.obj ListUtility.obj 

rem compile test 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\ListTest.asm /Fo ListTest.obj 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\GeoProcTest.asm /Fo GeoProcTest.obj 													
													
rem build test													
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" /out:GeoProcTest.exe ^
			/libpath:.\lib GeoProc.lib ^
			/libpath:"C:\Program Files\Microsoft Visual Studio 10.0\VC\lib" msvcrt.lib ^
			GeoProcTest.obj ListTest.obj 
										
rem compile LASProc	
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\LASGeoProc.asm /Fo LASGeoProc.obj
													
rem build LASProc													
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" /out:LASGeoProc.exe ^
			/libpath:.\lib GeoProc.lib ^
			/libpath:"C:\Program Files\Microsoft Visual Studio 10.0\VC\lib" msvcrt.lib ^
			LASGeoProc.obj													
													
del *.obj

