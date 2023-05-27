cls

echo off

rem compile library 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\List.asm /Fo List.obj 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\src\ListUtility.asm /Fo ListUtility.obj 													

rem build library
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\lib.exe" /subsystem:console ^
													List.obj ListUtility.obj /out:.\lib\List.lib

rem compile test 
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\ml.exe" /I .\include ^
													/c .\ListTest.asm /Fo ListTest.obj 
													
rem build test													
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" ^
			/libpath:.\lib List.lib ^
			/libpath:"C:\Program Files\Microsoft Visual Studio 10.0\VC\lib" msvcrt.lib ^
			ListTest.obj /out:TestList.exe
													
													
del *.obj

